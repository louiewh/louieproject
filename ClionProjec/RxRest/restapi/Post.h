//
// Created by louie on 2019/12/19.
//

#ifndef RXREST_POST_H
#define RXREST_POST_H

#include <iostream>
#include <nlohmann/json.hpp>
using nlohmann::json;

struct Post {
    int userId;
    int id;
    std::string title;
    std::string body;
};

void to_json(json& j, const Post& p);
void from_json(const json& j, Post& p);
std::ostream& operator<<(std::ostream& out, const Post& p);



#endif //RXREST_POST_H
