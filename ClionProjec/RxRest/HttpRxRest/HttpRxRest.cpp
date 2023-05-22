//
// Created by louie on 2019/12/19.
//

#include <cpprest/details/basic_types.h>
#include "HttpRxRest.h"
#include "../restapi/RestApi.h"
#include "../restapi/Post.h"
#include "../restapi/GithubUser.h"

using namespace std;

extern int post_main();

int HttpRxRest::main()
{
    RestApi<Post> api(U("https://jsonplaceholder.typicode.com/"));
    api.getString(U("posts/1")).subscribe([](const string_t& v){cout << v << endl;});
    api.getObject(U("posts/1")).subscribe([](const Post& v){cout << v << endl;});
    api.getArray(U("posts")).take(2).subscribe([](const Post& v){cout << v << endl;});


    Post o;
    o.id = 0;
    o.userId = 101;
    o.title = U("test title");
    o.body = U("test body");
    api.createObject(U("posts"), o).subscribe([](string_t v){cout << v << endl;});
    api.updateObject(U("posts/1"), o).subscribe([](string_t v){cout << v << endl;});
    api.deleteObject(U("posts/1")).subscribe([](string_t v){cout << v << endl;});


    RestApi<GithubUser> apiGithub(U("https://api.github.com/"));
    apiGithub.getObject(U("/users/octocat")).subscribe([](const GithubUser& v){cout << v << endl;});
    post_main();

    return 0;
}