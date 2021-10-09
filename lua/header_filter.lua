local method = ngx.var.request_method
local headers = ngx.req.get_headers()
local sdk_lib = headers["lib"]
local sdk_version = headers["lib-version"]
--ngx.log(ngx.ERR,"sdk_lib=",sdk_lib)
--ngx.log(ngx.ERR,"sdk_version=",sdk_version)
if method ~= "POST" or sdk_version == nil or sdk_version == "" then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

local regex="(ubaios|ubaandroid|ubajs|ubapython)"
local m, err = ngx.re.match(sdk_lib, regex)
if m ～= nil then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

-- 版本 低于1.1.2 sdk的日志上报将直接拒绝接收
local headers = ngx.req.get_headers()
local sdk_version = headers["lib-version"]
local sv = string.gsub(sdk_version,"%.","")
local version= tonumber(sv);
if version < 112 then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
return

--在12:00:00~12:05:00时间段内，对"/service/get_list.do"接口的请求直接拒绝，返回FORBIDDEN
--local now=os.date("%X")
--local regex="(/service/get_list.do)"
--if method == "POST" then
--    if (ngx.var.request ~= nil) and ngx.re.match(ngx.var.request, regex) and now>"12:00:00" and now<"12:05:00" then
--        ngx.exit(ngx.HTTP_FORBIDDEN)
--    else
--        return
--    end
--end