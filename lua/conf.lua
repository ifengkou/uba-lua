module = {}
module.kafka_broker_list = {
    { host = "10.128.2.86", port = 9092}
}
local function batch_error_handle(topic, partition_id, message_queue, index, err, retryable)
    for key, value in pairs(message_queue) do
        -- TODO send error log
        ngx.log(ngx.ERR,value)
    end
end

module.kafka_producer_conf = {
    producer_type = "async",
    socket_timeout=10000,
    keepalive_size=200,
    keepalive_timeout=10000, --ms
    refresh_interval=30000, --ms  https://github.com/doujiang24/lua-resty-kafka/issues/70
    flush_time = 5000,
    batch_num = 100,
    max_buffering= 50000,
    error_handle=batch_error_handle
}
module.model_keys = {appid="appid",uid="xwho",time="xwhen",event="xwhat",properties="properties"}
module.topic_prefix="uba-"
module.error={key_check_failed=1,topic_not_existed=2,send_failed=3}
return module