# Local libraries
include_directories(${LandmarkDetector_SOURCE_DIR}/include)
	
add_executable(FaceLandmarkImg FaceLandmarkImg.cpp)
target_link_libraries(FaceLandmarkImg LandmarkDetector)
target_link_libraries(FaceLandmarkImg FaceAnalyser)
target_link_libraries(FaceLandmarkImg GazeAnalyser)
target_link_libraries(FaceLandmarkImg Utilities)

install (TARGETS FaceLandmarkImg DESTINATION bin)