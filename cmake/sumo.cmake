ExternalProject_Add(sumo_project
        GIT_REPOSITORY "https://github.com/lappd-daq/acdc-daq"
        GIT_TAG "interface"
        INSTALL_COMMAND ""
        TEST_COMMAND ""
        PREFIX sumo)

ExternalProject_Get_Property(sumo_project source_dir)
ExternalProject_Get_Property(sumo_project binary_dir)
include_directories(${source_dir}/include)

ExternalProject_Get_Property(sumo_project binary_dir)
set(SUMO_LIBRARIES_PATH ${source_dir}/bin/libSuMo.a)
set(SUMO_LIBRARIES sumo)
add_library(${SUMO_LIBRARIES} UNKNOWN IMPORTED)
set_target_properties(${SUMO_LIBRARIES} PROPERTIES
        IMPORTED_LOCATION ${SUMO_LIBRARIES_PATH})
add_dependencies(${SUMO_LIBRARIES} sumo_project)