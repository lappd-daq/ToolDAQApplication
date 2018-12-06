ExternalProject_Add(zmq_project
        GIT_REPOSITORY "https://github.com/zeromq/libzmq"
        GIT_TAG "v4.3.0"
        INSTALL_COMMAND ""
        TEST_COMMAND ""
        PREFIX zmq)
ExternalProject_Get_Property(zmq_project source_dir)
ExternalProject_Get_Property(zmq_project binary_dir)
include_directories(${source_dir}/include)
set(ZMQ_LIBRARIES zmq)
add_library(${ZMQ_LIBRARIES} UNKNOWN IMPORTED)
set_target_properties(${ZMQ_LIBRARIES} PROPERTIES
        IMPORTED_LOCATION ${binary_dir}/lib/libzmq.a)
add_dependencies(${ZMQ_LIBRARIES} zmq_project)


ExternalProject_Add(cppzmq_project
        GIT_REPOSITORY "https://github.com/zeromq/cppzmq"
        GIT_TAG "v4.3.0"
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ""
        PREFIX cppzmq)
ExternalProject_Get_Property(cppzmq_project source_dir)
include_directories(${source_dir})