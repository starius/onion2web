local socks5 = require 'socks5'

local onion2web = {}

local hidden_base = "(" .. string.rep("%w", 16) .. ")"
local hidden_onion = hidden_base .. '%.onion'

local show_confirmation_form = function()
    local host = ngx.req.get_headers()['Host']
    local onion = host:match(hidden_base) .. '.onion'
    if ngx.req.get_method == 'POST' and
            ngx.var.uri:match('^/confirm') then
        ngx.req.set_header('Set-Cookie',
            'onion2web_confirmed=true;')
        return ngx.redirect("/")
    end
    ngx.say(([[
<b>%s does not host this content</b>;
the service is simply a proxy connecting Internet users
to content hosted inside the <a
href="https://www.torproject.org/docs/hidden-services.html.en">
Tor network.</a>
Please be aware that when you access this site through a
Onion2web proxy you are not anonymous.
To obtain anonymity, you are strongly advised to <a
href="https://www.torproject.org/download/">
download the Tor Browser Bundle</a>
and access this content over Tor.
<br>
By accessing this site you acknowledge
that you have understood:
<ul>
  <li>What Tor Hidden Services are and how they works;</li>
  <li>What Onion2web is and how it works;</li>
  <li>That Onion2web operator running cannot
    block this site in any way;</li>
  <li>The content of the %s website is
    responsibility of it's editor.</li>
</ul>
<br/>
<div>By the way, just to be clear:</div>
<br/><br/>
<center><b>THIS SERVER IS A PROXY AND IT'S NOT
    HOSTING THE TOR HIDDEN SERVICE SITE %s</b></center>
<br/><br/>
<form method="post" action="/confirm">
<input type="submit"
    value="I agree with the terms, let me access the content"/>
</form>
]]):format(host, onion, onion))
end

onion2web.handle_onion2web = function(onion_replacement,
        torhost, torport, confirmation)
    if not torhost then
        torhost = '127.0.0.1'
    end
    if not torport then
        torport = 9050
    end
    if not confirmation then
        confirmation = true
    end
    local repl = hidden_base .. onion_replacement
    local host = ngx.req.get_headers()['Host']
    if not host:match('^' .. repl .. '$') then
        ngx.say('Bad domain: ' .. host)
        return
    end
    local cookies = ngx.req.get_headers()['Cookie']
    if confirmation and
            (not cookies or
            not cookies:match('onion2web_confirmed=true')) then
        show_confirmation_form()
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

