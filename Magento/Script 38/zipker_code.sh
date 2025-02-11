#!/bin/bash

rsync -avz -e "sshpass -f /root/.pass ssh -p 2024 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude media --exclude var --exclude app/etc root@46.105.111.168:/var/www/html/ /var/www/html
