//
// Created by wanghuan on 2016/12/23.
//

#include <time.h>
#include <stdio.h>
#include <thread>
#include <iostream>
#include <iomanip>

#include "../include/Looper.h"
#include "../include/Handler.h"


const std::string getCurrentSystemTime()
{
    auto tt = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
    struct tm* ptm = localtime(&tt);
    char date[60] = {0};

    sprintf(date, "%d-%02d-%02d %02d:%02d:%02d",
            (int)ptm->tm_year + 1900,(int)ptm->tm_mon + 1,(int)ptm->tm_mday,
            (int)ptm->tm_hour,(int)ptm->tm_min,(int)ptm->tm_sec);

    return std::string(date);
}

Looper::Looper() :mRunning(true), mQueue()
{
}

void Looper::Loop() {

    while(mRunning) {

        Message msg = mQueue.Next();
        msg.mHandler->HandleMessage(msg);
        std::cout << "Hello, mRuning! " << getCurrentSystemTime() << std::endl;
    }
}