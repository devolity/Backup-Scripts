#!/bin/bash

echo "List of all Current backups files with size on  `date`." > /root/abhi/db.txt
printf "\n" >> /root/abhi/db.txt

echo "Percentage of left space in server : " >> /root/abhi/db.txt
df -h | egrep -i 'rootf|md2'| awk '{ print $5,$4,$6; }'| tee >> /root/abhi/db.txt

printf "\n" >> /root/abhi/db.txt
printf "==================\n" >> /root/abhi/db.txt
printf "\n" >> /root/abhi/db.txt

sz=$(find /home/mysqlbackup/* -size 0)

ez=$(echo 0)

if [[ $sz -eq "0" ]];then

echo "Remark : Currently no any issue in Backup file size."

else 

echo "Remark : $sz == Is have 0KB in file Size."

fi >> /root/abhi/db.txt

printf "\n" >> /root/abhi/db.txt
printf "==================\n" >> /root/abhi/db.txt
printf "\n" >> /root/abhi/db.txt

#du -sh --time /home/mysqlbackup/* | sort -h -r >> /root/db.txt
du -sh --time /home/mysqlbackup/* | sort -n -k 2.9 >> /root/abhi/db.txt
