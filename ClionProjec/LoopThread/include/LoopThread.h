//
// Created by wanghuan on 2016/12/23.
//

#ifndef LOOPTHREAD_THREAD_H
#define LOOPTHREAD_THREAD_H

using namespace std;
#include <thread>               // std::thread
#include "Looper.h"


class LoopThread {
public:
    Looper mLooper;

    LoopThread();

    ~LoopThread();

    bool Start();

    void Wait();

    int Exit();

    Looper* GetLooper(){ return &mLooper; }

private:
    static int __threadLoop(void* data);

    std::thread* mThread;
};


#endif //LOOPTHREAD_THREAD_H
