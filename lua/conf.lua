module = {}
module.kafka_broker_list = {
    { host = "10.128.2.86", port = 9092}
}
module.kafka_producer_conf = {
    producer_type = "async",
    socket_timeout=10000,
    keepalive_size=100,
    keepalive_timeout=10000,
    flush_time = 5000,
    batch_num = 100,
    max_buffering= 500000,
    error_handle=batch_error_handle
}
module.model_keys = {appid="appid",uid="xwho",time="xwhen",event="xwhat",properties="properties"}
module.topic_prefix="uba-"
module.error={key_check_failed=1,topic_not_existed=2,send_failed=3}
return module