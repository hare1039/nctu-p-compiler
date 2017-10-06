cmake_minimum_required(VERSION 2.8)

project(p-compiler)
find_package(FLEX REQUIRED)
FLEX_TARGET(scanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.c)

#ADD_FLEX_BISON_DEPENDENCY(scanner p-compiler)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(p-compiler
    main.cpp
    ${FLEX_scanner_OUTPUTS}
)
