#!/bin/bash

# Database credentials
 user="zipker_backup"
 password="LL9KcredUhk2AwHw"
 host="51.254.198.42"
 db_name="zipker_prod"

# Other options
 backup_path="/home/mysqlbackup"
 date=$(date +"%d-%b-%Y-%H-%M-%S")

# Set default file permissions
 umask 177

# Dump database into SQL file
 mysqldump --single-transaction --routines --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date.sql 2>> /var/log/zipker/backup7pm.log

# Delete files older than 3 days
 find $backup_path/* -mtime +4 -exec rm -rf {} \;

sh /root/abhi/mail.sh
