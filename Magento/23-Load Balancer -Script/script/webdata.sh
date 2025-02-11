#!/bin/bash
# Other options
 backup_path="/home/Web_Data_Backup"
 date=$(date +"%b-%d-%Y")
### Set default file permissions

### Backup of Zipker.com Web file
rsync -avz -e "ssh -i /home/script/ns3327368-111.168.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude media root@46.105.111.168:/var/www/html/ $backup_path/Zipker-Data-$date/

### Backup of zipker Blog Web file
rsync -avz -e "ssh -i /home/script/vps341219-0.37.14.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@193.70.37.14:/var/www/blogzipker/ $backup_path/Blog-Data-$date/

### Backup of Yeboindia.com Web file
rsync -avz -e "sshpass -f /home/script/.124 ssh -p 22 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude media root@164.132.163.124:/home/zipker-new/ $backup_path/Yeboindia-$date/

### Backup of Fablaze.com Web file
rsync -avz -e "ssh -i /home/script/ns3068517-111.139.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude media root@46.105.111.139:/var/www/fablaze/ $backup_path/Fablaze-$date/
