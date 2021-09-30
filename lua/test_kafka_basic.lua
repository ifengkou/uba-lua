-- https://github.com/doujiang24/lua-resty-kafka
-- 建议放到init 阶段
local cjson = require "cjson"
local client = require "resty.kafka.client"
local producer = require "resty.kafka.producer"

--构造kafka 集群节点 broker
local broker_list = {
    { host = "127.0.0.1", port = 9092}
}

local key = "key"

-- 暂时不支持 sasl https://github.com/doujiang24/lua-resty-kafka/pull/102
local ssl_config ={
    ["ssl"] = true,
    security_protocol="SASL_PLAINTEXT",
    sasl_mechanism="PLAIN",
    sasl_plain_username="xxx",
    sasl_plain_password="xxxxx"
}
-- usually we do not use this library directly
local cli = client:new(broker_list)
local brokers, partitions = cli:fetch_metadata("uba-abc001")
if not brokers then
    ngx.say("fetch_metadata failed, err:", partitions)
end
ngx.say("brokers: ", cjson.encode(brokers), "; partitions: ", cjson.encode(partitions))

local message = "{\"appid\": \"abc001\", \"xwho\": 10003978, \"xwhat\": \"$profile_set\", \"xwhen\": 946656000000, \"xcontent\": {\"$idfv\": \"OTeUKyOL\", \"$idfa\": \"shMJZBjkQaL\", \"$imei\": \"sNnxPf\", \"$mac\": \"f2:19:93:fd:1d:5e\", \"$platform\": \"iOS\", \"$lib\": \"iOS\", \"$lib_version\": \"3.0.2\", \"$province\": \"\u798f\u5efa\u7701\", \"school_id\": 10002, \"school_name\": \"\u6e58\u4e00\", \"school_at\": \"\u5f00\u798f\u533a\", \"school_is_public\": false, \"username\": \"oxiong\", \"name\": \"\u5d14\u79c0\u5170\", \"email\": \"minyan@83.cn\", \"sex\": \"\u7537\", \"is_vip\": false, \"age\": 74, \"gre\": [33.73, 30.46, 40.89, 85.47, 96.9, 40.72], \"job\": \"\u5ba2\u6237\u4ee3\u8868\", \"risk_level\": 2, \"asset_level\": \"\u9ad8\u8d44\u4ea7\", \"education\": \"\u5927\u4e13\u4ee5\u4e0b\", \"scores\": 49063, \"total_amount\": 48578.13, \"$import_flag\": 1, \"$first_visit_time\": \"2000-01-01 00:00:00\", \"$signup_time\": \"2000-01-01 00:00:00\", \"$last_visit_time\": \"2000-01-01 00:00:00\"}}"

-- sync producer_type
local p = producer:new(broker_list)

local offset, err = p:send("test", key, message)
if not offset then
    ngx.say("send err:", err)
    return
end
ngx.say("send success, offset: ", tonumber(offset))

-- this is async producer_type and bp will be reused in the whole nginx worker
local bp = producer:new(broker_list, { producer_type = "async" })

local ok, err = bp:send("test", key, message)
if not ok then
    ngx.say("send err:", err)
    return
end

ngx.say("send success, ok:", ok)