cmake_minimum_required(VERSION 3.15)
project(RxRest)

set(CMAKE_CXX_STANDARD 14)

find_package(Boost REQUIRED system)
find_package(cpprestsdk REQUIRED)


# Typically you don't care so much for a third party library's tests to be
# run from your own project's code.
set(JSON_BuildTests OFF CACHE INTERNAL "")

# If you only include this third party in PRIVATE source files, you do not
# need to install it when your main project gets installed.
# set(JSON_Install OFF CACHE INTERNAL "")

# Don't use include(nlohmann_json/CMakeLists.txt) since that carries with it
# unintended consequences that will break the build.  It's generally
# discouraged (although not necessarily well documented as such) to use
# include(...) for pulling in other CMake projects anyways.
add_subdirectory(nlohmann_json)

add_executable(RxRest main.cpp
        cpprest/BingTest.cpp cpprest/BingTest.h cpprest/HttpRestTest.cpp cpprest/HttpRestTest.h
        rxcpp/RxcppTest.cpp rxcpp/RxcppTest.h
        restapi/GithubUser.h restapi/RestApi.h restapi/Post.h restapi/Post.cpp
        HttpRxRest/HttpRxRest.cpp HttpRxRest/HttpRxRest.h restapi/GithubUser.cpp
        MultipartEncoder/multipart_parser.h MultipartEncoder/multipart_parser.cpp
        MultipartEncoder/parser_test.cpp
        )
target_link_libraries(RxRest PRIVATE cpprestsdk::cpprest ${Boost_SYSTEM_LIBRARY})
target_link_libraries(RxRest PRIVATE nlohmann_json::nlohmann_json)
