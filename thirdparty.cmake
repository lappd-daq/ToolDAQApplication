find_package(Threads REQUIRED)
include(ExternalProject)
include(ProcessorCount)
ProcessorCount(NCORES)

if(TOOLDAQ)
    ExternalProject_Add(tooldaq_project
            GIT_REPOSITORY "https://github.com/tooldaq/tooldaqframework"
            GIT_TAG "master"
            CONFIGURE_COMMAND ""
            INSTALL_COMMAND ""
            BUILD_COMMAND ""
            TEST_COMMAND ""
            LOG_DOWNLOAD ON
            PREFIX tooldaq)

    ExternalProject_Get_Property(tooldaq_project source_dir)
    include_directories(${source_dir}/include)
    set(TOOLDAQ_DIR ${source_dir})
endif(TOOLDAQ)

if(SUMO)
    ExternalProject_Add(sumo_project
            GIT_REPOSITORY "https://github.com/lappd-daq/acdc-daq"
            GIT_TAG "interface"
            INSTALL_COMMAND ""
            TEST_COMMAND ""
            LOG_DOWNLOAD ON
            LOG_CONFIGURE ON
            LOG_BUILD ON
            LOG_INSTALL ON
            PREFIX sumo)

    ExternalProject_Get_Property(sumo_project source_dir)
    ExternalProject_Get_Property(sumo_project binary_dir)
    include_directories(${source_dir}/include)

    ExternalProject_Get_Property(sumo_project binary_dir)
    set(SUMO_LIBRARY_PATH ${source_dir}/bin/libSuMo.a)
    set(SUMO_LIBRARY sumo)
    add_library(${SUMO_LIBRARY} UNKNOWN IMPORTED)
    set_target_properties(${SUMO_LIBRARY} PROPERTIES
            IMPORTED_LOCATION ${SUMO_LIBRARY_PATH})
    add_dependencies(${SUMO_LIBRARY} sumo_project)
endif(SUMO)

if(ZMQ)
    ExternalProject_Add(zmq_project
            GIT_REPOSITORY "https://github.com/ToolDAQ/zeromq-4.0.7"
            GIT_TAG "master"
            CONFIGURE_COMMAND ../zmq_project/configure
            BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -j${NCORES}
            INSTALL_COMMAND ""
            TEST_COMMAND ""
            LOG_DOWNLOAD ON
            LOG_CONFIGURE ON
            LOG_BUILD ON
            PREFIX zmq)

    ExternalProject_Get_Property(zmq_project source_dir)
    ExternalProject_Get_Property(zmq_project binary_dir)
    include_directories(${source_dir}/include)

    ExternalProject_Get_Property(zmq_project binary_dir)
    set(ZMQ_LIBRARY_PATH ${binary_dir}/src/.libs/libzmq.a)
    set(ZMQ_LIBRARY zmq)
    add_library(${ZMQ_LIBRARY} UNKNOWN IMPORTED)
    set_target_properties(${ZMQ_LIBRARY} PROPERTIES
            IMPORTED_LOCATION ${ZMQ_LIBRARY_PATH})
    add_dependencies(${ZMQ_LIBRARY} zmq_project)
endif(ZMQ)

if(BOOST)
    ExternalProject_Add(boost_project
            GIT_REPOSITORY "https://github.com/ToolDAQ/boost_1_66_0"
            GIT_TAG "master"
            CONFIGURE_COMMAND ./bootstrap.sh --prefix=.
            BUILD_COMMAND ./b2 --prefix=. install --with-iostreams -j${NCORES}
            INSTALL_COMMAND ""
            TEST_COMMAND ""
            LOG_DOWNLOAD ON
            LOG_CONFIGURE ON
            LOG_BUILD ON
            PREFIX boost
            BINARY_DIR boost/src/boost_project)

    ExternalProject_Get_Property(boost_project source_dir)
    ExternalProject_Get_Property(boost_project binary_dir)
    include_directories(${source_dir}/include)

    ExternalProject_Get_Property(boost_project binary_dir)
    set(BOOST_LIBRARY_PATH ${binary_dir}/libboost_iostreams.a)
    set(BOOST_LIBRARY boost)
    add_library(${BOOST_LIBRARY} UNKNOWN IMPORTED)
    set_target_properties(${BOOST_LIBRARY} PROPERTIES
            IMPORTED_LOCATION ${BOOST_LIBRARY_PATH})
    add_dependencies(${BOOST_LIBRARY} boost_project)
endif(BOOST)

if(ROOT)
    ExternalProject_Add(root_project
            GIT_REPOSITORY "https://github.com/root-project/root"
            GIT_TAG "v6-14-00"
            INSTALL_COMMAND source bin/thisroot.sh
            TEST_COMMAND ""
            LOG_DOWNLOAD ON
            LOG_CONFIGURE ON
            LOG_BUILD ON
            PREFIX root)

    ExternalProject_Get_Property(root_project source_dir)
    ExternalProject_Get_Property(root_project binary_dir)
    include_directories(${source_dir}/include)

    ExternalProject_Get_Property(root_project binary_dir)
    set(ROOT_LIBRARY_PATH ${binary_dir}/libboost_iostreams.a)
    set(ROOT_LIBRARY root)
    add_library(${ROOT_LIBRARY} UNKNOWN IMPORTED)
    set_target_properties(${ROOT_LIBRARY} PROPERTIES
            IMPORTED_LOCATION ${ROOT_LIBRARY_PATH})
    add_dependencies(${ROOT_LIBRARY} root_project)

endif(ROOT)