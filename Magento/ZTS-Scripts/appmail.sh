#!/bin/bash

echo "List of all current backups directory with size on `date`." > /root/abhi/app.txt
printf "\n" >> /root/abhi/app.txt

printf "==============================\n" >> /root/abhi/app.txt
printf "\n" >> /root/abhi/app.txt

du -sh  /home/appdata/* | sort -n -k 2.9 >> /root/abhi/app.txt

ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

mail -s "Mobile App data backup complete on $ip" arpan.jain@zipker.com avinash.puri@zipker.com < /root/abhi/app.txt
#mail -s "zipker_APP data backup complete on $ip" server@zipker.com < /root/abhi/app.txt
