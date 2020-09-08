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

// OpenCVWrappers.h

#pragma once

#pragma managed

#include <msclr\marshal_cppstd.h>

#pragma unmanaged

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#pragma managed

#pragma make_public(cv::Mat)

using namespace System::Windows;
using namespace System::Windows::Threading;
using namespace System::Windows::Media;
using namespace System::Windows::Media::Imaging;

namespace OpenCVWrappers {

	public ref class RawImage : System::IDisposable
	{

	private:

		cv::Mat* mat;

	public:

		static int PixelFormatToType(PixelFormat fmt)
		{
			if (fmt == PixelFormats::Gray8)
				return CV_8UC1;
			else if (fmt == PixelFormats::Bgr24)
				return CV_8UC3;
			else if (fmt == PixelFormats::Bgra32)
				return CV_8UC4;
			else if (fmt == PixelFormats::Gray32Float)
				return CV_32FC1;
			else
				throw gcnew System::Exception("Unsupported pixel format");
		}

		static PixelFormat TypeToPixelFormat(int type)
		{
			switch (type) {
			case CV_8UC1:
				return PixelFormats::Gray8;
			case CV_8UC3:
				return PixelFormats::Bgr24;
			case CV_8UC4:
				return PixelFormats::Bgra32;
			case CV_32FC1:
				return PixelFormats::Gray32Float;
			default:
				throw gcnew System::Exception("Unsupported image type");
			}
		}

		RawImage(const cv::Mat& m)
		{
			mat = new cv::Mat(m.clone());
		}

		// Constructing a raw image from bitmap
		RawImage(System::Drawing::Bitmap^ bitmap)
		{

			auto fmt = bitmap->PixelFormat;
			if (fmt == System::Drawing::Imaging::PixelFormat::Format24bppRgb)
			{
				mat = new cv::Mat(cv::Size(bitmap->Width, bitmap->Height), CV_8UC3);			
			}
			else if (fmt == System::Drawing::Imaging::PixelFormat::Format32bppArgb)
			{
				mat = new cv::Mat(cv::Size(bitmap->Width, bitmap->Height), CV_8UC4);
			}
			else
			{
				throw gcnew System::Exception("Unsupported image type");
			}

			auto rect = System::Drawing::Rectangle(0, 0, bitmap->Width, bitmap->Height);
			auto bitmap_data = bitmap->LockBits(rect, System::Drawing::Imaging::ImageLockMode::ReadOnly, bitmap->PixelFormat);
			System::IntPtr source_data = bitmap_data->Scan0;

			int bytes = bitmap_data->Stride * bitmap_data->Height;
			memcpy(mat->data, source_data.ToPointer(), bytes);

			//Unlock the bits.
			bitmap->UnlockBits(bitmap_data);

			if (fmt == System::Drawing::Imaging::PixelFormat::Format32bppArgb)
			{
				cv::cvtColor(*mat, *mat, cv::COLOR_RGBA2RGB);
			}

		}

		void Mirror()
		{
			cv::flip(*mat, *mat, 1);
		}

		// Finalizer. Definitely called before Garbage Collection,
		// but not automatically called on explicit Dispose().
		// May be called multiple times.
		!RawImage()
		{
			if (mat)
			{
				delete mat;
				mat = NULL;
			}
		}

		// Destructor. Called on explicit Dispose() only.
		~RawImage()
		{
			this->!RawImage();
		}

		property int Width
		{
			int get()
			{
				return mat->cols;
			}
		}

		property int Height
		{
			int get()
			{
				return mat->rows;
			}
		}

		property int Stride
		{

			int get()
			{
				return (int) mat->step;
			}
		}

		property PixelFormat Format
		{
			PixelFormat get()
			{
				return TypeToPixelFormat(mat->type());
			}
		}

		property cv::Mat& Mat
		{
			cv::Mat& get()
			{
				return *mat;
			}
		}

		property bool IsEmpty
		{
			bool get()
			{
				return !mat || mat->empty();
			}
		}

		bool UpdateWriteableBitmap(WriteableBitmap^ bitmap)
		{
			if (bitmap == nullptr || bitmap->PixelWidth != Width || bitmap->PixelHeight != Height || bitmap->Format != Format)
				return false;
			else {
				if (mat->data == NULL) {
					cv::Mat zeros(bitmap->PixelHeight, bitmap->PixelWidth, PixelFormatToType(bitmap->Format), 0);
					bitmap->WritePixels(Int32Rect(0, 0, Width, Height), System::IntPtr(zeros.data), Stride * Height * (Format.BitsPerPixel / 8), Stride, 0, 0);
				}
				else {
					bitmap->WritePixels(Int32Rect(0, 0, Width, Height), System::IntPtr(mat->data), Stride * Height * (Format.BitsPerPixel / 8), Stride, 0, 0);
				}
				return true;
			}
		}

		WriteableBitmap^ CreateWriteableBitmap()
		{
			return gcnew WriteableBitmap(Width, Height, 72, 72, Format, nullptr);
		}

	};

	public ref class VideoWriter
	{
	private:
		// OpenCV based video capture for reading from files
		cv::VideoWriter* vc;

	public:

		VideoWriter(System::String^ location, int width, int height, double fps, bool colour)
		{

			msclr::interop::marshal_context context;
			std::string location_std_string = context.marshal_as<std::string>(location);

			vc = new cv::VideoWriter(location_std_string, cv::VideoWriter::fourcc('D', 'I', 'V', 'X'), fps, cv::Size(width, height), colour);

		}

		// Return success
		bool Write(RawImage^ img)
		{
			if (vc != nullptr && vc->isOpened())
			{
				vc->write(img->Mat);
				return true;
			}
			else
			{
				return false;
			}
		}

		// Finalizer. Definitely called before Garbage Collection,
		// but not automatically called on explicit Dispose().
		// May be called multiple times.
		!VideoWriter()
		{
			if (vc != nullptr)
			{
				vc->~VideoWriter();
			}
		}

		// Destructor. Called on explicit Dispose() only.
		~VideoWriter()
		{
			this->!VideoWriter();
		}

	};

}
