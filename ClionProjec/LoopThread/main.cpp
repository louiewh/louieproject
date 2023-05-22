#include <iostream>
#include "include/Message.h"
#include "include/LoopThread.h"
#include "include/Handler.h"

class MyHandler: public Handler{
public:
    MyHandler(){};
    MyHandler(Looper* looper):Handler(looper){};

    virtual void HandleMessage(Message msg){
        std::cout << "MyHandler, HandleMessage!" << std::endl;
    }
};

class MyHandler2: public Handler{
public:
    MyHandler2(){};
    MyHandler2(Looper* looper):Handler(looper){};

    virtual void HandleMessage(Message msg){
        std::cout << "MyHandler2, HandleMessage!" << std::endl;
    }
};

int main() {

    LoopThread* thread = new LoopThread();
    thread->Start();

    std::chrono::milliseconds timespan(3000);
    std::this_thread::sleep_for(timespan);

    MyHandler2 handler = MyHandler2(thread->GetLooper());
    Message* msg = handler.obtainMessage();
    handler.SendMessage(*msg);


    MyHandler myhandler = MyHandler(thread->GetLooper());
    Message* mymsg = myhandler.obtainMessage();

    mymsg->mHandler = &myhandler;
    myhandler.SendMessage(*mymsg);

    std::this_thread::sleep_for(timespan);
    Message* mymsg2= myhandler.obtainMessage();
    myhandler.SendMessage(*mymsg2);

    thread->Wait();

    delete  thread;

    return 0;
}