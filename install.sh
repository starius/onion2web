#!/bin/bash

set -xue

apt-get --yes install nginx-extras
apt-get --yes install luarocks
apt-get --yes install curl
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

curl "https://raw.githubusercontent.com/globaleaks/Tor2web/b6ead9ffeaa0d52cc70b4bc9d82a9bbea45b94e0/lists/blocklist_hashed.txt" > /etc/blocklist-tor2web.txt
cp update-blocklist.sh /etc/cron.daily/update-blocklist.sh
chmod +x /etc/cron.daily/update-blocklist.sh
/etc/cron.daily/update-blocklist.sh
