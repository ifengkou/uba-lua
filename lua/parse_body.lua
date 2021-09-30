local base64 = require 'nginx.conf.lua.base64'
if not base64 then
    ngx.say("Failed load base64!")
    return
end
local headers = ngx.req.get_headers()
local sdk_lib = headers["$lib"]
local sdk_version = headers["$lib_version"]
local encrypt = headers["Encrypt"]
local is_gzip = headers["$gzip"]
local encoding = headers["Content-Encoding"]

local zlib = require "zlib"

ngx.req.read_body()
local body = ngx.req.get_body_data()

if not body then
    ngx.say("No request body!")
    return
end

if body then
    local gzipstr = base64.dec(body)
    local stream = zlib.inflate()
    --ngx.say(stream(gzipstr))
    local ret = stream(gzipstr)
    --ngx.log(ngx.ERR,"response=",ret)
    ngx.say(ret)
end