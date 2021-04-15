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


#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/calib3d/calib3d.hpp"
#include <iostream>

#include "GazeEstimation.h"

#include "LandmarkDetectorUtils.h"
#include "LandmarkDetectorFunc.h"
#include "RotationHelpers.h"

using namespace GazeAnalysis;

cv::Point3f RaySphereIntersect(cv::Point3f rayOrigin, cv::Point3f rayDir, cv::Point3f sphereOrigin, float sphereRadius){

	float dx = rayDir.x;
	float dy = rayDir.y;
	float dz = rayDir.z;
	float x0 = rayOrigin.x;
	float y0 = rayOrigin.y;
	float z0 = rayOrigin.z;
	float cx = sphereOrigin.x;
	float cy = sphereOrigin.y;
	float cz = sphereOrigin.z;
	float r = sphereRadius;

	float a = dx*dx + dy*dy + dz*dz;
	float b = 2*dx*(x0-cx) + 2*dy*(y0-cy) + 2*dz*(z0-cz);
	float c = cx*cx + cy*cy + cz*cz + x0*x0 + y0*y0 + z0*z0 + -2*(cx*x0 + cy*y0 + cz*z0) - r*r;

	float disc = b*b - 4*a*c;

	float t = (-b - sqrt(b*b - 4*a*c))/2*a;

	// This implies that the lines did not intersect, point straight ahead
	if (b*b - 4 * a*c < 0)
		return cv::Point3f(0, 0, -1);

	return rayOrigin + rayDir * t;
}

cv::Point3f GazeAnalysis::GetPupilPosition(cv::Mat_<float> eyeLdmks3d){
	
	eyeLdmks3d = eyeLdmks3d.t();

	cv::Mat_<float> irisLdmks3d = eyeLdmks3d.rowRange(0,8);

	cv::Point3f p (mean(irisLdmks3d.col(0))[0], mean(irisLdmks3d.col(1))[0], mean(irisLdmks3d.col(2))[0]);
	return p;
}

void GazeAnalysis::EstimateGaze(const LandmarkDetector::CLNF& clnf_model, cv::Point3f& gaze_absolute, float fx, float fy, float cx, float cy, bool left_eye)
{
	cv::Vec6f headPose = LandmarkDetector::GetPose(clnf_model, fx, fy, cx, cy);
	cv::Vec3f eulerAngles(headPose(3), headPose(4), headPose(5));
	cv::Matx33f rotMat = Utilities::Euler2RotationMatrix(eulerAngles);

	int part = -1;
	for (size_t i = 0; i < clnf_model.hierarchical_models.size(); ++i)
	{
		if (left_eye && clnf_model.hierarchical_model_names[i].compare("left_eye_28") == 0)
		{
			part = i;
		}
		if (!left_eye && clnf_model.hierarchical_model_names[i].compare("right_eye_28") == 0)
		{
			part = i;
		}
	}

	if (part == -1)
	{
		std::cout << "Couldn't find the eye model, something wrong" << std::endl;
		gaze_absolute = cv::Point3f(0, 0, 0);
		return;
	}

	cv::Mat eyeLdmks3d = clnf_model.hierarchical_models[part].GetShape(fx, fy, cx, cy);

	cv::Point3f pupil = GetPupilPosition(eyeLdmks3d);
	cv::Point3f rayDir = pupil / norm(pupil);

	cv::Mat faceLdmks3d = clnf_model.GetShape(fx, fy, cx, cy);
	faceLdmks3d = faceLdmks3d.t();

	cv::Mat offset = (cv::Mat_<float>(3, 1) << 0, -3.5, 7.0);

	int eyeIdx = 1;
	if (left_eye)
	{
		eyeIdx = 0;
	}

	cv::Mat eyeballCentreMat = (faceLdmks3d.row(36+eyeIdx*6) + faceLdmks3d.row(39+eyeIdx*6))/2.0f + (cv::Mat(rotMat)*offset).t();

	cv::Point3f eyeballCentre = cv::Point3f(eyeballCentreMat);

	cv::Point3f gazeVecAxis = RaySphereIntersect(cv::Point3f(0,0,0), rayDir, eyeballCentre, 12) - eyeballCentre;
	
	gaze_absolute = gazeVecAxis / norm(gazeVecAxis);
}

cv::Vec2f GazeAnalysis::GetGazeAngle(cv::Point3f& gaze_vector_1, cv::Point3f& gaze_vector_2)
{

	cv::Point3f gaze_vector = (gaze_vector_1 + gaze_vector_2) / 2;

	double x_angle = atan2(gaze_vector.x, -gaze_vector.z);
	double y_angle = atan2(gaze_vector.y, -gaze_vector.z);

	return cv::Vec2f(x_angle, y_angle);

}