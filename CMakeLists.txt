cmake_minimum_required(VERSION 3.16)
project(LearnOpenGL LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(project_defaults)
include(dependencies)

add_subdirectory(src)
