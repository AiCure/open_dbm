///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2017, Tadas Baltrusaitis, all rights reserved.
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

#include <opencv2/opencv.hpp>
#include <vector>
#include <set>

#include <OpenCVWrappers.h>

#include <ImageCapture.h>

#pragma managed

#include <msclr\marshal.h>
#include <msclr\marshal_cppstd.h>

namespace UtilitiesOF {

	public ref class ReadingFailedException : System::Exception
	{
	public:

		ReadingFailedException(System::String^ message) : Exception(message) {}
	};

	public ref class ImageReader
	{
	private:

		// OpenCV based video capture for reading from files
		Utilities::ImageCapture* m_image_capture;

		OpenCVWrappers::RawImage^ m_rgb_frame;
		OpenCVWrappers::RawImage^ m_gray_frame;

		bool* m_is_opened;

	public:

		// Can provide a directory, or a list of files
		ImageReader(System::String^ image_directory, float fx, float fy, float cx, float cy)
		{
			m_image_capture = new Utilities::ImageCapture();
			m_is_opened = new bool;

			std::string image_dir_std = msclr::interop::marshal_as<std::string>(image_directory);

			*m_is_opened = m_image_capture->OpenDirectory(image_dir_std, "", fx, fy, cx, cy);

			if (!*m_is_opened)
			{
				throw gcnew ReadingFailedException("Failed to open a directory or an image");
			}
		}
		// Can provide a directory, or a list of files
		ImageReader(System::Collections::Generic::List<System::String^>^ image_files, float fx, float fy, float cx, float cy)
		{
			m_image_capture = new Utilities::ImageCapture();
			m_is_opened = new bool;

			std::vector<std::string> image_files_std;

			for (int i = 0; i < image_files->Count; ++i)
			{
				std::string image_file = msclr::interop::marshal_as<std::string>(image_files[i]);
				image_files_std.push_back(image_file);

			}

			*m_is_opened = m_image_capture->OpenImageFiles(image_files_std, fx, fy, cx, cy);

			if (!*m_is_opened)
			{
				throw gcnew ReadingFailedException("Failed to open a directory or an image");
			}

		}

		OpenCVWrappers::RawImage^ GetNextImage()
		{
			cv::Mat next_image = m_image_capture->GetNextImage();

			m_rgb_frame = gcnew OpenCVWrappers::RawImage(next_image);

			if (next_image.empty())
			{
				*m_is_opened = false;
			}

			return m_rgb_frame;
		}

		System::String^ GetName()
		{
			std::string filename = m_image_capture->name;
			return gcnew System::String(filename.c_str());
		}

		double GetProgress()
		{
			return m_image_capture->GetProgress();
		}

		float GetFx()
		{
			return m_image_capture->fx;
		}

		float GetFy()
		{
			return m_image_capture->fy;
		}

		float GetCx()
		{
			return m_image_capture->cx;
		}

		float GetCy()
		{
			return m_image_capture->cy;
		}

		bool isOpened()
		{
			return *m_is_opened;
		}

		OpenCVWrappers::RawImage^ GetCurrentFrameGray() {

			cv::Mat next_gray_image = m_image_capture->GetGrayFrame();
			m_gray_frame = gcnew OpenCVWrappers::RawImage(next_gray_image);

			return m_gray_frame;
		}

		// Finalizer. Definitely called before Garbage Collection,
		// but not automatically called on explicit Dispose().
		// May be called multiple times.
		!ImageReader()
		{
			delete m_image_capture;
			delete m_rgb_frame;
			delete m_gray_frame;
			delete m_is_opened;
		}

		// Destructor. Called on explicit Dispose() only.
		~ImageReader()
		{
			this->!ImageReader();
		}
	};

}
