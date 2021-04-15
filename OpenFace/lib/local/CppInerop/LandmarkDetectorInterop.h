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

#ifndef LANDMARK_DETECTOR_INTEROP_H
#define LANDMARK_DETECTOR_INTEROP_H

#pragma once

#pragma managed
#include <msclr\marshal.h>
#include <msclr\marshal_cppstd.h>

#pragma unmanaged

// Include all the unmanaged things we need.

#include <opencv2/opencv.hpp>

#include <OpenCVWrappers.h>

#undef _M_CEE
#include <LandmarkCoreIncludes.h>
#include <Face_utils.h>
#include <FaceAnalyser.h>
#include <VisualizationUtils.h>
#define _M_CEE

using namespace System::Collections::Generic;

#pragma managed

namespace CppInterop {
	
	namespace LandmarkDetector {

		public ref class FaceModelParameters
		{
		public:
			::LandmarkDetector::FaceModelParameters* params;

		public:

			// Initialise the parameters
			FaceModelParameters(System::String^ root, bool ceclm, bool clnf, bool clm)
			{
				std::string root_std = msclr::interop::marshal_as<std::string>(root);
				std::vector<std::string> args;
				args.push_back(root_std);

				std::string model_loc = "model/main_ceclm_general.txt";
				if (ceclm)
				{
					model_loc = "model/main_ceclm_general.txt";
				}
				else if(clnf)
				{
					model_loc = "model/main_clnf_general.txt";
				}
				else if (clm)
				{
					model_loc = "model/main_clm_general.txt";

				}

				args.push_back("-mloc");
				args.push_back(model_loc);

				params = new ::LandmarkDetector::FaceModelParameters(args);


			}

			// TODO this could have optimize for demo mode (also could appropriately update sigma, reg_factor as well)
			void optimiseForVideo()
			{
				params->window_sizes_small = std::vector<int>(4);
				params->window_sizes_init = std::vector<int>(4);

				// For fast tracking
				params->window_sizes_small[0] = 0;
				params->window_sizes_small[1] = 9;
				params->window_sizes_small[2] = 7;
				params->window_sizes_small[3] = 0;

				// Just for initialisation
				params->window_sizes_init.at(0) = 11;
				params->window_sizes_init.at(1) = 9;
				params->window_sizes_init.at(2) = 7;
				params->window_sizes_init.at(3) = 5;

				// For first frame use the initialisation
				params->window_sizes_current = params->window_sizes_init;

				params->multi_view = false;
				params->num_optimisation_iteration = 5;

				params->sigma = 1.5;
				params->reg_factor = 25;
				params->weight_factor = 0;

				// Parameter optimizations for CE-CLM
				if (params->curr_landmark_detector == ::LandmarkDetector::FaceModelParameters::CECLM_DETECTOR)
				{
					params->sigma = 1.5f * params->sigma;
					params->reg_factor = 0.9f * params->reg_factor;
				}
			}

			bool IsCECLM()
			{
				return params->curr_landmark_detector == ::LandmarkDetector::FaceModelParameters::CECLM_DETECTOR;
			}

			bool IsCLNF()
			{
				return params->curr_landmark_detector == ::LandmarkDetector::FaceModelParameters::CLNF_DETECTOR;
			}

			bool IsCLM()
			{
				return params->curr_landmark_detector == ::LandmarkDetector::FaceModelParameters::CLM_DETECTOR;
			}

			System::String^ GetMTCNNLocation()
			{
				return gcnew System::String(params->mtcnn_face_detector_location.c_str());
			}

			System::String^ GetHaarLocation()
			{
				return gcnew System::String(params->haar_face_detector_location.c_str());
			}

			void SetFaceDetector(bool haar, bool hog, bool cnn)
			{
				if (cnn)
				{
					params->curr_face_detector = params->MTCNN_DETECTOR;
				}
				else if (hog)
				{
					params->curr_face_detector = params->HOG_SVM_DETECTOR;
				}
				else if (haar)
				{
					params->curr_face_detector = params->HAAR_DETECTOR;
				}
			}

			void optimiseForImages()
			{
				params->window_sizes_init = std::vector<int>(4);
				params->window_sizes_init[0] = 15;
				params->window_sizes_init[1] = 13; 
				params->window_sizes_init[2] = 11; 
				params->window_sizes_init[3] = 11;

				params->multi_view = true;

				params->sigma = 1.25;
				params->reg_factor = 35;
				params->weight_factor = 2.5;
				params->num_optimisation_iteration = 10;

				// Parameter optimizations for CE-CLM
				if (params->curr_landmark_detector == ::LandmarkDetector::FaceModelParameters::MTCNN_DETECTOR)
				{
					params->sigma = 1.5f * params->sigma;
					params->reg_factor = 0.9f * params->reg_factor;
				}

			}			

			::LandmarkDetector::FaceModelParameters* getParams() {
				return params;
			}

			!FaceModelParameters()
			{
				delete params;
			}

			~FaceModelParameters()
			{
				this->!FaceModelParameters();
			}

		};

		public ref class CLNF
		{
		public:

			// A pointer to the CLNF landmark detector
			::LandmarkDetector::CLNF* clnf;	

		public:

			// Wrapper functions for the relevant CLNF functionality
			CLNF() : clnf(new ::LandmarkDetector::CLNF()) { }
			
			CLNF(FaceModelParameters^ params)
			{				
				clnf = new ::LandmarkDetector::CLNF(params->getParams()->model_location);

			}
			
			!CLNF()
			{
				delete clnf;
			}

			~CLNF()
			{
				this->!CLNF();
			}

			bool isLoaded()
			{
				return clnf->loaded_successfully;
			}


			::LandmarkDetector::CLNF* getCLNF() {
				return clnf;
			}

			void Reset() {
				clnf->Reset();
			}

			void Reset(double x, double y) {
				clnf->Reset(x, y);
			}

			bool HasEyeModel() {
				return clnf->eye_model;
			}

			double GetConfidence()
			{
				return clnf->detection_certainty;
			}

			bool DetectLandmarksInVideo(OpenCVWrappers::RawImage^ rgb_image, FaceModelParameters^ modelParams, OpenCVWrappers::RawImage^ gray_image) {
				return ::LandmarkDetector::DetectLandmarksInVideo(rgb_image->Mat, *clnf, *modelParams->getParams(), gray_image->Mat);
			}

			bool DetectLandmarksInVideo(OpenCVWrappers::RawImage^ rgb_image, FaceModelParameters^ modelParams) {
				return ::LandmarkDetector::DetectLandmarksInVideo(rgb_image->Mat, *clnf, *modelParams->getParams(), cv::Mat());
			}

			bool DetectFaceLandmarksInImage(OpenCVWrappers::RawImage^ rgb_image, FaceModelParameters^ modelParams, OpenCVWrappers::RawImage^ gray_image) {
				return ::LandmarkDetector::DetectLandmarksInImage(rgb_image->Mat, *clnf, *modelParams->getParams(), gray_image->Mat);
			}

			bool DetectFaceLandmarksInImage(OpenCVWrappers::RawImage^ rgb_image, FaceModelParameters^ modelParams) {
				return ::LandmarkDetector::DetectLandmarksInImage(rgb_image->Mat, *clnf, *modelParams->getParams(), cv::Mat());
			}

			bool DetectFaceLandmarksInImage(OpenCVWrappers::RawImage^ rgb_image, Rect^ bounding_box, FaceModelParameters^ modelParams, OpenCVWrappers::RawImage^ gray_image) {
				cv::Rect_<float> bbox(bounding_box->Left, bounding_box->Top, bounding_box->Width, bounding_box->Height);
				return ::LandmarkDetector::DetectLandmarksInImage(rgb_image->Mat, bbox, *clnf, *modelParams->getParams(), gray_image->Mat);
			}

			bool DetectFaceLandmarksInImage(OpenCVWrappers::RawImage^ rgb_image, Rect^ bounding_box, FaceModelParameters^ modelParams) {
				cv::Rect_<float> bbox(bounding_box->Left, bounding_box->Top, bounding_box->Width, bounding_box->Height);
				return ::LandmarkDetector::DetectLandmarksInImage(rgb_image->Mat, bbox, *clnf, *modelParams->getParams(), cv::Mat());
			}

			void GetPoseWRTCamera(List<float>^ pose, float fx, float fy, float cx, float cy) {
				auto pose_vec = ::LandmarkDetector::GetPoseWRTCamera(*clnf, fx, fy, cx, cy);
				pose->Clear();
				for(int i = 0; i < 6; ++i)
				{
					pose->Add(pose_vec[i]);
				}
			}

			void GetPose(List<float>^ pose, float fx, float fy, float cx, float cy) {
				auto pose_vec = ::LandmarkDetector::GetPose(*clnf, fx, fy, cx, cy);
				pose->Clear();
				for(int i = 0; i < 6; ++i)
				{
					pose->Add(pose_vec[i]);
				}
			}
	
			// Get the mask of which landmarks are currently visible (not self-occluded)
			List<bool>^ GetVisibilities()
			{
				cv::Mat_<int> vis = clnf->GetVisibilities();
				List<bool>^ visibilities = gcnew List<bool>();

				for (auto vis_it = vis.begin(); vis_it != vis.end(); vis_it++)
				{
					visibilities->Add(*vis_it != 0);
				}
				return visibilities;
			}

			List<System::Tuple<float,float>^>^ CalculateVisibleLandmarks() {
				std::vector<cv::Point2f> vecLandmarks = ::LandmarkDetector::CalculateVisibleLandmarks(*clnf);
				
				auto landmarks = gcnew System::Collections::Generic::List<System::Tuple<float, float>^>();
				for(cv::Point2f p : vecLandmarks) {
					landmarks->Add(gcnew System::Tuple<float, float>(p.x, p.y));
				}

				return landmarks;
			}

			List<System::Tuple<float, float>^>^ CalculateAllLandmarks() {
				std::vector<cv::Point2f> vecLandmarks = ::LandmarkDetector::CalculateAllLandmarks(*clnf);

				auto landmarks = gcnew List<System::Tuple<float, float>^>();
				for (cv::Point2f p : vecLandmarks) {
					landmarks->Add(gcnew System::Tuple<float, float>(p.x, p.y));
				}

				return landmarks;
			}

			List<System::Tuple<float, float>^>^ CalculateAllEyeLandmarks() {
				std::vector<cv::Point2f> vecLandmarks = ::LandmarkDetector::CalculateAllEyeLandmarks(*clnf);

				auto landmarks = gcnew System::Collections::Generic::List<System::Tuple<float, float>^>();
				for (cv::Point2f p : vecLandmarks) {
					landmarks->Add(gcnew System::Tuple<float, float>(p.x, p.y));
				}

				return landmarks;
			}

			List<System::Tuple<float, float, float>^>^ CalculateAllEyeLandmarks3D(float fx, float fy, float cx, float cy) {
				std::vector<cv::Point3f> vecLandmarks = ::LandmarkDetector::Calculate3DEyeLandmarks(*clnf, fx, fy, cx, cy);

				auto landmarks = gcnew System::Collections::Generic::List<System::Tuple<float, float, float>^>();
				for (cv::Point3f p : vecLandmarks) {
					landmarks->Add(gcnew System::Tuple<float, float, float>(p.x, p.y, p.z));
				}

				return landmarks;
			}

			List<System::Tuple<float, float>^>^ CalculateVisibleEyeLandmarks() {
				std::vector<cv::Point2f> vecLandmarks = ::LandmarkDetector::CalculateVisibleEyeLandmarks(*clnf);

				auto landmarks = gcnew System::Collections::Generic::List<System::Tuple<float, float>^>();
				for (cv::Point2f p : vecLandmarks) {
					landmarks->Add(gcnew System::Tuple<float, float>(p.x, p.y));
				}

				return landmarks;
			}

			List<System::Tuple<float, float, float>^>^ Calculate3DLandmarks(float fx, float fy, float cx, float cy) {
				
				cv::Mat_<float> shape3D = clnf->GetShape(fx, fy, cx, cy);
				
				auto landmarks_3D = gcnew List<System::Tuple<float, float, float>^>();
				
				for(int i = 0; i < shape3D.cols; ++i) 
				{
					landmarks_3D->Add(gcnew System::Tuple<float, float, float>(shape3D.at<float>(0, i), shape3D.at<float>(1, i), shape3D.at<float>(2, i)));
				}

				return landmarks_3D;
			}

			List<System::Tuple<System::Windows::Point, System::Windows::Point>^>^ CalculateBox(float fx, float fy, float cx, float cy) {

				cv::Vec6f pose = ::LandmarkDetector::GetPose(*clnf, fx,fy, cx, cy);

				std::vector<std::pair<cv::Point2f, cv::Point2f>> vecLines = ::Utilities::CalculateBox(pose, fx, fy, cx, cy);

				auto lines = gcnew List<System::Tuple<System::Windows::Point,System::Windows::Point>^>();

				for(std::pair<cv::Point2f, cv::Point2f> line : vecLines) {
					lines->Add(gcnew System::Tuple<System::Windows::Point, System::Windows::Point>(System::Windows::Point(line.first.x, line.first.y), System::Windows::Point(line.second.x, line.second.y)));
				}

				return lines;
			}

			int GetNumPoints()
			{
				return clnf->pdm.NumberOfPoints();
			}

			int GetNumModes()
			{
				return clnf->pdm.NumberOfModes();
			}

			// Getting the non-rigid shape parameters describing the facial expression
			List<float>^ GetNonRigidParams()
			{
				auto non_rigid_params = gcnew List<float>();

				for (int i = 0; i < clnf->params_local.rows; ++i)
				{
					non_rigid_params->Add(clnf->params_local.at<float>(i));
				}

				return non_rigid_params;
			}

			// Getting the rigid shape parameters describing face scale rotation and translation (scale,rotx,roty,rotz,tx,ty)
			List<float>^ GetRigidParams()
			{
				auto rigid_params = gcnew List<float>();

				for (size_t i = 0; i < 6; ++i)
				{
					rigid_params->Add(clnf->params_global[i]);
				}
				return rigid_params;
			}

			// Rigid params followed by non-rigid ones
			List<float>^ GetParams()
			{
				auto all_params = GetRigidParams();
				all_params->AddRange(GetNonRigidParams());
				return all_params;
			}

		};

	}

}

#endif // LANDMARK_DETECTOR_INTEROP_H