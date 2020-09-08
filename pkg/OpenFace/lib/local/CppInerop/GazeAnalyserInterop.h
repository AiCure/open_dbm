#pragma once
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

#ifndef GAZE_ANALYSER_INTEROP_H
#define GAZE_ANALYSER_INTEROP_H

#pragma once

// Include all the unmanaged things we need.
#pragma managed

#include <msclr\marshal.h>
#include <msclr\marshal_cppstd.h>

#pragma unmanaged

#include <opencv2/opencv.hpp>

#include <OpenCVWrappers.h>
#include <LandmarkDetectorInterop.h>
#include <GazeEstimation.h>

#pragma managed

namespace GazeAnalyser_Interop {

	public ref class GazeAnalyserManaged
	{

	private:

		// Variable storing gaze for recording

		// Absolute gaze direction
		cv::Point3f* gazeDirection0;
		cv::Point3f* gazeDirection1;
		cv::Vec2f* gazeAngle;

		cv::Point3f* pupil_left;
		cv::Point3f* pupil_right;

	public:
		GazeAnalyserManaged()
		{
			gazeDirection0 = new cv::Point3f();
			gazeDirection1 = new cv::Point3f();
			gazeAngle = new cv::Vec2f();

			pupil_left = new cv::Point3f();
			pupil_right = new cv::Point3f();
		}

		void AddNextFrame(CppInterop::LandmarkDetector::CLNF^ clnf, bool success, float fx, float fy, float cx, float cy) {

			// After the AUs have been detected do some gaze estimation as well
			GazeAnalysis::EstimateGaze(*clnf->getCLNF(), *gazeDirection0, fx, fy, cx, cy, true);
			GazeAnalysis::EstimateGaze(*clnf->getCLNF(), *gazeDirection1, fx, fy, cx, cy, false);

			// Estimate the gaze angle WRT to head pose here
			System::Collections::Generic::List<float>^ pose_list = gcnew System::Collections::Generic::List<float>();

			*gazeAngle = GazeAnalysis::GetGazeAngle(*gazeDirection0, *gazeDirection1);

			// Grab pupil locations
			int part_left = -1;
			int part_right = -1;
			for (size_t i = 0; i < clnf->getCLNF()->hierarchical_models.size(); ++i)
			{
				if (clnf->getCLNF()->hierarchical_model_names[i].compare("left_eye_28") == 0)
				{
					part_left = i;
				}
				if (clnf->getCLNF()->hierarchical_model_names[i].compare("right_eye_28") == 0)
				{
					part_right = i;
				}
			}

			cv::Mat_<float> eyeLdmks3d_left = clnf->getCLNF()->hierarchical_models[part_left].GetShape(fx, fy, cx, cy);
			cv::Point3f pupil_left_h = GazeAnalysis::GetPupilPosition(eyeLdmks3d_left);
			pupil_left->x = pupil_left_h.x; pupil_left->y = pupil_left_h.y; pupil_left->z = pupil_left_h.z;

			cv::Mat_<float> eyeLdmks3d_right = clnf->getCLNF()->hierarchical_models[part_right].GetShape(fx, fy, cx, cy);
			cv::Point3f pupil_right_h = GazeAnalysis::GetPupilPosition(eyeLdmks3d_right);
			pupil_right->x = pupil_right_h.x; pupil_right->y = pupil_right_h.y; pupil_right->z = pupil_right_h.z;
		}

		System::Tuple<System::Tuple<float, float, float>^, System::Tuple<float, float, float>^>^ GetGazeCamera()
		{

			auto gaze0 = gcnew System::Tuple<float, float, float>(gazeDirection0->x, gazeDirection0->y, gazeDirection0->z);
			auto gaze1 = gcnew System::Tuple<float, float, float>(gazeDirection1->x, gazeDirection1->y, gazeDirection1->z);

			return gcnew System::Tuple<System::Tuple<float, float, float>^, System::Tuple<float, float, float>^>(gaze0, gaze1);

		}

		System::Tuple<float, float>^ GetGazeAngle()
		{
			auto gaze_angle = gcnew System::Tuple<float, float>((*gazeAngle)[0], (*gazeAngle)[1]);
			return gaze_angle;

		}
		System::Collections::Generic::List<System::Tuple<System::Windows::Point, System::Windows::Point>^>^ CalculateGazeLines(float fx, float fy, float cx, float cy)
		{

			std::vector<cv::Point3f> points_left;
			points_left.push_back(cv::Point3f(*pupil_left));
			points_left.push_back(cv::Point3f(*pupil_left + *gazeDirection0 * 40.0));

			std::vector<cv::Point3f> points_right;
			points_right.push_back(cv::Point3f(*pupil_right));
			points_right.push_back(cv::Point3f(*pupil_right + *gazeDirection1 * 40.0));

			// Perform manual projection of points
			std::vector<cv::Point2f> imagePoints_left;
			for (size_t i = 0; i < points_left.size(); ++i)
			{
				float x = points_left[i].x * fx / points_left[i].z + cx;
				float y = points_left[i].y * fy / points_left[i].z + cy;
				imagePoints_left.push_back(cv::Point2f(x, y));

			}

			std::vector<cv::Point2f> imagePoints_right;
			for (size_t i = 0; i < points_right.size(); ++i)
			{
				float x = points_right[i].x * fx / points_right[i].z + cx;
				float y = points_right[i].y * fy / points_right[i].z + cy;
				imagePoints_right.push_back(cv::Point2f(x, y));

			}

			auto lines = gcnew System::Collections::Generic::List<System::Tuple<System::Windows::Point, System::Windows::Point>^>();
			lines->Add(gcnew System::Tuple<System::Windows::Point, System::Windows::Point>(System::Windows::Point(imagePoints_left[0].x, imagePoints_left[0].y), System::Windows::Point(imagePoints_left[1].x, imagePoints_left[1].y)));
			lines->Add(gcnew System::Tuple<System::Windows::Point, System::Windows::Point>(System::Windows::Point(imagePoints_right[0].x, imagePoints_right[0].y), System::Windows::Point(imagePoints_right[1].x, imagePoints_right[1].y)));
			return lines;
		}

		// Finalizer. Definitely called before Garbage Collection,
		// but not automatically called on explicit Dispose().
		// May be called multiple times.
		!GazeAnalyserManaged()
		{
			delete gazeDirection0;
			delete gazeDirection1;
			delete gazeAngle;
			delete pupil_left;
			delete pupil_right;
		}

		// Destructor. Called on explicit Dispose() only.
		~GazeAnalyserManaged()
		{
			this->!GazeAnalyserManaged();
		}

	};
}

#endif // GAZE_ANALYSER_INTEROP_H