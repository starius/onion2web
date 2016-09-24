#!/bin/bash

set -xue

apt-get --yes install nginx-extras
apt-get --yes install luarocks
luarocks install onion2web

cp example.nginx /etc/nginx/nginx.conf

wget -r -k -p -np -e robots=off -E https://starius.github.io/onion2web/
mkdir -p /var/www
rm -rf /var/www/onion2web
cp -r starius.github.io/onion2web /var/www/onion2web

wget https://raw.githubusercontent.com/starius/config/master/.bin/install-tor2web
chmod +x install-tor2web
./install-tor2web

service nginx restart
