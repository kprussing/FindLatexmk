cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(FindLatexmk LANGUAGES NONE VERSION 0.1)

file(READ usage.rst usage)
configure_file(FindLatexmk.cmake.in FindLatexmk.cmake @ONLY)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_BINARY_DIR}")
find_package(Latexmk REQUIRED)

enable_testing()
add_subdirectory(tests)
