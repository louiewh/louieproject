#include <iostream>

#include "RefBase.h"
#include "StrongPointer.h"


using namespace std;
using namespace android;

class LightRefBaseTest2;

class LightRefBaseTest: public LightRefBase<LightRefBaseTest>{
public:
    LightRefBaseTest(){std::cout << "Hello, LightRefBaseTest!" << std::endl;};
    ~LightRefBaseTest(){std::cout << "Hello, ~LightRefBaseTest()!" << std::endl;};
    void setPointer(sp<LightRefBaseTest2> pointer){mPointer = pointer;};
private:
    sp<LightRefBaseTest2>  mPointer;
};


class LightRefBaseTest2: public LightRefBase<LightRefBaseTest>{
public:
    LightRefBaseTest2(){std::cout << "Hello, LightRefBaseTest2!" << std::endl;};
    ~LightRefBaseTest2(){std::cout << "Hello, ~LightRefBaseTest2()!" << std::endl;};
    void setPointer(sp<LightRefBaseTest> pointer){mPointer = pointer;};

private:
    sp<LightRefBaseTest>  mPointer;
};

class SubRefBaseTest;
class RefBaseTest: public RefBase{
public:
    RefBaseTest(){std::cout << "Hello, RefBaseTest!" << std::endl;};
    ~RefBaseTest(){std::cout << "Hello, ~RefBaseTest()!" << std::endl;};
    void setPointer(wp<SubRefBaseTest> pointer){
        mPointer = pointer;
    };

private:
    wp<SubRefBaseTest> mPointer;
};


class SubRefBaseTest: public RefBase{
public:
    SubRefBaseTest(){ std::cout << "Hello, SubRefBaseTest!" << std::endl;};
    ~SubRefBaseTest(){std::cout << "Hello, ~SubRefBaseTest()!" << std::endl;};
    void setPointer(sp<RefBaseTest> pointer){
        mPointer = pointer;
    };
private:
    sp<RefBaseTest> mPointer;
};

int main() {
    std::cout << "Hello, World!" << std::endl;
//    LightRefBaseTest* lightTest = new LightRefBaseTest();
//    sp<LightRefBaseTest> sp1 = new LightRefBaseTest();
//    sp<LightRefBaseTest2> sp2 = new LightRefBaseTest2();
//    sp1->setPointer(sp2);
//    sp2->setPointer(sp1);
//    sp<RefBaseTest>  refBaseTest = new RefBaseTest();
//    sp<SubRefBaseTest>  subRefBaseTest = new SubRefBaseTest();
//
//    refBaseTest->setPointer(subRefBaseTest);
//    subRefBaseTest->setPointer(refBaseTest);

//    wp<RefBaseTest> wp1 = new RefBaseTest();
    return 0;
}