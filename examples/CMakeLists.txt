cmake_minimum_required(VERSION 3.16)
cmake_policy(SET CMP0144 NEW)

project(ISHMEM_tutorial)

include(FindPackageHandleStandardArgs)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/modules)

find_package(ISHMEM REQUIRED)
find_package(Threads)

set(CMAKE_CXX_COMPILER oshc++)
add_compile_options(-fsycl)
add_link_options(-fsycl)
add_link_options(-lze_loader)

add_executable(hello 1_helloworld.cpp)
target_link_libraries(hello ISHMEM)
target_link_libraries(hello ${CMAKE_THREAD_LIBS_INIT})

add_executable(get 2_get.cpp)
target_link_libraries(get ISHMEM)
target_link_libraries(get ${CMAKE_THREAD_LIBS_INIT})
