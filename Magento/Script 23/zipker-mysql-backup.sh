#!/bin/bash

### Database credentials
 user="zipker_backup"
 password="43KQP5nGhtBSu6eR"
 host="46.105.111.168"
 db_name="zipker_prod"

### Other options
 backup_path="/home/Mysql-DB-Backup"
 date=$(date +"%d-%b-%Y-%H-%M-%S")

### Set default file permissions
 umask 177

### Dump Zipker database into SQL file
 mysqldump --single-transaction --routines --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date.sql 2>> /home/Logs/mysql-backup.log

### Dump Zipker Blog database into SQL file
 mysqldump --single-transaction --routines --user=$user --password=$password --host=$host zipker_blog > $backup_path/zipker_blog-$date.sql 2>> /home/Logs/mysql-backup.log

### Delete files older than 3 days
# find $backup_path/* -mtime +4 -exec rm -rf {} \;

sh /home/report-gen/send_email.sh

