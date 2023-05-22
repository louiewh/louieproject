//
// Created by wanghuan on 2016/12/23.
//

#ifndef LOOPTHREAD_LOOPER_H
#define LOOPTHREAD_LOOPER_H

#include "MessageQueue.h"

class  Looper{
public:
    Looper();

    void Prepare();

    void Loop();

    void StopLoop(){
        mRunning = false;
    }

    bool InQueue(Message& msg){
        mQueue.Put(msg);
        return  true;
    };

private:
    void* mHandler;
    bool mRunning;
    MessageQueue mQueue;

};
#endif //LOOPTHREAD_LOOPER_H
