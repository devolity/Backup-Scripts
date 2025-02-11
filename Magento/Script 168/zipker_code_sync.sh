#!/bin/bash

rsync -avz -e "sshpass -f /home/.pass ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude media --exclude var --exclude app/etc root@51.254.198.38:/var/www/html/ /var/www/html
