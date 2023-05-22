//
// Created by louie on 2019/12/19.
//
#include "GithubUser.h"

void to_json(json& j, const GithubUser& p) {
    j = json{
        {"login", p.login},
        {"id", p.id},
        {"node_id", p.node_id},
        {"avatar_url", p.avatar_url},
        {"gravatar_id", p.gravatar_id},
        {"url", p.url},
        {"html_url", p.html_url},
        {"followers_url", p.followers_url},
        {"following_url", p.following_url},
        {"gists_url", p.gists_url},
        {"starred_url", p.starred_url},
        {"subscriptions_url", p.subscriptions_url},
        {"organizations_url", p.organizations_url},
        {"events_url", p.events_url},
        {"received_events_url", p.received_events_url},
        {"type", p.type},
        {"site_admin", p.site_admin},
        {"name", p.name},
        {"company", p.company},
        {"blog", p.blog},
//        {"email", p.email},
        {"location", p.location},
        {"email", p.email},
        {"hireable", p.hireable},
        {"bio", p.bio},
        {"public_repos", p.public_repos},
        {"public_gists", p.public_gists},
        {"followers", p.followers},
        {"following", p.following},
        {"created_at", p.created_at},
        {"updated_at", p.updated_at}
    };
}

void from_json(const json& j, GithubUser& p) {
    p.login = j.at("login").get<std::string>();
    p.id = j.at("id").get<int>();
    p.node_id = j.at("node_id").get<std::string>();
    p.avatar_url = j.at("avatar_url").get<std::string>();
    p.gravatar_id = j.at("gravatar_id").get<std::string>();
    p.url = j.at("url").get<std::string>();
    p.html_url = j.at("html_url").get<std::string>();
    p.followers_url = j.at("followers_url").get<std::string>();
    p.following_url = j.at("following_url").get<std::string>();
    p.gists_url = j.at("gists_url").get<std::string>();
    p.subscriptions_url = j.at("subscriptions_url").get<std::string>();
    p.organizations_url = j.at("organizations_url").get<std::string>();
    p.events_url = j.at("events_url").get<std::string>();
    p.received_events_url = j.at("received_events_url").get<std::string>();
    p.type = j.at("type").get<std::string>();
    p.site_admin = j.at("site_admin").get<bool>();
    p.name = j.at("name").get<std::string>();
    p.company = j.at("company").get<std::string>();
    p.blog = j.at("blog").get<std::string>();
//    p.email = j.at("email").get<std::string>();
//    p.location = j.at("location").get<std::string>();
//    p.hireable = j.at("hireable").get<bool>();
//    p.bio = j.at("bio").get<std::string>();
    p.public_repos = j.at("public_repos").get<int>();
    p.public_gists = j.at("public_gists").get<int>();
    p.followers = j.at("followers").get<int>();
    p.created_at = j.at("created_at").get<std::string>();
    p.updated_at = j.at("updated_at").get<std::string>();
}

std::ostream& operator<<(std::ostream& out, const GithubUser& p) {
    out << "GithubUser {login = " << p.login
        << ", id = " << p.id
        << ", node_id = \"" << p.node_id
        << "\", avatar_url = \"" << p.avatar_url
        << "\"}";

    return out;
}