#!/usr/bin/env resty
local template = require("resty.template")
local nginx_tmp = require("templates/nginx")
local _M = {}

local script_path = debug.getinfo(1).source:sub(2)

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function execute_cmd(cmd)
    local t = io.popen(cmd)
    local data = t:read("*all")
    t:close()
    return data
end

local kunlun_home

if script_path:sub(1, 4) == '/usr' or script_path:sub(1, 4) == '/bin' then
    kunlun_home = "/usr/local/kunlun"
    package.cpath = "/usr/local/kunlun/deps/lib64/lua/5.1/?.so;"
            .. "/usr/local/kunlun/deps/lib/lua/5.1/?.so;"
            .. package.cpath

    package.path = "/usr/local/kunlun/deps/share/lua/5.1/kunlun/lua/?.lua;"
            .. "/usr/local/kunlun/deps/share/lua/5.1/?.lua;"
            .. "/usr/share/lua/5.1/kunlun/lua/?.lua;"
            .. "/usr/local/share/lua/5.1/kunlun/lua/?.lua;"
            .. package.path
else
    kunlun_home = trim(execute_cmd("pwd"))
    package.cpath = kunlun_home .. "/deps/lib64/lua/5.1/?.so;"
            .. package.cpath

    package.path = kunlun_home .. "/kunlun/?.lua;"
            .. kunlun_home .. "/deps/share/lua/5.1/?.lua;"
            .. package.path
end

--local openresty_bin = trim(execute_cmd("which openresty"))
--if not openresty_bin then
--    error("can not find the openresty.")
--end

local openresty_launch = [[openresty -p]] .. kunlun_home .. [[ -c ]]
        .. kunlun_home .. [[/conf/nginx.conf]]

local function write_file(file_path, data)
    local file, err = io.open(file_path, "w+")
    if not file then
        return false, "failed to open file: " .. file_path .. ", error info:" .. err
    end

    file:write(data)
    file:close()
    return true
end

function _M.help()
    print([[
Usage: kunlun [action] <argument>
help:       show this message, then exit
start:      start the Kunlun server
stop:       stop the Kunlun server
reload:     reload the Kunlun server
    ]])
end

function _M.init()
    local logs = io.open(kunlun_home .. "/logs", "rb")
    if not logs then
        execute_cmd("mkdir -p " .. kunlun_home .. "/logs")
    else
        logs:close()
    end

    --local conf_dir = io.open(kunlun_home .. "/conf", "rb")
    --if not conf_dir then
    --    execute_cmd("mkdir -p " .. kunlun_home .. "/conf")
    --else
    --    conf_dir:close()
    --end

    local conf_render = template.compile(nginx_tmp, "no-cache", true)
    local ngxconf = conf_render()

    local ok, err = write_file(kunlun_home .. "/conf/nginx.conf", ngxconf)
    if not ok then
        error("failed to update nginx.conf: " .. err)
    end
end

function _M.start()
    _M.init()
    local cmd = openresty_launch
    os.execute(cmd)
end

function _M.stop()
    local cmd = openresty_launch .. [[ -s stop]]
    os.execute(cmd)
end

function _M.reload()
    local cmd = openresty_launch .. [[-s reload]]
    os.execute(cmd)
end

local cmd_action = arg[1]
if not cmd_action then
    return _M.help()
end

if not _M[cmd_action] then
    print("invalid argument: ", cmd_action, "\n")
    return
end


_M[cmd_action](arg[2])