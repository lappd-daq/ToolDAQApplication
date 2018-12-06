cmake_minimum_required(VERSION 3.1)
project(ToolDAQApplication)

option(BOOST "Install boost" ON)
option(ZMQ "Install ZMQ" ON)
option(ROOT "Install root (Note that this can take a while)" OFF)
option(SUMO "Install SuMo library" ON)

find_package(Threads REQUIRED)
include(ExternalProject)
include(ProcessorCount)
ProcessorCount(NCORES)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
set(TOOLDAQ_DIR ${CMAKE_SOURCE_DIR}/tooldaqframework)

include(boost)
include(sumo)
include(zmq)

# Get each UserTools File
file(GLOB_RECURSE USERTOOLS_SOURCES UserTools/*/*.c*)

# Get directories for each usertool (don't add Factory in this instance)
file(GLOB temp_dirs LIST_DIRECTORIES true UserTools/*)
set(USERTOOLS_INCLUDE_DIRS "")
foreach(dir ${temp_dirs})
    if(IS_DIRECTORY ${dir})
        list(APPEND USERTOOLS_INCLUDE_DIRS ${dir})
    endif()
endforeach()

include_directories(${TOOLDAQ_DIR}/src/Store)
include_directories(${TOOLDAQ_DIR}/src/Tool)
include_directories(${CMAKE_SOURCE_DIR}/DataModel)
include_directories(${TOOLDAQ_DIR}/src/ServiceDiscovery)
include_directories(${TOOLDAQ_DIR}/src/Logging)
include_directories(${TOOLDAQ_DIR}/src/ToolChain)
include_directories(${USERTOOLS_INCLUDE_DIRS})


add_executable(main
        ${CMAKE_SOURCE_DIR}/src/main.cpp)
add_library(DataModel
        ${CMAKE_SOURCE_DIR}/DataModel/DataModel.cpp)
add_library(MyTools
        ${USERTOOLS_SOURCES})

# These are all made by tooldaq... perhaps let tooldaqframework have its own CMakeLists.txt

add_executable(RemoteControl
        ${TOOLDAQ_DIR}/src/RemoteControl/RemoteControl.cpp)
add_executable(NodeDaemon
        ${TOOLDAQ_DIR}/src/NodeDaemon/NodeDaemon.cpp)
add_library(Store
        ${TOOLDAQ_DIR}/src/Store/BoostStore.cpp
        ${TOOLDAQ_DIR}/src/Store/Store.cpp)
add_library(ServiceDiscovery
        ${TOOLDAQ_DIR}/src/ServiceDiscovery/ServiceDiscovery.cpp)
add_library(Logging
        ${TOOLDAQ_DIR}/src/Logging/Logging.cpp)
add_library(ToolChain
        ${TOOLDAQ_DIR}/src/ToolChain/ToolChain.cpp)

target_link_libraries(main ToolChain)
target_link_libraries(DataModel Logging Store ${ZMQ_LIBRARIES})
target_link_libraries(MyTools Store DataModel Logging ${SUMO_LIBRARIES})

target_link_libraries(Store ${BOOST_LIBRARIES})
target_link_libraries(RemoteControl ServiceDiscovery pthread ${ZMQ_LIBRARIES} ${BOOST_LIBRARIES})
target_link_libraries(NodeDaemon Store ServiceDiscovery pthread ${ZMQ_LIBRARIES} ${BOOST_LIBRARIES})
target_link_libraries(ServiceDiscovery Store ${ZMQ_LIBRARIES} ${BOOST_LIBRARIES})
target_link_libraries(Logging Store pthread ${ZMQ_LIBRARIES} ${BOOST_LIBRARIES})
target_link_libraries(ToolChain Logging Store MyTools ServiceDiscovery DataModel ${BOOST_LIBRARIES})
