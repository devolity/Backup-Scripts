#!/bin/bash

read -p "Server Ip Address: " MyHOST

read -p "DATA BASE User Name: " MyUSER

read -p "DATA BASE User Password: " MyPASS

#MyUSER="clouddb"  	   # USERNAME
#MyPASS="clouddb1234"      # PASSWORD 
#MyHOST="localhost"        # Hostname

# Linux bin paths, change this if it can not be autodetected via which command
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"
 
# Backup Dest directory, change this if you have someother location
DEST="/home"
 
# Get hostname
HOST=$MyHOST
 
# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%b-%Y")"

# Main directory where backup will be stored
MBD="$DEST/mysql-$MyHOST-$NOW"
 
# File to store current backup file
FILE=""
# Store list of databases 
DBS=""
 
# DO NOT BACKUP these databases
IGGY="test"
 
[ ! -d $MBD ] && mkdir -p $MBD || :
 
# Only root can access it!
$CHOWN 0.0 -R $DEST
$CHMOD 0600 $DEST
 
# Get all database list first
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"
 
for db in $DBS
do
    skipdb=-1
    if [ "$IGGY" != "" ];
    then
 for i in $IGGY
 do
     [ "$db" == "$i" ] && skipdb=1 || :
 done
    fi
    
    if [ "$skipdb" == "-1" ] ; then
 FILE="$MBD/$db.$HOST.$NOW.gz"
 # do all inone job in pipe,
 # connect to mysql using mysqldump for select mysql database
 # and pipe it out to gz file in backup dir :)
        $MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
    fi
done
##################
