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
// FaceTrackingVid.cpp : Defines the entry point for the console application for tracking faces in videos.

// Libraries for landmark detection (includes CLNF and CLM modules)
#include "LandmarkCoreIncludes.h"
#include "GazeEstimation.h"
#include <FaceAnalyser.h>


#include <SequenceCapture.h>
#include <Visualizer.h>
#include <VisualizationUtils.h>
#include <RecorderOpenFace.h>
#include <RecorderOpenFaceParameters.h>
#include <iostream>
#include <fstream>

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

std::vector<std::string> get_arguments(int argc, std::string *out_dir, char **argv)
{

	std::vector<std::string> arguments;

	for (int i = 0; i < argc; ++i)
	{
		arguments.push_back(std::string(argv[i]));
        if (std::string(argv[i]).compare("-out_dir") == 0)
        {
            *out_dir = std::string(argv[i+1]);
        }
                
	}
	return arguments;
}


int main(int argc, char **argv)
{

    

    std::string out_dir = ".";
                
	std::vector<std::string> arguments = get_arguments(argc, &out_dir, argv);
    

    std::cout<< "out_dir:" << out_dir <<std::endl;
	// no arguments: output usage
	if (arguments.size() == 1)
	{
		std::cout << "For command line arguments see:" << std::endl;
		std::cout << " https://github.com/TadasBaltrusaitis/OpenFace/wiki/Command-line-arguments";
		return 0;
	}

	LandmarkDetector::FaceModelParameters det_parameters(arguments);

	// The modules that are being used for tracking
	LandmarkDetector::CLNF face_model(det_parameters.model_location);
	if (!face_model.loaded_successfully)
	{
		std::cout << "ERROR: Could not load the landmark detector" << std::endl;
		return 1;
	}

	if (!face_model.eye_model)
	{
		std::cout << "WARNING: no eye model found" << std::endl;
	}

	// Open a sequence
	Utilities::SequenceCapture sequence_reader;
    
    
 

	// A utility for visualizing the results (show just the tracks)
	Utilities::Visualizer visualizer(true, false, false, false);

	// Tracking FPS for visualization
	Utilities::FpsTracker fps_tracker;
	fps_tracker.AddFrame();

	int sequence_number = 0;
    std::string ext = ".mp4";

	
	while (true) // this is not a for loop as we might also be reading from a webcam
	{

		// The sequence reader chooses what to open based on command line arguments provided
		if (!sequence_reader.Open(arguments))
			break;

		INFO_STREAM("Device or file opened");

		cv::Mat rgb_image = sequence_reader.GetNextFrame();

		INFO_STREAM("Starting tracking");
        
        std::ofstream results;
        std::ofstream confidence;
        
        std::string path = sequence_reader.name;
        
        std::string base_filename = path.substr(path.find_last_of("/\\") + 1);
        base_filename = base_filename.replace(base_filename.find(ext),sizeof(ext)-1,"");
        results.open(out_dir + '/' + base_filename + "_landmark_output.csv");
        confidence.open(out_dir + '/' + base_filename +  "_landmark_likelihoods.csv");
        int lx = 0;
        int ly = 0;
        for(lx = 0; lx < 2; lx++){
            for(ly = 0; ly < 68; ly++){

                if (lx == 0){
                    results << "l" << ly << "_x,";
                    confidence << "c" << ly <<",";
                }
                if (lx == 1){
                    results << "l" << ly << "_y,";
                }
            }
        }
        results << "pose_Tx,pose_Ty,pose_Tz,pose_Rx,pose_Ry,pose_Rz" ;
        results << std::endl; 
        confidence << std::endl;
        
		int counter = 0;
        
//         FaceAnalysis::FaceAnalyserParameters face_analysis_params(arguments);
//         face_analysis_params.OptimizeForImages();
//         FaceAnalysis::FaceAnalyser face_analyser(face_analysis_params);        
        
        
        
        
        
        
		while (!rgb_image.empty()) // this is not a for loop as we might also be reading from a webcam
		{

			// Added lines
// 			Utilities::RecorderOpenFaceParameters recording_params(arguments, false, false,
// 			sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy);
// 			std::string stem = sequence_reader.name;
// 			stem = stem.replace(stem.find(ext),sizeof(ext)-1,"_");
// 			Utilities::RecorderOpenFace open_face_rec(stem+std::to_string(counter)+ext, recording_params, arguments);
			
			// Reading the images
			cv::Mat_<uchar> grayscale_image = sequence_reader.GetGrayFrame();


			// The actual facial landmark detection / tracking
            
			bool detection_success = LandmarkDetector::DetectLandmarksInVideo(rgb_image, face_model, det_parameters, grayscale_image);            
            
            
			// Gaze tracking, absolute gaze direction
			cv::Point3f gazeDirection0(0, 0, -1);
			cv::Point3f gazeDirection1(0, 0, -1);

			// If tracking succeeded and we have an eye model, estimate gaze
			if (detection_success && face_model.eye_model)
			{
				GazeAnalysis::EstimateGaze(face_model, gazeDirection0, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy, true);
				GazeAnalysis::EstimateGaze(face_model, gazeDirection1, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy, false);
			}

			// Work out the pose of the head from the tracked model

			cv::Vec6d pose_estimate = LandmarkDetector::GetPose(face_model, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy);
            
            
            
            
// 			cv::Mat sim_warped_img;
//             face_analyser.PredictStaticAUsAndComputeFeatures(rgb_image, face_model.detected_landmarks);
//             face_analyser.GetLatestAlignedFace(sim_warped_img);            
            
            

			// Keeping track of FPS
			fps_tracker.AddFrame();

			// Displaying the tracking visualizations
//             std::cout<< "setting observation landmarks"<<std::endl;
			visualizer.SetImage(rgb_image, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy);
			visualizer.SetObservationLandmarks(face_model.detected_landmarks, face_model.detection_certainty, face_model.GetVisibilities());
			visualizer.SetObservationPose(pose_estimate, face_model.detection_certainty);
			visualizer.SetObservationGaze(gazeDirection0, gazeDirection1, LandmarkDetector::CalculateAllEyeLandmarks(face_model), LandmarkDetector::Calculate3DEyeLandmarks(face_model, sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy), face_model.detection_certainty);
			visualizer.SetFps(fps_tracker.GetFPS());
            
//             std::cout << "openfacerec set obs landmarks"<<std::endl;
//             std::cout<< fps_tracker.GetFPS() <<std::endl;

// 			open_face_rec.SetObservationLandmarks(face_model.detected_landmarks, face_model.GetShape(sequence_reader.fx, sequence_reader.fy, sequence_reader.cx, sequence_reader.cy),
// 				face_model.params_global, face_model.params_local, face_model.detection_certainty, face_model.detection_success);
// 			open_face_rec.SetObservationPose(pose_estimate);
//             open_face_rec.SetObservationFaceAlign(sim_warped_img);

            
            int i;
			for (i=0;i< 136;i++){             
				results << face_model.detected_landmarks[0][i] << ",";
			}     
			for (i=0;i< 6;i++){             
                if (i==5){
                    results << pose_estimate[i];

                }
                else{
				results << pose_estimate[i] << ",";
                }
			}                
			results <<std::endl;
            
            for(i=0;i<68;i++){
                if (i==67){
                confidence << face_model.landmark_likelihoods[0][i];
                }
                else{
                confidence << face_model.landmark_likelihoods[0][i] << ",";
                }
            }
            confidence <<std::endl;

			// detect key presses (due to pecularities of OpenCV, you can get it when displaying images)
			//char character_press = visualizer.ShowObservation();
			char character_press = 't';
			// restart the tracker
			if (character_press == 'r')
			{
				face_model.Reset();
			}
			// quit the application
			else if (character_press == 'q')
			{
				return(0);
			}

			// added lines
// 			open_face_rec.SetObservationVisualization(visualizer.GetVisImage());
// 			open_face_rec.WriteObservationTracked();

// 			open_face_rec.Close();


			// Grabbing the next frame in the sequence
			rgb_image = sequence_reader.GetNextFrame();
			counter++;
		}

		// Reset the model, for the next video
		face_model.Reset();
		sequence_reader.Close();
    
		sequence_number++;
        results.close();

	}
	return 0;
}

