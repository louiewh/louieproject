//
// Created by wanghuan on 2016/12/23.
//

#ifndef LOOPTHREAD_MESSAGEQUEUE_H
#define LOOPTHREAD_MESSAGEQUEUE_H

#include <vector>
#include <condition_variable>
#include "Message.h"

class MessageQueue{

public:
    MessageQueue();
    Message Next();

    void Put(Message& message);

private:
    std::vector<Message> mVector;
    Message* mCurrent;

    mutable std::mutex mMutex;
    std::condition_variable mCondition;
};

#endif //
LOOPTHREAD_MESSAGEQUEUE_H