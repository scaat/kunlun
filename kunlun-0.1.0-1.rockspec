package = "kunlun"
version = "0.1.0-1"
source = {
   url = "git+https://github.com/scaat/kunlun.git"
}
description = {
   summary = " Kunlun is a dynamic, high-performance API Gateway.",
   detailed = [[

Kunlun is a dynamic, high-performance API Gateway. Provides rich traffic management features such as load balancing, dynamic upstream, canary release, circuit breaking, authentication, observability, and more.]],
   homepage = "https://github.com/scaat/kunlun",
   license = "*** please specify a license ***"
}

dependencies = {
    "lua-resty-template=1.9-1"
}

build = {
   type = "builtin",
   modules = {
        ["templates.nginx"] = "templates/nginx.lua"
   }
}
