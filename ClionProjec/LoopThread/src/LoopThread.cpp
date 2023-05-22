//
// Created by wanghuan on 2016/12/23.
//

#include <thread>         // std::thread
#include <iostream>

#include "../include/LoopThread.h"
#include "../include/Looper.h"

using namespace std;

LoopThread::LoopThread():
        mThread(nullptr)
{
}

bool LoopThread::Start() {
    if(nullptr == mThread){
        mThread = new std::thread(__threadLoop, this);

        return true;
    }

    return true;
}

int LoopThread::__threadLoop(void* data) {
    LoopThread* self = (LoopThread*)data;

    self->mLooper.Loop();


    return 0;
}

int LoopThread::Exit() {
    mLooper.StopLoop();

    return 0;

}

void LoopThread::Wait() {
    if(nullptr != mThread){
        mThread->join();
    }

}
LoopThread::~LoopThread(){
    mLooper.StopLoop();

    if(nullptr != mThread)
        delete mThread;

    mThread = nullptr;
}