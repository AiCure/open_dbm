#LandmarkDetector library
include_directories(../../local/LandmarkDetector/include)

#Utilities library
include_directories(../../local/Utilities/include)

SET(SOURCE
    src/GazeEstimation.cpp
)

SET(HEADERS
    include/GazeEstimation.h
)

add_library( GazeAnalyser ${SOURCE} ${HEADERS})
add_library( OpenFace::GazeAnalyser ALIAS GazeAnalyser)

target_include_directories(GazeAnalyser PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/OpenFace>)

target_include_directories(GazeAnalyser PRIVATE ${GAZEANALYSER_SOURCE_DIR}/include)
target_include_directories(GazeAnalyser PUBLIC ${OpenCV_INCLUDE_DIRS})

target_link_libraries(GazeAnalyser PUBLIC ${OpenCV_LIBS} ${OpenBLAS_LIB})
target_link_libraries(GazeAnalyser PUBLIC dlib::dlib)

target_include_directories(GazeAnalyser PRIVATE ${OpenBLAS_INCLUDE_DIR})

install (TARGETS GazeAnalyser EXPORT OpenFaceTargets LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
install (FILES ${HEADERS} DESTINATION include/OpenFace)