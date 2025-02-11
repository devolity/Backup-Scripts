#!/bin/bash
backuplocation="/araw/backup-DB/DB-$(date +'%d-%b-%Y')"

mkdir -p $backuplocation

/usr/sbin/plesk db -e "show databases" | grep -v -E "^Database|information_schema|performance_schema|phpmyadmin" > /root/araw/dblist.txt

cat /root/araw/dblist.txt | while read i; do /usr/sbin/plesk db dump "$i" > $backuplocation/"$i".sql; done

### Remove Older Data
find /araw/backup-DB/* -mtime +2 -exec rm -rf {} \;
