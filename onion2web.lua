local socks5 = require 'socks5'

local onion2web = {}

local hidden_base = "(" .. string.rep("%w", 16) .. ")"
local hidden_onion = hidden_base .. '%.onion'

onion2web.handle_onion2web = function(onion_replacement,
        torhost, torport)
    if not torhost then
        torhost = '127.0.0.1'
    end
    if not torport then
        torport = 9050
    end
    local repl = hidden_base .. onion_replacement
    local host = ngx.req.get_headers()['Host']
    if not host:match('^' .. repl .. '$') then
        ngx.say('Bad domain: ' .. host)
        return
    end
    socks5.handle_request(torhost, torport,
    function(clheader)
        return clheader
        :gsub("HTTP/1.1(%c+)", "HTTP/1.0%1")
        :gsub(repl, "%1.onion")
        :gsub("Connection: keep%-alive", "Connection: close")
        :gsub("Accept%-Encoding: [%w%p ]+%c+", "")
    end,
    function(soheader)
        return soheader
        :gsub(hidden_onion, "%1" .. onion_replacement)
    end)
end

return onion2web

