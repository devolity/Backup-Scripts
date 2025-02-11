#!/bin/sh
SERVICE='rsync'

if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    exit 1

else

rsync -avz -e "sshpass -f /home/.pass ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@51.254.198.38:/var/www/html/media/ /var/www/html/media

fi
