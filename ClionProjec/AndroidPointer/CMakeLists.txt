cmake_minimum_required(VERSION 3.6)
project(AndroidPointer)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp RefBase.cpp RefBase.h StrongPointer.h)
add_executable(AndroidPointer ${SOURCE_FILES})