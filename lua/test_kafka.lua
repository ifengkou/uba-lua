-- 引入json 解析类库
local cjson = require("cjson")
-- 引入配置
local ubabase = require("uba_base")

ngx.req.read_body()
local body = ngx.req.get_body_data()

-- 反序列化body
local messages = cjson.decode(body)

--数据清洗和数据校验
local r = 0
for i=1,#messages do
    r = ubabase.send_message(messages[i])
    if r < 0 then
        break
    end
end
if r == 0 then
    ngx.say("ok")
else
    ngx.say("err")
end
