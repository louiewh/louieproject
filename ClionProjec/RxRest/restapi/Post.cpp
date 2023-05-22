//
// Created by louie on 2019/12/19.
//

#include <iostream>
#include <string>

#include "Post.h"
#include <boost/algorithm/string/replace.hpp>

void to_json(json& j, const Post& p) {
    j = json{{"userId", p.userId}, {"id", p.id}, {"title", p.title}, {"body", p.body}};
}
void from_json(const json& j, Post& p) {
    p.userId = j.at("userId").get<int>();
    p.id = j.at("id").get<int>();
    p.title = j.at("title").get<std::string>();
    p.body = boost::algorithm::replace_all_copy(j.at("body").get<std::string>(), "\n", "\\n");
}

std::ostream& operator<<(std::ostream& out, const Post& p) {
    out << "Post {userId = " << p.userId
         << ", id = " << p.id
         << ", title = \"" << p.title
         << "\", body = \"" << p.body
         << "\"}";

    return out;
}