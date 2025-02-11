#!/bin/bash

rsync -avz -e "sshpass -f /home/script/.139 ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"  --exclude app/etc --exclude media --exclude var root@46.105.111.139:/var/www/html/ /var/www/html

