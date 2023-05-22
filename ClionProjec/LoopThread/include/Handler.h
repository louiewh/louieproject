//
// Created by wanghuan on 2016/12/23.
//

#ifndef LOOPTHREAD_HANDER_H
#define LOOPTHREAD_HANDER_H


class Looper;
class Message;
class MessageQueue;

class Handler{
public:
    Handler(){};

    Handler(Looper* looper) :mLooper(looper){};

    virtual void HandleMessage(Message msg) = 0;
    virtual Message* obtainMessage(){
        return new Message(this);
    };


    bool SendMessage(Message& msg) {

        mLooper->InQueue(msg);
        return true;
    }

private:
    Looper* mLooper;
};

#endif //LOOPTHREAD_HANDER_H

