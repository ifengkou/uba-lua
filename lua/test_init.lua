--引入 kafka 生产者 类库
local producer = require("resty.kafka.producer")
--引入json 解析类库
local cjson = require("cjson")