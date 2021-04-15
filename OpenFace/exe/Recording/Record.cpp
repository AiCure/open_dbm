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
//
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

// Record.cpp : A useful function for quick recording from a webcam for test purposes

#include <fstream>
#include <sstream>

#include <iostream>

#include <windows.h>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <stdio.h>
#include <time.h>

#include <filesystem>

#define INFO_STREAM( stream ) \
std::cout << stream << std::endl

#define WARN_STREAM( stream ) \
std::cout << "Warning: " << stream << std::endl

#define ERROR_STREAM( stream ) \
std::cout << "Error: " << stream << std::endl

static void printErrorAndAbort( const std::string & error )
{
    std::cout << error << std::endl;
    abort();
}

#define FATAL_STREAM( stream ) \
printErrorAndAbort( std::string( "Fatal error: " ) + stream )

// Get current date/time, format is YYYY-MM-DD.HH:mm:ss
const std::string currentDateTime() {
    time_t     now = time(0);
    struct tm  tstruct;
    char       buf[80];
    localtime_s(&tstruct, &now);
    // Visit http://www.cplusplus.com/reference/clibrary/ctime/strftime/
    // for more information about date/time format
    strftime(buf, sizeof(buf), "%Y-%m-%d-%H-%M", &tstruct);

    return buf;
}

std::vector<std::string> get_arguments(int argc, char **argv)
{

	std::vector<std::string> arguments;

	for(int i = 1; i < argc; ++i)
	{
		arguments.push_back(std::string(argv[i]));
	}
	return arguments;
}

int main (int argc, char **argv)
{

	std::vector<std::string> arguments = get_arguments(argc, argv);

	// Some initial parameters that can be overriden from command line	
	std::string outroot, outfile;

	TCHAR NPath[200];
	GetCurrentDirectory(200, NPath);

	// By default write to same directory
	outroot = NPath;
	outroot = outroot + "/recording/";
	outfile = currentDateTime() + ".avi";

	// By default try webcam
	int device = 0;

	for (size_t i = 0; i < arguments.size(); i++)
    {
		if( strcmp( arguments[i].c_str(), "-dev") == 0 )
        {
			std::stringstream ss;
            ss << arguments[i+1].c_str();
            ss >> device;
        }
        else if (strcmp(arguments[i].c_str(), "-r") == 0)
        {
			outroot = arguments[i+1];
        }
        else if (strcmp(arguments[i].c_str(), "-of") == 0)
        {
			outroot = arguments[i+1];
        }
        else
        {
            WARN_STREAM( "invalid argument" );
        }
        i++;
    }    		

	// Do some grabbing
	cv::VideoCapture vCap;
	INFO_STREAM( "Attempting to capture from device: " << device );
	vCap = cv::VideoCapture( device );

	if (!vCap.isOpened()) {
		FATAL_STREAM("Failed to open video source");
		return 1;
	}
	
	cv::Mat img;
	vCap >> img;
			
	std::filesystem::path dir(outroot);
	std::filesystem::create_directory(dir);

	std::string out_file = outroot + outfile;
	// saving the videos
	cv::VideoWriter video_writer(out_file, cv::VideoWriter::fourcc('D','I','V','X'), 30, img.size(), true);

	std::ofstream outlog;
	outlog.open((outroot + outfile + ".log").c_str(), std::ios_base::out);
	outlog << "frame, time(ms)" << std::endl;

	double freq = cv::getTickFrequency();

	double init_time = (double)cv::getTickCount();

	int frameProc = 0;
	while(!img.empty())
	{		
		
		cv::namedWindow("rec",1);
		
		vCap >> img;
		double curr_time = (cv::getTickCount() - init_time) / freq;
		curr_time *= 1000;

		video_writer << img;

		outlog << frameProc + 1 << " " << curr_time;
		outlog << std::endl;
						
		
		cv::imshow("rec", img);

		frameProc++;
		
		// detect key presses
		char c = cv::waitKey(1);
			
		// quit the application
		if(c=='q')
		{
			outlog.close();
				
			return(0);
		}


	}
			
	return 0;
}

