# <Copyright Holder>. Copyright (C) <Copyright Year(s)>. <License>.

#
# Project Properties
#
cmake_minimum_required(VERSION 3.30)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(projectName)

set(APPLICATION_NAME "Project Name")
set(APPLICATION_CODENAME "${PROJECT_NAME}")
set(APPLICATION_COPYRIGHT_YEARS "2025")
set(APPLICATION_VERSION_MAJOR 1)
set(APPLICATION_VERSION_MINOR 0)
set(APPLICATION_VERSION_PATCH 0)
set(APPLICATION_VERSION_TYPE SNAPSHOT)
set(APPLICATION_VERSION_STRING "${APPLICATION_VERSION_MAJOR}.${APPLICATION_VERSION_MINOR}.${APPLICATION_VERSION_PATCH}-${APPLICATION_VERSION_TYPE}")
set(APPLICATION_VENDOR_ID "com.yourcompany")
set(APPLICATION_VENDOR_NAME "Your Company")
set(APPLICATION_VENDOR_URL "yourcompany.com")
set(APPLICATION_ID "${APPLICATION_VENDOR_ID}.${PROJECT_NAME}")


set(app_SRC_DIR app)
set(project_SRC_DIR src)
set(test_SRC_DIR test)

set(project_BIN ${PROJECT_NAME})
set(project_LIB lib${PROJECT_NAME})
set(test_BIN ${PROJECT_NAME}-unittests)

file(GLOB_RECURSE app_SRC_FILES ${app_SRC_DIR}/*.(cpp|cxx|cc|C|c|h|hpp))
file(GLOB_RECURSE project_SRC_FILES ${project_SRC_DIR}/*.(cpp|cxx|cc|C|c|h|hpp))
file(GLOB_RECURSE test_SRC_FILES ${test_SRC_DIR}/*.(cpp|cxx|cc|C|c|h|hpp))

file(GLOB_RECURSE app_CONFIG_FILES ${app_SRC_DIR}/*.h.in.cmake)
file(GLOB_RECURSE project_CONFIG_FILES ${project_SRC_DIR}/*.h.in.cmake)
file(GLOB_RECURSE test_CONFIG_FILES ${test_SRC_DIR}/*.h.in.cmake)


set(nanovg_DIR thirdparty/nanovg)
set(nanovg_SRC_DIR ${nanovg_DIR}/src)
file(GLOB_RECURSE nanovg_SRC_FILES ${nanovg_SRC_DIR}/*)

set(bgfx_cmake_DIR thirdparty/bgfx.cmake)
set(bx_DIR thirdparty/bgfx.cmake/bx)
set(bgfx_DIR thirdparty/bgfx.cmake/bgfx)
set(bimg_DIR thirdparty/bgfx.cmake/bimg)
set(bx_INCLUDE_DIR thirdparty/bgfx.cmake/bx/include)
set(bgfx_INCLUDE_DIR thirdparty/bgfx.cmake/bgfx/include)
set(bimg_INCLUDE_DIR thirdparty/bgfx.cmake/bimg/include)

#
# Debugging Options
#
set(CMAKE_VERBOSE_MAKEFILE 0) # Use 1 for debugging, 0 for release

#
# Locate Project Prerequisites
#
include(FetchContent)

# Boost
FetchContent_Declare(
    Boost
    URL https://github.com/boostorg/boost/releases/download/boost-1.87.0/boost-1.87.0-cmake.zip
    DOWNLOAD_EXTRACT_TIMESTAMP ON
)
# add using boost component
set(BOOST_INCLUDE_LIBRARIES format)

# googletest
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/a866428a78ab02b7072f96c8de15802ffd451a7f.zip # v1.16.0
)
if (WIN32)
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
endif ()

# spdlog
FetchContent_Declare(
        spdlog
        URL https://github.com/gabime/spdlog/archive/f355b3d58f7067eee1706ff3c801c2361011f3d5.zip # v1.15.1
)

FetchContent_MakeAvailable(Boost googletest spdlog)


# nanovg
add_library(nanovg STATIC ${nanovg_SRC_FILES})
target_include_directories(nanovg PUBLIC ${nanovg_SRC_DIR})

# bgfx
add_subdirectory(${bgfx_cmake_DIR})

#
# Configure Files
#
list(APPEND all_CONFIG_INPUTS "${app_CONFIG_FILES}")
list(APPEND all_CONFIG_INPUTS "${project_CONFIG_FILES}")
list(APPEND all_CONFIG_INPUTS "${test_CONFIG_FILES}")
foreach(config_input ${all_CONFIG_INPUTS})
    string(REPLACE ".h.in.cmake" ".h" config_output "${config_input}")
    configure_file("${config_input}" "${config_output}")
endforeach()

#
# For main build
#
add_library(${project_LIB} ${project_SRC_FILES})
target_include_directories(${project_LIB} PUBLIC
        ${project_SRC_DIR} ${nanovg_SRC_DIR}
        ${bx_INCLUDE_DIR} ${bgfx_INCLUDE_DIR} ${bimg_INCLUDE_DIR})
target_link_libraries(${project_LIB} PUBLIC
        spdlog
        nanovg
        bgfx
        Boost::format)

add_executable(${project_BIN} ${app_SRC_FILES})
target_include_directories(${project_BIN} PUBLIC
        ${app_SRC_DIR}
        ${project_LIB})
target_link_libraries(${project_BIN} PUBLIC
        ${project_LIB})
set_target_properties(${project_BIN} PROPERTIES VERSION "${APPLICATION_VERSION_MAJOR}.${APPLICATION_VERSION_MINOR}" OUTPUT_NAME ${project_BIN} CLEAN_DIRECT_OUTPUT 1)
install(TARGETS ${project_BIN} DESTINATION bin)


#
# For test
#
enable_testing()

add_executable(${test_BIN} ${test_SRC_FILES})
target_include_directories(${test_BIN} PUBLIC ${project_SRC_DIR})
target_link_libraries(${test_BIN} PUBLIC
        GTest::gmock
        GTest::gtest_main
        ${project_LIB})

include(GoogleTest)
gtest_discover_tests(${test_BIN})
