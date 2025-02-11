#!/bin/bash
# Other options
 backup_path="/home/Web_Data_Backup"
 date=$(date +"%d-%b-%Y")
# Set default file permissions

# Backup of Zipker Main Server Web file
rsync -avz -e "sshpass -f /home/script/.38 ssh -p 2244 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"  --progress --exclude media --exclude var root@51.254.198.38:/var/www/html/* $backup_path/Zipker-Data-$date

# Backup of zipker Blog Server Web file
rsync -avz -e "sshpass -f /home/script/.14 ssh -p 2024 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress root@193.70.37.14:/var/www/blogzipker/* $backup_path/Blog-Data-$date
