#!/bin/bash

set -xue

curl https://ahmia.fi/blacklist/banned/ | egrep -o '[0-9a-f]{32}' > /etc/blocklist-ahmia.txt
cat /etc/blocklist-*.txt > /etc/blocklist.txt

service nginx reload
