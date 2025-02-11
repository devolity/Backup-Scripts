#!/bin/bash

# Server credentials
# user="root"
# password="4QjGu=@y=w<FhNcK"
# host="193.70.37.14"

# Other options
 date=$(date +"%d-%b-%Y-%H-%M")
 backup_path="/home/appdata"

# Set default file permissions
 mkdir -p /home/appdata/$date

# Dump database into SQL file
 sshpass -p '4QjGu=@y=w<FhNcK' scp -r -P 2024 root@193.70.37.14:/var/www/zipkerapp/* /home/appdata/$date 2>> /var/log/zipker/mobileapp.log

# Delete files older than 3 days
 find $backup_path/* -mtime +4 -exec rm -rf {} \;

sh /root/abhi/appmail.sh
