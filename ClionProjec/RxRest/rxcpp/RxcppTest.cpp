//
// Created by louie on 2019/12/17.
//

#include "RxcppTest.h"

#include "rxcpp/rx.hpp"

namespace Rx {
    using namespace rxcpp;
    using namespace rxcpp::sources;
    using namespace rxcpp::operators;
    using namespace rxcpp::util;
}
using namespace Rx;

int RxcppTest::main() {


    {   // Creating
        auto observableCreate = observable<>::create<int>(
                [](subscriber<int> s) {
                    s.on_next(1);
                    s.on_next(2);
                    s.on_completed();
                });
        observableCreate.subscribe(
                [](int v) { printf("OnNext: %d\n", v); },
                []() { printf("create OnCompleted\n"); });
    }

    {   // Converting
        std::array<int, 3> a = {{1, 2, 3}};
        auto values1 = observable<>::iterate(a);
        values1.subscribe(
                [](int v) { printf("OnNext: %d\n", v); },
                []() { printf("iterate OnCompleted\n"); });

    }

    {   // Combining
        auto values = observable<>::range(1); // infinite (until overflow) stream of integers
        auto s1 = values.
                take(3).
                map([](int prime) { return std::make_tuple("1:", prime); });
        auto s2 = values.
                take(3).
                map([](int prime) { return std::make_tuple("2:", prime); });
        s1.
                concat(s2).
                subscribe(apply_to(
                [](const char *s, int p) {
                    printf("%s %d\n", s, p);
                }));
    }


    {
        auto values = observable<>::range(1); // infinite (until overflow) stream of integers
        auto s1 = values.
                map([](int prime) { return std::make_tuple("1:", prime); });
        auto s2 = values.
                map([](int prime) { return std::make_tuple("2:", prime); });
        s1.
                merge(s2).
                take(6).
                as_blocking().
                subscribe(apply_to(
                [](const char *s, int p) {
                    printf("%s %d\n", s, p);
                }));

    }

}

