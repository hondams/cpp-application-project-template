# <Copyright Holder>. Copyright (C) <Copyright Year(s)>. <License>.

#
# Project Properties
#
cmake_minimum_required(VERSION 3.30)
cmake_policy(SET CMP0077 NEW)

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
set(project_LIB ${PROJECT_NAME}-lib)
set(test_BIN ${PROJECT_NAME}-unittests)

file(GLOB_RECURSE app_SRC_FILES
        ${app_SRC_DIR}/*.cpp
        ${app_SRC_DIR}/*.cxx
        ${app_SRC_DIR}/*.cc
        ${app_SRC_DIR}/*.C
        ${app_SRC_DIR}/*.c
        ${app_SRC_DIR}/*.h
        ${app_SRC_DIR}/*.hpp)
file(GLOB_RECURSE project_SRC_FILES
        ${project_SRC_DIR}/*.cpp
        ${project_SRC_DIR}/*.cxx
        ${project_SRC_DIR}/*.cc
        ${project_SRC_DIR}/*.C
        ${project_SRC_DIR}/*.c
        ${project_SRC_DIR}/*.h
        ${project_SRC_DIR}/*.hpp)
file(GLOB_RECURSE test_SRC_FILES
        ${test_SRC_DIR}/*.cpp
        ${test_SRC_DIR}/*.cxx
        ${test_SRC_DIR}/*.cc
        ${test_SRC_DIR}/*.C
        ${test_SRC_DIR}/*.c
        ${test_SRC_DIR}/*.h
        ${test_SRC_DIR}/*.hpp)

file(GLOB_RECURSE app_CONFIG_FILES ${app_SRC_DIR}/*.h.in.cmake)
file(GLOB_RECURSE project_CONFIG_FILES ${project_SRC_DIR}/*.h.in.cmake)
file(GLOB_RECURSE test_CONFIG_FILES ${test_SRC_DIR}/*.h.in.cmake)


set(nanovg_DIR thirdparty/nanovg)
set(nanovg_SRC_DIR ${nanovg_DIR}/src)
file(GLOB_RECURSE nanovg_SRC_FILES ${nanovg_SRC_DIR}/*)

set(bgfx_cmake_DIR thirdparty/bgfx.cmake)
set(bx_DIR ${bgfx_cmake_DIR}/bx)
set(bgfx_DIR ${bgfx_cmake_DIR}/bgfx)
set(bimg_DIR ${bgfx_cmake_DIR}/bimg)
set(bx_INCLUDE_DIR ${bx_DIR}/include)
set(bgfx_INCLUDE_DIR ${bgfx_DIR}/include)
set(bimg_INCLUDE_DIR ${bimg_DIR}/include)
set(bgfx_examples_common_INCLUDE_DIR ${bgfx_cmake_DIR})
file(GLOB_RECURSE bgfx_examples_common_SRC_FILES ${bgfx_DIR}/examples/common/*)

set(BGFX_BUILD_EXAMPLES OFF)
if(EMSCRIPTEN)
    set(BGFX_BUILD_EXAMPLE_COMMON OFF)
    set(BGFX_BUILD_TOOLS OFF)
endif ()

set(dear_imgui_INCLUDE_DIR ${bgfx_DIR}/3rdparty)
file(GLOB_RECURSE dear_imgui_SRC_FILES ${bgfx_DIR}/3rdparty/dear-imgui/*)

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
#FetchContent_Declare(
#        spdlog
#        URL https://github.com/gabime/spdlog/archive/f355b3d58f7067eee1706ff3c801c2361011f3d5.zip # v1.15.1
#)

#FetchContent_MakeAvailable(Boost googletest spdlog)
FetchContent_MakeAvailable(Boost googletest)

# nanovg
add_library(nanovg STATIC ${nanovg_SRC_FILES})
target_include_directories(nanovg PUBLIC ${nanovg_SRC_DIR})

# bgfx
add_subdirectory(${bgfx_cmake_DIR})


# dear-imgui
add_library(dear_imgui STATIC ${dear_imgui_SRC_FILES})
target_include_directories(dear_imgui PUBLIC ${dear_imgui_INCLUDE_DIR} ${bx_INCLUDE_DIR} )
target_link_libraries(dear_imgui PUBLIC bgfx)

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
add_library(${project_LIB} ${project_SRC_FILES}
        ${bgfx_examples_common_SRC_FILES})
target_include_directories(${project_LIB} PUBLIC
        ${project_SRC_DIR} ${nanovg_SRC_DIR}
        ${bx_INCLUDE_DIR} ${bgfx_INCLUDE_DIR} ${bimg_INCLUDE_DIR}
        ${bgfx_examples_common_INCLUDE_DIR} ${dear_imgui_INCLUDE_DIR}
)
target_link_libraries(${project_LIB} PUBLIC
#        spdlog
        nanovg
        dear_imgui
        bgfx
        Boost::format)
if(EMSCRIPTEN)
    target_compile_options(${project_LIB} PRIVATE -msimd128 -matomics -mbulk-memory)
    target_link_options(${project_LIB} PRIVATE -msimd128 -matomics -mbulk-memory)
endif ()

if(EMSCRIPTEN)
    add_compile_options("-pthread")
    add_compile_options("-fwasm-exceptions")

    add_executable(${project_BIN} ${app_SRC_FILES})
    set_property(TARGET ${project_BIN} PROPERTY SUFFIX ".html")
    target_link_options(${project_BIN} PRIVATE
#            "-sALLOW_MEMORY_GROWTH=1"
#            "-sALLOW_TABLE_GROWTH=1"
            "-sSAFE_HEAP=1"
            "-sFULL_ES3"
            "-pthread"
            "-fwasm-exceptions"
            #  "-sPTHREAD_POOL_SIZE=navigator.hardwareConcurrency"
            "-sPTHREAD_POOL_SIZE=4"
#            "-sMAXIMUM_MEMORY=1024mb"
            "-sINITIAL_MEMORY=1024mb"
    )
    target_include_directories(${project_BIN} PUBLIC
            ${app_SRC_DIR}
            ${project_LIB})
    target_link_libraries(${project_BIN} PUBLIC
            ${project_LIB})
    set_target_properties(${project_BIN} PROPERTIES VERSION "${APPLICATION_VERSION_MAJOR}.${APPLICATION_VERSION_MINOR}" OUTPUT_NAME ${project_BIN} CLEAN_DIRECT_OUTPUT 1)
else()
    add_executable(${project_BIN} ${app_SRC_FILES})
    target_include_directories(${project_BIN} PUBLIC
            ${app_SRC_DIR}
            ${project_LIB})
    target_link_libraries(${project_BIN} PUBLIC
            ${project_LIB})
    set_target_properties(${project_BIN} PROPERTIES VERSION "${APPLICATION_VERSION_MAJOR}.${APPLICATION_VERSION_MINOR}" OUTPUT_NAME ${project_BIN} CLEAN_DIRECT_OUTPUT 1)
    install(TARGETS ${project_BIN} DESTINATION bin)
endif()


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
