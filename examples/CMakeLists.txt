# Copyright (C) 2024 Intel Corporation                                                                                                                                                                                                      # SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.16)
cmake_policy(SET CMP0144 NEW) # look for ISHMEM_ROOT

project(ISHMEM_tutorial)

include(FindPackageHandleStandardArgs)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/modules)

find_package(ISHMEM REQUIRED)
find_package(Threads)

set(CMAKE_CXX_COMPILER oshc++)
add_compile_options(-fsycl)
add_link_options(-fsycl)
add_link_options(-lze_loader)

add_executable(1_hello 1_helloworld.cpp)
target_link_libraries(1_hello ISHMEM)
target_link_libraries(1_hello ${CMAKE_THREAD_LIBS_INIT})

add_executable(2_get 2_get.cpp)
target_link_libraries(2_get ISHMEM)
target_link_libraries(2_get ${CMAKE_THREAD_LIBS_INIT})

add_executable(3_library_apis 3_library_apis.cpp)
target_link_libraries(3_library_apis ISHMEM)
target_link_libraries(3_library_apis ${CMAKE_THREAD_LIBS_INIT})

add_executable(4_pi 4_pi.cpp)
target_link_libraries(4_pi ISHMEM)
target_link_libraries(4_pi ${CMAKE_THREAD_LIBS_INIT})

add_executable(5_pi_reduce 5_pi_reduce.cpp)
target_link_libraries(5_pi_reduce ISHMEM)
target_link_libraries(5_pi_reduce ${CMAKE_THREAD_LIBS_INIT})

add_executable(6_team_split_strided 6_team_split_strided.cpp)
target_link_libraries(6_team_split_strided ISHMEM)
target_link_libraries(6_team_split_strided ${CMAKE_THREAD_LIBS_INIT})
