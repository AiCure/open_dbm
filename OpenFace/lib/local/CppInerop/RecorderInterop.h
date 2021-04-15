///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2017, Tadas Baltrusaitis.
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

#pragma once

#pragma unmanaged

// Include all the unmanaged things we need.

#include <RecorderOpenFace.h>
#include <OpenCVWrappers.h>

#pragma managed

#include <msclr\marshal.h>
#include <msclr\marshal_cppstd.h>

using namespace System::Collections::Generic;

namespace UtilitiesOF {

	public ref class RecorderOpenFaceParameters
	{

	private:

		Utilities::RecorderOpenFaceParameters *m_params;

	public:
		RecorderOpenFaceParameters(bool sequence, bool is_from_webcam, bool output_2D_landmarks, bool output_3D_landmarks,
			bool output_model_params, bool output_pose, bool output_AUs, bool output_gaze, bool output_hog, bool output_tracked,
			bool output_aligned_faces, bool record_bad_aligned, float fx, float fy, float cx, float cy, double fps_vid_out)
		{

			m_params = new Utilities::RecorderOpenFaceParameters(sequence, is_from_webcam, 
				output_2D_landmarks, output_3D_landmarks, output_model_params, output_pose, output_AUs,
				output_gaze, output_hog, output_tracked, output_aligned_faces, record_bad_aligned, fx, fy, cx, cy, fps_vid_out);

		}

		Utilities::RecorderOpenFaceParameters * GetParams()
		{
			return m_params;
		}

		!RecorderOpenFaceParameters()
		{
			delete m_params;
		}

		// Destructor. Called on explicit Dispose() only.
		~RecorderOpenFaceParameters()
		{
			this->!RecorderOpenFaceParameters();
		}

	};

	public ref class RecorderOpenFace
	{
	private:

		// OpenCV based video capture for reading from files
		Utilities::RecorderOpenFace* m_recorder;

	public:

		// Can provide a directory, or a list of files
		RecorderOpenFace(System::String^ in_filename, UtilitiesOF::RecorderOpenFaceParameters^ parameters, System::String^ output_directory)
		{
			std::string in_filename_std = msclr::interop::marshal_as<std::string>(in_filename);
			std::string output_directory_std = msclr::interop::marshal_as<std::string>(output_directory);

			m_recorder = new Utilities::RecorderOpenFace(in_filename_std, *parameters->GetParams(), output_directory_std);
		}

		void Close()
		{
			m_recorder->Close();
		}

		void WriteObservation()
		{
			m_recorder->WriteObservation();
		}

		void WriteObservationTracked()
		{
			m_recorder->WriteObservationTracked();
		}

		void SetObservationGaze(System::Tuple<float, float, float>^ gaze_direction0, System::Tuple<float, float, float>^ gaze_direction1, System::Tuple<float, float>^ gaze_angle,
			List<System::Tuple<float, float>^>^ landmarks_2D, List<System::Tuple<float, float, float>^>^ landmarks_3D)
		{
			cv::Point3f gaze_direction0_cv(gaze_direction0->Item1, gaze_direction0->Item2, gaze_direction0->Item3);
			cv::Point3f gaze_direction1_cv(gaze_direction1->Item1, gaze_direction1->Item2, gaze_direction1->Item3);
			cv::Vec2f gaze_angle_cv(gaze_angle->Item1, gaze_angle->Item2);

			// Construct an OpenCV matrix from the landmarks
			std::vector<cv::Point2f> landmarks_2D_cv;
			for (int i = 0; i < landmarks_2D->Count; ++i)
			{
				landmarks_2D_cv.push_back(cv::Point2f(landmarks_2D[i]->Item1, landmarks_2D[i]->Item2));
			}

			// Construct an OpenCV matrix from the landmarks
			std::vector<cv::Point3f> landmarks_3D_cv;
			for (int i = 0; i < landmarks_3D->Count; ++i)
			{
				landmarks_3D_cv.push_back(cv::Point3f(landmarks_3D[i]->Item1, landmarks_3D[i]->Item2, landmarks_3D[i]->Item3));
			}

			m_recorder->SetObservationGaze(gaze_direction0_cv, gaze_direction1_cv, gaze_angle_cv, landmarks_2D_cv, landmarks_3D_cv);
		}

		System::String^ GetCSVFile()
		{
			return gcnew System::String(m_recorder->GetCSVFile().c_str());
		}

		// Setting the observations
		void SetObservationTimestamp(double timestamp)
		{
			m_recorder->SetObservationTimestamp(timestamp);
		}

		void SetObservationPose(List<float>^ pose)
		{
			cv::Vec6f pose_vec(pose[0], pose[1], pose[2], pose[3], pose[4], pose[5]);
			m_recorder->SetObservationPose(pose_vec);
		}

		void SetObservationActionUnits(Dictionary<System::String^, double>^ au_regs, Dictionary<System::String^, double>^ au_class)
		{
			std::vector<std::pair<std::string, double> > au_regs_std;
			auto enum_reg = au_regs->GetEnumerator();
			while (enum_reg.MoveNext())
			{
				std::string au_name = msclr::interop::marshal_as<std::string>(enum_reg.Current.Key);
				double value = (double)enum_reg.Current.Value;
				au_regs_std.push_back(std::pair<std::string, double>(au_name, value));
			}

			std::vector<std::pair<std::string, double> > au_class_std;
			auto enum_class = au_class->GetEnumerator();
			while (enum_class.MoveNext())
			{
				std::string au_name = msclr::interop::marshal_as<std::string>(enum_class.Current.Key);
				double value = (double)enum_class.Current.Value;
				au_class_std.push_back(std::pair<std::string, double>(au_name, value));
			} 
			m_recorder->SetObservationActionUnits(au_regs_std, au_class_std);
		}

		void SetObservationFaceAlign(OpenCVWrappers::RawImage^ aligned_face_image)
		{
			m_recorder->SetObservationFaceAlign(aligned_face_image->Mat);
		}

		void SetObservationVisualization(OpenCVWrappers::RawImage^ vis_image)
		{
			m_recorder->SetObservationVisualization(vis_image->Mat);
		}

		void SetObservationFaceID(int face_id)
		{
			m_recorder->SetObservationFaceID(face_id);
		}

		void SetObservationFrameNumber(int frame_number)
		{
			m_recorder->SetObservationFrameNumber(frame_number);
		}

		void SetObservationHOG(bool success, OpenCVWrappers::RawImage^ aligned_face_image, int num_cols, int num_rows, int num_channels)
		{
			m_recorder->SetObservationHOG(success, aligned_face_image->Mat, num_cols, num_rows, num_channels);
		}

		void SetObservationLandmarks(List<System::Tuple<float, float>^>^ landmarks_2D, List<System::Tuple<float, float, float>^>^ landmarks_3D, List<float>^ params_global, List<float>^ params_local, double confidence, bool success)
		{
			// Construct an OpenCV matrix from the landmarks
			cv::Mat_<float> landmarks_2D_mat(landmarks_2D->Count * 2, 1, 0.0);
			for (int i = 0; i < landmarks_2D->Count; ++i)
			{
				landmarks_2D_mat.at<float>(i, 0) = landmarks_2D[i]->Item1;
				landmarks_2D_mat.at<float>(i + landmarks_2D->Count, 0) = landmarks_2D[i]->Item2;
			}

			// Construct an OpenCV matrix from the landmarks
			cv::Mat_<float> landmarks_3D_mat(landmarks_3D->Count * 3, 1, 0.0);
			for (int i = 0; i < landmarks_3D->Count; ++i)
			{
				landmarks_3D_mat.at<float>(i, 0) = landmarks_3D[i]->Item1;
				landmarks_3D_mat.at<float>(i + landmarks_3D->Count, 0) = landmarks_3D[i]->Item2;
				landmarks_3D_mat.at<float>(i + 2 * landmarks_3D->Count, 0) = landmarks_3D[i]->Item3;
			}

			cv::Vec6f params_global_vec(params_global[0], params_global[1], params_global[2], params_global[3], params_global[4], params_global[5]);

			cv::Mat_<float> params_local_vec(params_local->Count, 1, 0.0);
			for (int i = 0; i < params_local->Count; ++i)
			{
				params_local_vec.at<float>(i, 0) = params_local[i];
			}

			m_recorder->SetObservationLandmarks(landmarks_2D_mat, landmarks_3D_mat, params_global_vec, params_local_vec, confidence, success);
		}

		// Finalizer. Definitely called before Garbage Collection,
		// but not automatically called on explicit Dispose().
		// May be called multiple times.
		!RecorderOpenFace()
		{
			delete m_recorder;
		}

		// Destructor. Called on explicit Dispose() only.
		~RecorderOpenFace()
		{
			this->!RecorderOpenFace();
		}
	};

}
