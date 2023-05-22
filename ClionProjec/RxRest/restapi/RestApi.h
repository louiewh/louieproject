//
// Created by louie on 2019/12/19.
//

#ifndef RXREST_RESTAPI_H
#define RXREST_RESTAPI_H

#include <cpprest/http_client.h>
#include <cpprest/filestream.h>
#include <cpprest/json.h>

using namespace utility;                    // Common utilities like string conversions
using namespace web::http;                  // Common HTTP functionality
using namespace web::http::client;          // HTTP client features
using namespace concurrency::streams;       // Asynchronous streams

#include "rxcpp/rx.hpp"
namespace Rx {
    using namespace rxcpp;
    using namespace rxcpp::sources;
    using namespace rxcpp::operators;
    using namespace rxcpp::util;
}
using namespace Rx;

#include <nlohmann/json.hpp>
using nlohmann::json;

template<class T>
class RestApi {

private:
    http_client client;

public:

    RestApi(const uri &base_uri) : client(base_uri) {}

    observable<string_t> getString(const string_t &path_query_fragment) {
        return observable<>::create<string_t>(
                [&](subscriber<string_t> s){
                    client
                            .request(methods::GET, path_query_fragment)
                            .then([](http_response response) -> pplx::task<string_t> {
                                return response.extract_string();
                            })
                            .then([&](pplx::task<string_t> previousTask) {
                                try {
                                    string_t const & v = previousTask.get();
                                    s.on_next(v);
                                    s.on_completed();
                                } catch (http_exception const & e) {
                                    s.on_error(std::current_exception());
                                }
                            })
                            .wait();
                });
    }

    observable<T> getObject(const string_t &path_query_fragment) {
        return observable<>::create<T>(
                [&](subscriber<T> s){
                    client
                            .request(methods::GET, path_query_fragment)
                            .then([](http_response response) -> pplx::task<string_t> {

                                return response.extract_string();
                            })
                            .then([&](pplx::task<string_t> previousTask) {
                                try {
                                    string_t const & v = previousTask.get();

                                    std::cout << v << std::endl;
                                    json j = json::parse(v);
                                    T t = j;
                                    s.on_next(t);
                                    s.on_completed();
                                } catch (http_exception const & e) {
                                    s.on_error(std::current_exception());
                                }
                            })
                            .wait();
                });
    }

    observable<T> getArray(const string_t &path_query_fragment) {
        return observable<>::create<T>(
                [&](subscriber<T> s){
                    client
                            .request(methods::GET, path_query_fragment)
                            .then([](http_response response) -> pplx::task<string_t> {
                                return response.extract_string();
                            })
                            .then([&](pplx::task<string_t> previousTask) {
                                try {
                                    string_t const & v = previousTask.get();
                                    json j = json::parse(v);
                                    std::vector<T> vec = j;
                                    for(const auto& t : vec)
                                        s.on_next(t);
                                    s.on_completed();
                                } catch (http_exception const & e) {
                                    s.on_error(std::current_exception());
                                }
                            })
                            .wait();
                });
    }

    observable<string_t> createObject(const string_t& url, const T& obj) {
        return observable<>::create<string_t>(
                [&](subscriber<string_t> s){
                    json j = obj;
                    client
                            .request(methods::POST, url, j.dump(), U("application/json"))
                            .then([](http_response response) -> pplx::task<string_t> {
                                return response.extract_string();
                            })
                            .then([&](pplx::task<string_t> previousTask) {
                                try {
                                    string_t const & v = previousTask.get();
                                    s.on_next(v);
                                    s.on_completed();
                                } catch (http_exception const & e) {
                                    s.on_error(std::current_exception());
                                }
                            })
                            .wait();
                });
    }

    observable<string_t> updateObject(const string_t& url, const T& obj) {
        return observable<>::create<string_t>(
                [&](subscriber<string_t> s){
                    json j = obj;
                    client
                            .request(methods::PUT, url, j.dump(), U("application/json"))
                            .then([](http_response response) -> pplx::task<string_t> {
                                return response.extract_string();
                            })
                            .then([&](pplx::task<string_t> previousTask) {
                                try {
                                    string_t const & v = previousTask.get();
                                    s.on_next(v);
                                    s.on_completed();
                                } catch (http_exception const & e) {
                                    s.on_error(std::current_exception());
                                }
                            })
                            .wait();
                });
    }

    observable<string_t> deleteObject(const string_t& url) {
        return observable<>::create<string_t>(
                [&](subscriber<string_t> s){
                    client
                            .request(methods::DEL, url)
                            .then([](http_response response) -> pplx::task<string_t> {
                                return response.extract_string();
                            })
                            .then([&](pplx::task<string_t> previousTask) {
                                try {
                                    string_t const & v = previousTask.get();
                                    s.on_next(v);
                                    s.on_completed();
                                } catch (http_exception const & e) {
                                    s.on_error(std::current_exception());
                                }
                            })
                            .wait();
                });
    }

//    pplx::task<void> UploadFileToDropBoxAsync(std::shared_ptr<credentials>& creds)
//    {
//        using concurrency::streams::file_stream;
//        using concurrency::streams::basic_istream;
//        uri url(""DropBoxFileUploadURI"");
//        std::shared_ptr<oAuth> oAuthObj = std::make_shared<oAuth>();
//        auto signatureParams =oAuthObj->CreateOAuthSignedParameters(url.to_string(),
//                                                      L"PUT",
//                                                      NULL,
//                                                      consumerKey,
//                                                      consumerSecret,
//                                                      creds->Token(),
//                                                      creds->TokenSecret()
//                );
//
//        std::wstring sb = oAuthObj->OAuthBuildSignedHeaders(url);
//        return file_stream<unsigned char>::open_istream(LocalFiletoUpload)
//                .then([sb, url](pplx::task<basic_istream<unsigned char>> previousTask)
//                      {
//                          try
//                          {
//                              auto fileStream = previousTask.get();
//                              // Get the content length, which is used to set the
//                              // Content-Length property
//                              fileStream.seek(0, std::ios::end);
//                              auto length = static_cast<size_t>(fileStream.tell());
//                              fileStream.seek(0, 0);
//                              // Make HTTP request with the file stream as the body
//                              http_request req;
//                              http_client client();
//                              req.set_body(fileStream, length);
//                              req.set_method(methods::PUT);
//                              return client.request(req)
//                                      .then([fileStream](pplx::task<http_response> previousTask)
//                                            {
//                                                fileStream.close();
//                                                std::wostringstream ss;
//                                                try
//                                                {
//                                                    auto response = previousTask.get();
//                                                    auto body = response.body();
//                                                    ss << L"Server returned returned status code "
//                                                       << response.status_code() << L"."
//                                                       << std::endl;
//                                                    std::wcout << ss.str();
//                                                }
//                                                catch (const http_exception& e)
//                                                {
//                                                    ss << e.what() << std::endl;
//                                                }
//                                                std::wcout << ss.str();
//                                            });
//                          }
//                          catch (const std::system_error& e)
//                          {
//                              std::wostringstream ss;
//                              ss << e.what() << std::endl;
//                              std::wcout << ss.str();
//                              // Return an empty task
//                              return pplx::task_from_result();
//                          }
//                      });
//    }
};

#endif //RXREST_RESTAPI_H
