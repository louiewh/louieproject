cmake_minimum_required(VERSION 3.6)
project(LoopThread)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp src/LoopThread.cpp src/Looper.cpp include/LoopThread.h include/Looper.h  include/Message.h include/MessageQueue.h src/MessageQueue.cpp include/Handler.h)
add_executable(LoopThread ${SOURCE_FILES})