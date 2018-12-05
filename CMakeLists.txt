cmake_minimum_required(VERSION 3.1)
project(ToolDAQ)

option(BOOST "Install boost" ON)
option(ZMQ "Install ZMQ" ON)
option(ROOT "Install root (Note that this can take a while)" OFF)
option(SUMO "Install SuMo library" ON)
option(TOOLDAQ "Install ToolDAQFramework. This is required to run ToolDAQ" ON)

include(thirdparty.cmake)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/lib)


file(GLOB_RECURSE USERTOOLS_SOURCES UserTools/*/*.cpp)
# Get directories for each usertool
file(GLOB temp_dirs LIST_DIRECTORIES true UserTools/*)
set(USERTOOLS_INCLUDE_DIR "")
FOREACH(dir ${temp_dirs})
    IF(IS_DIRECTORY ${dir})
        LIST(APPEND USERTOOLS_INCLUDE_DIR ${dir})
    ENDIF()
ENDFOREACH()

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${TOOLDAQ_DIR}/src/Store)
include_directories(${TOOLDAQ_DIR}/src/Tool)
include_directories(${CMAKE_SOURCE_DIR}/DataModel)
include_directories(${TOOLDAQ_DIR}/src/ServiceDiscovery)
include_directories(${TOOLDAQ_DIR}/src/Logging)
include_directories(${TOOLDAQ_DIR}/src/ToolChain)
include_directories(${TOOLDAQ_DIR}/UserTools/Factory)
include_directories(${USERTOOLS_INCLUDE_DIRS})

add_executable(main
        ${CMAKE_SOURCE_DIR}/src/main.cpp)
add_library(Store
        ${TOOLDAQ_DIR}/src/Store/BoostStore.cpp
        ${TOOLDAQ_DIR}/src/Store/Store.cpp)
add_library(DataModel
        ${CMAKE_SOURCE_DIR}/DataModel/DataModel.cpp)
add_library(MyTools
        ${USERTOOLS_SOURCES})
add_executable(RemoteControl
        ${TOOLDAQ_DIR}/src/RemoteControl/RemoteControl.cpp)
add_executable(NodeDaemon
        ${TOOLDAQ_DIR}/src/NodeDaemon/NodeDaemon.cpp)
add_library(ServiceDiscovery
        ${TOOLDAQ_DIR}/src/ServiceDiscovery/ServiceDiscovery.cpp)
add_library(Logging
        ${TOOLDAQ_DIR}/src/Logging/Logging.cpp)
add_library(ToolChain
        ${TOOLDAQ_DIR}/src/ToolChain/ToolChain.cpp)

target_link_libraries(main Store MyTools ToolChain DataModel Loggin ServiceDiscovery pthread ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(Store ${BOOST_LIBRARY})
target_link_libraries(DataModel Logging Store ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(MyTools Store DataModel Logging ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(RemoteControl Store ServiceDiscovery ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(NodeDaemon Store ServiceDiscovery ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(ServiceDiscovery Store ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(Logging Store ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
target_link_libraries(ToolChain Logging Store MyTools ServiceDiscovery DataModel ${ZMQ_LIBRARY} ${BOOST_LIBRARY})
