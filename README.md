onion2web
=========

Access .onion sites without Tor Browser

Homepage: http://onion.gq/

Dependency:
[lua-resty-socks5](https://github.com/starius/lua-resty-socks5)

This module contains the following functions:

 * `onion2web.handle_onion2web(onion_replacement,
    torhost='127.0.0.1', torport=9050)` -
    accept request to onion2web site.

How to use this module to forward requests from
`xxx.onion.gq` to `xxx.onion`:

```nginx
server {
    listen 80;
    server_name *.onion.gq;
    location / {
        default_type text/html;
        content_by_lua '
            require("onion2web").handle_onion2web(".onion.gq");
        ';
    }
}
```
