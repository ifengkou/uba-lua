local config = require("conf")
local client = require "resty.kafka.client"
local producer = require("resty.kafka.producer")
local cjson = require("cjson")

module={}

-- bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3 --topic uba-abc001

local Topic_Partition = ngx.shared.shared_data
local async_producer = producer:new(config.kafka_broker_list, config.kafka_producer_conf)

local function get_topic_from_message(message)
    return config.topic_prefix..message[config.model_keys.appid]
end
local function get_uid_from_message(message)
    return message[config.model_keys.uid]
end

local function get_topic_partitions(topic)
    if Topic_Partition:get(topic) == nil or Topic_Partition:get(topic)==-1 then
        ngx.log(ngx.DEBUG , topic.."`s partition is null, fetch_meta")
        local cli = client:new(config.kafka_broker_list)
        local brokers, partitions = cli:fetch_metadata(topic)
        if not brokers then
            --ngx.say("fetch_metadata failed, err:", partitions)
            ngx.log(ngx.DEBUG, "fetch_topic_metadata failed, err:", "not brokers")
            return -1
        end
        local _pnumb = 0
        for k,v in ipairs(partitions) do
            _pnumb = _pnumb + 1
        end
        Topic_Partition:set(topic,_pnumb)
        return _pnumb
    else
        ngx.log(ngx.DEBUG,"fetch partition from memory,topic="..topic)
        return Topic_Partition:get(topic)
    end
end

local function check_event_model(message)
    -- 校验必要字段
    for key, value in pairs(config.model_keys) do
        if message[value] == nil then
            ngx.log(ngx.ERR, "check_event_model failed: no ["..value.."] in message")
            return config.error.key_check_failed
        end
        -- 校验when
    end
    -- 校验appid
    local tpc = get_topic_from_message(message)
    local result = get_topic_partitions(tpc)
    if result <= -1 then
        ngx.log(ngx.ERR, "check_event_model failed: appid is not created")
        return config.error.topic_not_existed
    end
    return 0
end

local function batch_error_handle(topic, partition_id, message_queue, index, err, retryable)
    for key, value in pairs(message_queue) do
        -- TODO send error log
        ngx.log(ngx.ERR,value)
    end
end



function module.send_message(message)
    local check_result = check_event_model(message)
    if check_result ~= 0 then
        -- todo send to error topic
        message.error = check_result
        --ngx.log(ngx.ERR, "msg check failed:", msg_str)
        return check_result
    end
    -- check_result == 0 
    local msg_str = cjson.encode(message)
    local topic = get_topic_from_message(message)
    local uid = get_uid_from_message(message)
    local partition = get_topic_partitions(topic)
    local key = tonumber(uid) % tonumber(partition)

    ngx.log(ngx.DEBUG, "send to kafka: "..topic..",pt="..partition)
    local ok, err = async_producer:send(topic, tostring(key), msg_str)
    --上报异常处理
    if not ok then
        message.error = config.error.send_failed
        ngx.log(ngx.ERR, "kafka send err:", err)
        -- todo write nginx error queue
        return -1
    end
    return 0
end
return module