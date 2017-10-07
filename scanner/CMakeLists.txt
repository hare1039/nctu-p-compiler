cmake_minimum_required(VERSION 2.8)

project(p-compiler)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(FLEX REQUIRED)
if(FLEX_FOUND)
    FLEX_TARGET(scanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.c)
    include_directories(${FLEX_INCLUDE_DIRS})
    add_executable(scanner scanner.c)

    target_link_libraries(scanner ${FLEX_LIBRARIES})
    
endif(FLEX_FOUND)
