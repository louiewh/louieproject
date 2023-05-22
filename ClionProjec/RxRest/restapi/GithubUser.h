//
// Created by louie on 2019/12/19.
//

#ifndef RXREST_GITHUBUSER_H
#define RXREST_GITHUBUSER_H


#include <string>

struct GithubUser {

    std::string login;

    int id;

    std::string node_id;

    std::string avatar_url;

    std::string gravatar_id;

    std::string url;

    std::string html_url;

    std::string followers_url;

    std::string following_url;

    std::string gists_url;

    std::string starred_url;

    std::string subscriptions_url;

    std::string organizations_url;

    std::string events_url;

    std::string received_events_url;

    std::string type;

    bool site_admin;

    std::string name;

    std::string company;

    std::string blog;

    std::string location;

    std::string email;

    bool hireable;

    std::string bio;

    int public_repos;

    int public_gists;

    int followers;

    int following;

    std::string created_at;

    std::string updated_at;
};

#include <iostream>
#include <nlohmann/json.hpp>
using nlohmann::json;

void to_json(json& j, const GithubUser& p);
void from_json(const json& j, GithubUser& p);
std::ostream& operator<<(std::ostream& out, const GithubUser& p);

#endif //RXREST_GITHUBUSER_H
