find_package(ZLIB REQUIRED)
include_directories(${ZLIB_INCLUDE_DIRS})
ExternalProject_Add(boost_project
        URL "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz"
        CONFIGURE_COMMAND ./bootstrap.sh --prefix=.
        BUILD_COMMAND ./b2 install link=static --with-iostreams --with-date_time --with-serialization
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ""
        TEST_COMMAND ""
        PREFIX boost)
ExternalProject_Get_Property(boost_project source_dir)
include_directories(${source_dir}/include)

set(BOOST_LIBRARIES boost_iostreams boost_date_time boost_serialization)
add_library(boost_iostreams UNKNOWN IMPORTED)
target_link_libraries(boost_iostreams INTERFACE ${ZLIB_LIBRARIES})
set_target_properties(boost_iostreams PROPERTIES
        IMPORTED_LOCATION ${source_dir}/lib/libboost_iostreams.a)

add_library(boost_date_time UNKNOWN IMPORTED)
target_link_libraries(boost_date_time INTERFACE ${ZLIB_LIBRARIES})
set_target_properties(boost_date_time PROPERTIES
        IMPORTED_LOCATION ${source_dir}/lib/libboost_date_time.a)

add_library(boost_serialization UNKNOWN IMPORTED)
target_link_libraries(boost_serialization INTERFACE ${ZLIB_LIBRARIES})
set_target_properties(boost_serialization PROPERTIES
        IMPORTED_LOCATION ${source_dir}/lib/libboost_serialization.a)

add_dependencies(${BOOST_LIBRARIES} boost_project)