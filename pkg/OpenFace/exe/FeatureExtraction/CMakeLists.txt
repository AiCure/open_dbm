# Local libraries
include_directories(${LandmarkDetector_SOURCE_DIR}/include)
	
add_executable(FeatureExtraction FeatureExtraction.cpp)
target_link_libraries(FeatureExtraction LandmarkDetector)
target_link_libraries(FeatureExtraction FaceAnalyser)
target_link_libraries(FeatureExtraction GazeAnalyser)
target_link_libraries(FeatureExtraction Utilities)

install (TARGETS FeatureExtraction DESTINATION bin)