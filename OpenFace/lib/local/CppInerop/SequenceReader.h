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
#include <string>

#include <OpenCVWrappers.h>
#include <ImageReader.h>
#include <DeviceEnumerator.h>
#include <SequenceCapture.h>

#pragma managed

#include <msclr\marshal.h>
#include <msclr\marshal_cppstd.h>

using namespace System::Collections::Generic;

namespace UtilitiesOF {


	public ref class SequenceReader
	{
	private:

		// OpenCV based video capture for reading from files
		Utilities::SequenceCapture* m_sequence_capture;

		OpenCVWrappers::RawImage^ m_rgb_frame;
		OpenCVWrappers::RawImage^ m_gray_frame;

	public:

		// Can provide a directory or a video filename, need to specify which
		SequenceReader(System::String^ filename, bool directory)
		{
			m_sequence_capture = new Utilities::SequenceCapture();

			std::string name_std = msclr::interop::marshal_as<std::string>(filename);

			bool success;

			if(directory)
			{
				success = m_sequence_capture->OpenImageSequence(name_std);
			}
			else
			{
				success = m_sequence_capture->OpenVideoFile(name_std);
			}

			if (!success)
			{
				throw gcnew ReadingFailedException("Failed to open an image sequence");
			}
		}

		SequenceReader(System::String^ filename, bool directory, float fx, float fy, float cx, float cy)
		{
			m_sequence_capture = new Utilities::SequenceCapture();

			std::string name_std = msclr::interop::marshal_as<std::string>(filename);

			bool success;

			if (directory)
			{
				success = m_sequence_capture->OpenImageSequence(name_std, fx, fy, cx, cy);
			}
			else
			{
				success = m_sequence_capture->OpenVideoFile(name_std, fx, fy, cx, cy);
			}

			if (!success)
			{
				throw gcnew ReadingFailedException("Failed to open an image sequence");
			}
		}

		// Can provide a webcam id
		SequenceReader(int webcam_id, int width, int height)
		{
			m_sequence_capture = new Utilities::SequenceCapture();
			
			bool success = m_sequence_capture->OpenWebcam(webcam_id, width, height);

			if (!success)
			{
				throw gcnew ReadingFailedException("Failed to open an image sequence");
			}
		}

		SequenceReader(int webcam_id, int width, int height, float fx, float fy, float cx, float cy)
		{
			m_sequence_capture = new Utilities::SequenceCapture();

			bool success = m_sequence_capture->OpenWebcam(webcam_id, width, height, fx, fy, cx, cy);

			if (!success)
			{
				throw gcnew ReadingFailedException("Failed to open an image sequence");
			}
		}

		OpenCVWrappers::RawImage^ GetNextImage()
		{
			cv::Mat next_image = m_sequence_capture->GetNextFrame();
			m_rgb_frame = gcnew OpenCVWrappers::RawImage(next_image);

			return m_rgb_frame;
		}

		OpenCVWrappers::RawImage^ GetCurrentFrameGray() {

			cv::Mat_<uchar> next_gray_image = m_sequence_capture->GetGrayFrame();
			m_gray_frame = gcnew OpenCVWrappers::RawImage(next_gray_image);
			
			return m_gray_frame;
		}

		int GetFrameNumber()
		{
			return m_sequence_capture->GetFrameNumber();
		}

		double GetTimestamp()
		{
			return m_sequence_capture->time_stamp;
		}

		System::String^ GetName()
		{
			std::string filename = m_sequence_capture->name;
			return gcnew System::String(filename.c_str());
		}

		double GetProgress()
		{
			return m_sequence_capture->GetProgress();
		}

		float GetFx()
		{
			return m_sequence_capture->fx;
		}

		float GetFy()
		{
			return m_sequence_capture->fy;
		}

		float GetCx()
		{
			return m_sequence_capture->cx;
		}

		float GetCy()
		{
			return m_sequence_capture->cy;
		}

		bool IsOpened()
		{
			return m_sequence_capture->IsOpened();
		}

		bool IsWebcam()
		{
			return m_sequence_capture->IsWebcam();
		}

		double GetFPS()
		{
			return m_sequence_capture->fps;
		}

		void Close() {
			m_sequence_capture->Close();
		}

		// Finalizer. Definitely called before Garbage Collection,
		// but not automatically called on explicit Dispose().
		// May be called multiple times.
		!SequenceReader()
		{
			delete m_sequence_capture;
			delete m_rgb_frame;
			delete m_gray_frame;
		}

		// Destructor. Called on explicit Dispose() only.
		~SequenceReader()
		{
			this->!SequenceReader();
		}
	
	private:
		// Static methods for listing cameras and their resolutions
		static void split(const std::string &s, char delim, std::vector<std::string> &elems) {
			std::stringstream ss;
			ss.str(s);
			std::string item;
			while (std::getline(ss, item, delim)) {
				elems.push_back(item);
			}
		}

		// Camera listing is camera name and supported resolutions
		static Dictionary<System::String^, List<System::Tuple<int, int>^>^>^ GetListingFromFile(std::string filename)
		{
			// Check what cameras have been written (using OpenCVs XML packages)
			cv::FileStorage fs_read(filename, cv::FileStorage::READ);

			auto managed_camera_list_initial = gcnew Dictionary<System::String^, List<System::Tuple<int, int>^>^>();

			cv::FileNode camera_node_list = fs_read["cameras"];

			// iterate through a sequence using FileNodeIterator
			for (size_t idx = 0; idx < camera_node_list.size(); idx++)
			{
				std::string camera_name = (std::string)camera_node_list[idx]["name"];

				cv::FileNode resolution_list = camera_node_list[idx]["resolutions"];
				auto resolutions = gcnew System::Collections::Generic::List<System::Tuple<int, int>^>();
				for (size_t r_idx = 0; r_idx < resolution_list.size(); r_idx++)
				{
					std::string res = resolution_list[r_idx]["res"];

					std::vector<std::string> elems;
					split(res, 'x', elems);

					int x = stoi(elems[0]);
					int y = stoi(elems[1]);
					resolutions->Add(gcnew System::Tuple<int, int>(x, y));
				}
				managed_camera_list_initial[gcnew System::String(camera_name.c_str())] = resolutions;
			}
			fs_read.release();
			return managed_camera_list_initial;
		}

		static void WriteCameraListingToFile(System::Collections::Generic::Dictionary<System::String^, System::Collections::Generic::List<System::Tuple<int, int>^>^>^ camera_list, std::string filename)
		{
			cv::FileStorage fs("camera_list.xml", cv::FileStorage::WRITE);

			fs << "cameras" << "[";
			for each(System::String^ name_m in camera_list->Keys)
			{

				std::string name = msclr::interop::marshal_as<std::string>(name_m);

				fs << "{:" << "name" << name;
				fs << "resolutions" << "[";
				auto resolutions = camera_list[name_m];
				for (int j = 0; j < resolutions->Count; j++)
				{
					std::stringstream ss;
					ss << resolutions[j]->Item1 << "x" << resolutions[j]->Item2;

					fs << "{:" << "res" << ss.str();
					fs << "}";
				}
				fs << "]";
				fs << "}";
			}
			fs << "]";
			fs.release();
		}

		// A utility for listing the currently connected cameras together with their ID, name, subset of supported resolutions and a thumbnail
	public:
		static List<System::Tuple<int, System::String^, List<System::Tuple<int, int>^>^, OpenCVWrappers::RawImage^>^>^ GetCameras(System::String^ root_directory_m)
		{
			auto managed_camera_list = gcnew List<System::Tuple<int, System::String^, List<System::Tuple<int, int>^>^, OpenCVWrappers::RawImage^>^>();

			DeviceEnumerator de;

			// Get a listing of all connected video devices
			std::map<int, Device> cameras = de.getVideoDevicesMap();

			//std::cout << "Number of cameras found: " << cameras.size() << std::endl;
			//// Print information about the devices
			//for (auto const &device : cameras) {
			//	std::cout << "== VIDEO DEVICE (id:" << device.first << ") ==" << std::endl;
			//	std::cout << "Name: " << device.second.deviceName << std::endl;
			//	std::cout << "Path: " << device.second.devicePath << std::endl;
			//}

			size_t num_cameras = cameras.size();

			// Pre-load supported camera resolutions if already computed
			std::string root_directory = msclr::interop::marshal_as<std::string>(root_directory_m);
			auto camera_resolution_list = GetListingFromFile(root_directory + "camera_list.xml");

			for (size_t i = 0; i < num_cameras; ++i)
			{
				// Thumbnail to help with camera selection
				cv::Mat sample_img;

				auto resolutions = gcnew List<System::Tuple<int, int>^>();

				// Before trying the resolutions, check if the resolutions have already been computed for the camera of interest
				std::string device_name = cameras[i].deviceName;
				System::String^ device_name_m = gcnew System::String(device_name.c_str());
				if (camera_resolution_list->ContainsKey(device_name_m))
				{
					resolutions = camera_resolution_list[device_name_m];

					// Grab a thumbnail from mid resolution
					cv::VideoCapture cap1(i);

					auto resolution = resolutions[(int)(resolutions->Count / 2)];
					cap1.set(cv::CAP_PROP_FRAME_WIDTH, resolution->Item1);
					cap1.set(cv::CAP_PROP_FRAME_HEIGHT, resolution->Item2);

					// Read several frames, as the first one often is over-exposed
					for (int k = 0; k < 2; ++k)
						cap1.read(sample_img);
				}
				else
				{

					// A common set of resolutions for webcams
					std::vector<std::pair<int, int>> common_resolutions;
					common_resolutions.push_back(std::pair<int, int>(320, 240));
					common_resolutions.push_back(std::pair<int, int>(640, 480));
					common_resolutions.push_back(std::pair<int, int>(800, 600));
					common_resolutions.push_back(std::pair<int, int>(960, 720));
					common_resolutions.push_back(std::pair<int, int>(1280, 720));
					common_resolutions.push_back(std::pair<int, int>(1280, 960));
					common_resolutions.push_back(std::pair<int, int>(1920, 1080));

					// Grab some sample images and confirm the resolutions
					cv::VideoCapture cap1(i);

					// Go through resolutions if they have not been identified
					for (size_t i = 0; i < common_resolutions.size(); ++i)
					{
						auto resolution = gcnew System::Tuple<int, int>(common_resolutions[i].first, common_resolutions[i].second);

						cap1.set(cv::CAP_PROP_FRAME_WIDTH, resolution->Item1);
						cap1.set(cv::CAP_PROP_FRAME_HEIGHT, resolution->Item2);

						// Add only valid resolutions as API sometimes provides wrong ones
						int set_width = cap1.get(cv::CAP_PROP_FRAME_WIDTH);
						int set_height = cap1.get(cv::CAP_PROP_FRAME_HEIGHT);

						// Grab a thumbnail from mid resolution
						if (i == (int)common_resolutions.size() / 2)
						{
							// Read several frames, as the first one often is over-exposed
							for (int k = 0; k < 2; ++k)
								cap1.read(sample_img);
						}

						resolution = gcnew System::Tuple<int, int>(set_width, set_height);
						if (!resolutions->Contains(resolution))
						{
							resolutions->Add(resolution);
						}
					}
					cap1.~VideoCapture();

					// Ass the resolutions were not on the list, add them now
					camera_resolution_list[device_name_m] = resolutions;
					WriteCameraListingToFile(camera_resolution_list, root_directory + "camera_list.xml");
				}

				OpenCVWrappers::RawImage^ sample_img_managed = gcnew OpenCVWrappers::RawImage(sample_img);
				managed_camera_list->Add(gcnew System::Tuple<int, System::String^, List<System::Tuple<int, int>^>^, OpenCVWrappers::RawImage^>(i, device_name_m, resolutions, sample_img_managed));
			}

			return managed_camera_list;
		}

	};

}
