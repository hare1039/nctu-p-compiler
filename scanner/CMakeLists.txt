cmake_minimum_required(VERSION 3.1)

project(p-compiler)
set (CMAKE_CXX_STANDARD 11)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(FLEX REQUIRED)
if(FLEX_FOUND)
    FLEX_TARGET(scanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp COMPILE_FLAGS "-+")
    include_directories(${FLEX_INCLUDE_DIRS})
    add_executable(scanner scanner.cpp)

#    target_link_libraries(scanner ${FLEX_LIBRARIES})
    
endif(FLEX_FOUND)
