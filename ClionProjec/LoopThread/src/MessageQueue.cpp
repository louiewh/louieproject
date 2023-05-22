//
// Created by wanghuan on 2016/12/23.
//

#include "../include/MessageQueue.h"
#include <iostream>

MessageQueue::MessageQueue():mMutex(), mCondition(), mCurrent(nullptr), mVector(0)
{

};

Message MessageQueue::Next(){
    Message *message = nullptr;

    {
        std::unique_lock<std::mutex> locker(mMutex);
        if (mCurrent == nullptr) {
            mCondition.wait(locker, [this] { return mCurrent != nullptr; });
        }

        message = mCurrent;
        mCurrent = mCurrent->next;
    }

    Message msg = *message;
    delete message;

    return msg;
}

void MessageQueue::Put(Message& message){

    {
        std::lock_guard<std::mutex> lock (mMutex);

        if(mCurrent == nullptr){
            mCurrent = &message;
            mCurrent->next = nullptr;

        } else {
            Message* msg = mCurrent;
            while(msg->next != nullptr){
                msg = msg->next;
            }

            msg->next = &message;
        }
    }

    mCondition.notify_one();
}