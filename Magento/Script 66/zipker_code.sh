#!/bin/bash

rsync -avz -e "sshpass -f /home/araw/.38 ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude var --exclude app/etc --exclude media  root@51.254.198.38:/var/www/html/ /var/www/html

#rsync -avz -e "sshpass -f /home/araw/.38 ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@51.254.198.38:/var/www/html/ /var/www/html

#rsync -avz -e "sshpass -f /home/araw/.38 ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"  --exclude app/etc --exclude media --exclude var root@46.105.111.139:/var/www/html/ /var/www/html
