local zlib = require "zlib"

function ungzip(compress_data)
    -- local encoding = ngx.req.get_headers()["Content-Encoding"]

    -- if encoding == "gzip" then
    --     local body = ngx.req.get_body_data()

    --     if body then
    --         local stream = zlib.inflate()
    --         --ngx.req.set_body_data(stream(body))
    --         ngx.say(stream(body))
    --     end
    -- end
    local stream = zlib.inflate()
    return stream(body)
end