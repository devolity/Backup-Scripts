#!/bin/bash

### Database credentials
 user="zipker_stage"
 password="6zysDxfA5ge"
 host="46.105.111.139"
 db_name="fablaze"

### Other options
 backup_path="/home/Mysql-DB-Backup"
 date=$(date +"%d-%b-%Y-%H-%M-%S")

### Set default file permissions
 umask 177

### Dump database into SQL file
 mysqldump --single-transaction --routines --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date.sql 2>> /home/Logs/mysql-backup.log

### Dump another database into SQL file
 mysqldump --single-transaction --routines --user=$user --password=$password --host=$host zipker_prod > $backup_path/yeboindia-$date.sql 2>> /home/Logs/mysql-backup.log

### Delete files older than 3 days
# find $backup_path/* -mtime +4 -exec rm -rf {} \;

