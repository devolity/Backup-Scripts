#!/bin/sh
SERVICE='rsync'

if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    exit 1
else

rsync -avz -e "sshpass -f /root/.pass ssh -p 2024 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@46.105.111.168:/var/www/html/media/ /var/www/html/media

fi
