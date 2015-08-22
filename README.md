onion2web
=========

Access .onion sites without Tor Browser

[Homepage](http://onion.gq/).

Dependency:
[lua-resty-socks5](https://github.com/starius/lua-resty-socks5).

[Paper](http://habrahabr.ru/post/243055/) (in Russian).

Installation
------------

```bash
$ sudo luarocks install onion2web
```

Reference
---------

This module contains the following functions:

 * `onion2web.handle_onion2web(onion_replacement,
    torhost='127.0.0.1', torport=9050, confirmation=true)` -
    accept request to onion2web site.
    `onion_replacement` is part of gateway domain name,
    which replaces `.onion` (e.g., `.onion.gq`).
    `torhost` and `torport` are Tor address and SocksPort.
    If `confirmation` is true (the default), then
    the confirmation page is shown instead of contents
    of a hidden service until a user accepts the terms.

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

To blacklist some .onion sites:

```nginx
server {
        listen   80;
        server_name
.badonion12345678.onion.gq
.anotherbadonion1.onion.gq
;
        return 403;
}
```
