///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2017, Carnegie Mellon University and University of Cambridge,
// all rights reserved.
//
// ACADEMIC OR NON-PROFIT ORGANIZATION NONCOMMERCIAL RESEARCH USE ONLY
//
// BY USING OR DOWNLOADING THE SOFTWARE, YOU ARE AGREEING TO THE TERMS OF THIS LICENSE AGREEMENT.  
// IF YOU DO NOT AGREE WITH THESE TERMS, YOU MAY NOT USE OR DOWNLOAD THE SOFTWARE.
//
// License can be found in OpenFace-license.txt

//     * Any publications arising from the use of this software, including but
//       not limited to academic journal and conference publications, technical
//       reports and manuals, must cite at least one of the following works:
//
//       OpenFace 2.0: Facial Behavior Analysis Toolkit
//       Tadas Baltrušaitis, Amir Zadeh, Yao Chong Lim, and Louis-Philippe Morency
//       in IEEE International Conference on Automatic Face and Gesture Recognition, 2018  
//
//       Convolutional experts constrained local model for facial landmark detection.
//       A. Zadeh, T. Baltrušaitis, and Louis-Philippe Morency,
//       in Computer Vision and Pattern Recognition Workshops, 2017.    
//
//       Rendering of Eyes for Eye-Shape Registration and Gaze Estimation
//       Erroll Wood, Tadas Baltrušaitis, Xucong Zhang, Yusuke Sugano, Peter Robinson, and Andreas Bulling 
//       in IEEE International. Conference on Computer Vision (ICCV),  2015 
//
//       Cross-dataset learning and person-specific normalisation for automatic Action Unit detection
//       Tadas Baltrušaitis, Marwa Mahmoud, and Peter Robinson 
//       in Facial Expression Recognition and Analysis Challenge, 
//       IEEE International Conference on Automatic Face and Gesture Recognition, 2015 
//
///////////////////////////////////////////////////////////////////////////////


// FaceTrackingVidMulti.cpp : Defines the entry point for the multiple face tracking console application.
#include "LandmarkCoreIncludes.h"

#include "VisualizationUtils.h"
#include "Visualizer.h"
#include "SequenceCapture.h"
#include <RecorderOpenFace.h>
#include <RecorderOpenFaceParameters.h>
#include <GazeEstimation.h>
#include <FaceAnalyser.h>

#define INFO_STREAM( stream ) \
std::cout << stream << std::endl

#define WARN_STREAM( stream ) \
std::cout << "Warning: " << stream << std::endl

#define ERROR_STREAM( stream ) \
std::cout << "Error: " << stream << std::endl

static void printErrorAndAbort(const std::string & error)
{
	std::cout << error << std::endl;
	abort();
}

#define FATAL_STREAM( stream ) \
printErrorAndAbort( std::string( "Fatal error: " ) + stream )

std::vector<std::string> get_arguments(int argc, char **argv)
{

	std::vector<std::string> arguments;

	for (int i = 0; i < argc; ++i)
	{
		arguments.push_back(std::string(argv[i]));
	}
	return arguments;
}

double IOU(cv::Rect_<float> rect1, cv::Rect_<float> rect2)
{
	double intersection_area = (rect1 & rect2).area();
	double union_area = rect1.area() + rect2.area() - intersection_area;
	return intersection_area / union_area;
}

void RemoveOverlapingModels(std::vector<LandmarkDetector::CLNF>& face_models, std::vector<bool>& active_models)
{
	// Go over the model and eliminate detections that are not informative (there already is a tracker there)
	for (size_t model1 = 0; model1 < active_models.size(); ++model1)
	{
		if (active_models[model1])
		{
			// See if the detections intersect
			cv::Rect_<float> model1_rect = face_models[model1].GetBoundingBox();

			for (int model2 = model1 + 1; model2 < active_models.size(); ++model2)
			{
				if(active_models[model2])
				{
					cv::Rect_<float> model2_rect = face_models[model2].GetBoundingBox();

					// If the model is already tracking what we're detecting ignore the detection, this is determined by amount of overlap
					if (IOU(model1_rect, model2_rect) > 0.5)
					{
						active_models[model1] = false;
						face_models[model1].Reset();
					}
				}
			}
		}
	}

}

void NonOverlapingDetections(const std::vector<LandmarkDetector::CLNF>& clnf_models, std::vector<cv::Rect_<float> >& face_detections)
{

	// Go over the model and eliminate detections that are not informative (there already is a tracker there)
	for (size_t model = 0; model < clnf_models.size(); ++model)
	{

		// See if the detections intersect
		cv::Rect_<float> model_rect = clnf_models[model].GetBoundingBox();

		for (int detection = face_detections.size() - 1; detection >= 0; --detection)
		{
			// If the model is already tracking what we're detecting ignore the detection, this is determined by amount of overlap
			if (IOU(model_rect, face_detections[detection]) > 0.5)
			{
				face_detections.erase(face_detections.begin() + detection);
			}
		}
	}
}

int main(int argc, char **argv)
{

	std::vector<std::string> arguments = get_arguments(argc, argv);

	// no arguments: output usage
	if (arguments.size() == 1)
	{
		std::cout << "For command line arguments see:" << std::endl;
		std::cout << " https://github.com/TadasBaltrusaitis/OpenFace/wiki/Command-line-arguments";
		return 0;
	}

	LandmarkDetector::FaceModelParameters det_params(arguments);
	// This is so that the model would not try re-initialising itself
	det_params.reinit_video_every = -1;

	det_params.curr_face_detector = LandmarkDetector::FaceModelParameters::MTCNN_DETECTOR;

	std::vector<LandmarkDetector::FaceModelParameters> det_parameters;
	det_parameters.push_back(det_params);

	// The modules that are being used for tracking
	std::vector<LandmarkDetector::CLNF> face_models;
	std::vector<bool> active_models;

	int num_faces_max = 4;

	LandmarkDetector::CLNF face_model(det_parameters[0].model_location);

	if (!face_model.loaded_successfully)
	{
		std::cout << "ERROR: Could not load the landmark detector" << std::endl;
		return 1;
	}

	// Loading the face detectors
	face_model.face_detector_HAAR.load(det_parameters[0].haar_face_detector_location);
	face_model.haar_face_detector_location = det_parameters[0].haar_face_detector_location;
	face_model.face_detector_MTCNN.Read(det_parameters[0].mtcnn_face_detector_location);
	face_model.mtcnn_face_detector_location = det_parameters[0].mtcnn_face_detector_location;

	// If can't find MTCNN face detector, default to HOG one
	if (det_parameters[0].curr_face_detector == LandmarkDetector::FaceModelParameters::MTCNN_DETECTOR && face_model.face_detector_MTCNN.empty())
	{
		std::cout << "INFO: defaulting to HOG-SVM face detector" << std::endl;
		det_parameters[0].curr_face_detector = LandmarkDetector::FaceModelParameters::HOG_SVM_DETECTOR;
	}

	face_models.reserve(num_faces_max);

	face_models.push_back(face_model);
	active_models.push_back(false);

	for (int i = 1; i < num_faces_max; ++i)
	{
		face_models.push_back(face_model);
		active_models.push_back(false);
		det_parameters.push_back(det_params);
	}

	// Load facial feature extractor and AU analyser (make sure it is static, as we don't reidentify faces)
	FaceAnalysis::FaceAnalyserParameters face_analysis_params(arguments);
	face_analysis_params.OptimizeForImages();
	FaceAnalysis::FaceAnalyser face_analyser(face_analysis_params);

	if (!face_model.eye_model)
	{
		std::cout << "WARNING: no eye model found" << std::endl;
	}

	if (face_analyser.GetAUClassNames().size() == 0 && face_analyser.GetAUClassNames().size() == 0)
	{
		std::cout << "WARNING: no Action Unit models found" << std::endl;
	}

	// Open a sequence
	Utilities::SequenceCapture sequence_reader;

	// A utility for visualizing the results (show just the tracks)
	Utilities::Visualizer visualizer(arguments);

	// Tracking FPS for visualization
	Utilities::FpsTracker fps_tracker;
	fps_tracker.AddFrame();

	int sequence_number = 0;
	
	
	while (true) // this is not a for loop as we might also be reading from a webcam
	{
		// The sequence reader chooses what to open based on command line arguments provided
		if (!sequence_reader.Open(arguments))
			break;

		INFO_STREAM("Device or file opened");

		cv::Mat rgb_image = sequence_reader.GetNextFrame();

		int frame_count = 0;

		Utilities::RecorderOpenFaceParameters recording_params(arguments, true, sequence_reader.IsWebcam(),
			sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy, sequence_reader.fps);

		if (!face_model.eye_model)
		{
			recording_params.setOutputGaze(false);
		}

		Utilities::RecorderOpenFace open_face_rec(sequence_reader.name, recording_params, arguments);

		if (sequence_reader.IsWebcam())
		{
			INFO_STREAM("WARNING: using a webcam in feature extraction, forcing visualization of tracking to allow quitting the application (press q)");
			visualizer.vis_track = true;
		}

		if (recording_params.outputAUs())
		{
			INFO_STREAM("WARNING: using a AU detection in multiple face mode, it might not be as accurate and is experimental");
		}

		// For reporting progress
		double reported_completion = 0;

		INFO_STREAM("Starting tracking");
		while (!rgb_image.empty())
		{

			// Reading the images
			cv::Mat_<uchar> grayscale_image = sequence_reader.GetGrayFrame();

			std::vector<cv::Rect_<float> > face_detections;

			bool all_models_active = true;
			for (unsigned int model = 0; model < face_models.size(); ++model)
			{
				if (!active_models[model])
				{
					all_models_active = false;
				}
			}

			// Get the detections (every 8th frame and when there are free models available for tracking)
			if (frame_count % 8 == 0 && !all_models_active)
			{
				if (det_parameters[0].curr_face_detector == LandmarkDetector::FaceModelParameters::HOG_SVM_DETECTOR)
				{
					std::vector<float> confidences;
					LandmarkDetector::DetectFacesHOG(face_detections, grayscale_image, face_models[0].face_detector_HOG, confidences);
				}
				else if (det_parameters[0].curr_face_detector == LandmarkDetector::FaceModelParameters::HAAR_DETECTOR)
				{
					LandmarkDetector::DetectFaces(face_detections, grayscale_image, face_models[0].face_detector_HAAR);
				}
				else
				{
					std::vector<float> confidences;
					LandmarkDetector::DetectFacesMTCNN(face_detections, rgb_image, face_models[0].face_detector_MTCNN, confidences);
				}

			}

			// Keep only non overlapping detections (so as not to start tracking where the face is already tracked)
			NonOverlapingDetections(face_models, face_detections);
			std::vector<bool> face_detections_used(face_detections.size(), false);

			// Go through every model and update the tracking
			for (unsigned int model = 0; model < face_models.size(); ++model)
			{

				bool detection_success = false;

				// If the current model has failed more than 4 times in a row, remove it
				if (face_models[model].failures_in_a_row > 4)
				{
					active_models[model] = false;
					face_models[model].Reset();
				}

				// If the model is inactive reactivate it with new detections
				if (!active_models[model])
				{

					for (size_t detection_ind = 0; detection_ind < face_detections.size(); ++detection_ind)
					{
						// if it was not taken by another tracker take it
						if (!face_detections_used[detection_ind])
						{
							face_detections_used[detection_ind] = true;

							// Reinitialise the model
							face_models[model].Reset();

							// This ensures that a wider window is used for the initial landmark localisation
							face_models[model].detection_success = false;
							detection_success = LandmarkDetector::DetectLandmarksInVideo(rgb_image, face_detections[detection_ind], face_models[model], det_parameters[model], grayscale_image);

							// This activates the model
							active_models[model] = true;

							// break out of the loop as the tracker has been reinitialised
							break;
						}

					}
				}
				else
				{
					// The actual facial landmark detection / tracking
					detection_success = LandmarkDetector::DetectLandmarksInVideo(rgb_image, face_models[model], det_parameters[model], grayscale_image);
				}
			}

			// Remove models that end up tracking overlapping faces
			// even if initial bounding boxes were not overlapping, they could have ended up converging to the same face
			RemoveOverlapingModels(face_models, active_models);

			// Keeping track of FPS
			fps_tracker.AddFrame();

			visualizer.SetImage(rgb_image, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy);

			// Go through every model and detect eye gaze, record results and visualise the results
			for (size_t model = 0; model < face_models.size(); ++model)
			{
				// Visualising and recording the results
				if (active_models[model])
				{

					// Estimate head pose and eye gaze				
					cv::Vec6d pose_estimate = LandmarkDetector::GetPose(face_models[model], sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy);

					cv::Point3f gaze_direction0(0, 0, 0); cv::Point3f gaze_direction1(0, 0, 0); cv::Vec2d gaze_angle(0, 0);

					// Detect eye gazes
					if (face_models[model].detection_success && face_model.eye_model)
					{
						GazeAnalysis::EstimateGaze(face_models[model], gaze_direction0, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy, true);
						GazeAnalysis::EstimateGaze(face_models[model], gaze_direction1, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy, false);
						gaze_angle = GazeAnalysis::GetGazeAngle(gaze_direction0, gaze_direction1);
					}

					// Face analysis step
					cv::Mat sim_warped_img;
					cv::Mat_<double> hog_descriptor; int num_hog_rows = 0, num_hog_cols = 0;

					// Perform AU detection and HOG feature extraction, as this can be expensive only compute it if needed by output or visualization
					if (recording_params.outputAlignedFaces() || recording_params.outputHOG() || recording_params.outputAUs() || visualizer.vis_align || visualizer.vis_hog)
					{
						face_analyser.PredictStaticAUsAndComputeFeatures(rgb_image, face_models[model].detected_landmarks);
						face_analyser.GetLatestAlignedFace(sim_warped_img);
						face_analyser.GetLatestHOG(hog_descriptor, num_hog_rows, num_hog_cols);
					}

					// Visualize the features
					visualizer.SetObservationFaceAlign(sim_warped_img);
					visualizer.SetObservationHOG(hog_descriptor, num_hog_rows, num_hog_cols);
					visualizer.SetObservationLandmarks(face_models[model].detected_landmarks, face_models[model].detection_certainty);
					visualizer.SetObservationPose(LandmarkDetector::GetPose(face_models[model], sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy), face_models[model].detection_certainty);
					visualizer.SetObservationGaze(gaze_direction0, gaze_direction1, LandmarkDetector::CalculateAllEyeLandmarks(face_models[model]), LandmarkDetector::Calculate3DEyeLandmarks(face_models[model], sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy), face_models[model].detection_certainty);
					visualizer.SetObservationActionUnits(face_analyser.GetCurrentAUsReg(), face_analyser.GetCurrentAUsClass());

					// Output features
					open_face_rec.SetObservationHOG(face_models[model].detection_success, hog_descriptor, num_hog_rows, num_hog_cols, 31); // The number of channels in HOG is fixed at the moment, as using FHOG
					open_face_rec.SetObservationActionUnits(face_analyser.GetCurrentAUsReg(), face_analyser.GetCurrentAUsClass());
					open_face_rec.SetObservationLandmarks(face_models[model].detected_landmarks, face_models[model].GetShape(sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy),
						face_models[model].params_global, face_models[model].params_local, face_models[model].detection_certainty, face_models[model].detection_success);
					open_face_rec.SetObservationPose(pose_estimate);
					open_face_rec.SetObservationGaze(gaze_direction0, gaze_direction1, gaze_angle, LandmarkDetector::CalculateAllEyeLandmarks(face_models[model]), LandmarkDetector::Calculate3DEyeLandmarks(face_models[model], sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy));
					open_face_rec.SetObservationFaceAlign(sim_warped_img);
					open_face_rec.SetObservationFaceID(model);
					open_face_rec.SetObservationTimestamp(sequence_reader.time_stamp);
					open_face_rec.SetObservationFrameNumber(sequence_reader.GetFrameNumber());
					open_face_rec.WriteObservation();

				}
			}

			visualizer.SetFps(fps_tracker.GetFPS());

			// Record frame
			open_face_rec.SetObservationVisualization(visualizer.GetVisImage());
			open_face_rec.WriteObservationTracked();

			// show visualization and detect key presses
			char character_press = visualizer.ShowObservation();

			// restart the trackers
			if (character_press == 'r')
			{
				for (size_t i = 0; i < face_models.size(); ++i)
				{
					face_models[i].Reset();
					active_models[i] = false;
				}
			}
			// quit the application
			else if (character_press == 'q')
			{
				return 0;
			}

			// Reporting progress
			if (sequence_reader.GetProgress() >= reported_completion / 10.0)
			{
				std::cout << reported_completion * 10 << "% ";
				if (reported_completion == 10)
				{
					std::cout << std::endl;
				}
				reported_completion = reported_completion + 1;
			}

			// Update the frame count
			frame_count++;

			// Grabbing the next frame in the sequence
			rgb_image = sequence_reader.GetNextFrame();

		}

		frame_count = 0;

		// Reset the model, for the next video
		for (size_t model = 0; model < face_models.size(); ++model)
		{
			face_models[model].Reset();
			active_models[model] = false;
		}

		INFO_STREAM("Closing output recorder");
		open_face_rec.Close();
		INFO_STREAM("Closing input reader");
		sequence_reader.Close();
		INFO_STREAM("Closed successfully");

		sequence_number++;

	}

	return 0;
}

