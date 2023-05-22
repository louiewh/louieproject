#include <iostream>

#include "rxcpp/RxcppTest.h"
#include "cpprest/BingTest.h"
#include "cpprest/HttpRestTest.h"
#include "HttpRxRest/HttpRxRest.h"

int main() {
    std::cout << "Hello, RestFull!" << std::endl;
    BingTest::main();
    HttpRestTest::main();

    RxcppTest::main();
    HttpRxRest::main();
    return 0;
}