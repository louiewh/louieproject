//
// Created by wanghuan on 2016/12/23.
//

#ifndef LOOPTHREAD_MESSAGE_H
#define LOOPTHREAD_MESSAGE_H


class Handler;

class Message{
public:
    int what;

    Message* next;
    Handler* mHandler;

    Message():next(nullptr){};
    Message(Handler* handler):mHandler(handler), next(nullptr) {};

    /* maybe use default is OK
    Message(const Message& other){

    };

    Message& operator =(const Message& other){

    };
    */
};

#endif //LOOPTHREAD_MESSAGE_H

