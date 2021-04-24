cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(FindLatexmk LANGUAGES NONE VERSION 0.1)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}")

find_package(Latexmk REQUIRED)
enable_testing()
add_subdirectory(tests)
