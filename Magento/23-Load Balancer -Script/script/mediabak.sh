#!/bin/bash
# Other options
  backup_path="/home/Web_Media_Backup"
  date=$(date +"%d-%b-%Y")
# Set default file permissions

# Backup of Zipker.com Media file
rsync -avz -e "ssh -i /home/script/ns3327368-111.168.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@46.105.111.168:/var/www/html/media/ $backup_path/Zipker-Media-data-2018/

# Backup of Yeboindia.com Media file
rsync -avz -e "sshpass -f /home/script/.124 ssh -p 22 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@164.132.163.124:/home/zipker-new/media/ $backup_path/Yeboindia-Media-2019/

# Backup of Fablaze.com Media file
rsync -avz -e "ssh -i /home/script/ns3068517-111.139.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@46.105.111.139:/var/www/fablaze/media/ $backup_path/Fablaze-Media-2019/
