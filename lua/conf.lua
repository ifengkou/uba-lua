module = {}
module.kafka_broker_list = {
    { host = "10.128.2.86", port = 9092}
}
module.model_keys = {appid="appid",uid="xwho",time="xwhen",event="xwhat",properties="properties"}
module.topic_prefix="uba-"
module.error={key_check_failed=1,topic_not_existed=2,send_failed=3}
return module