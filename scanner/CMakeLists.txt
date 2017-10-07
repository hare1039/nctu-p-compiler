cmake_minimum_required(VERSION 2.8)

project(p-compiler)
find_package(FLEX REQUIRED)
FLEX_TARGET(scanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.c)
include_directories(${FLEX_INCLUDE_DIRS})
target_link_libraries(${FLEX_LIBRARIES})
add_executable(scanner scanner.c)
