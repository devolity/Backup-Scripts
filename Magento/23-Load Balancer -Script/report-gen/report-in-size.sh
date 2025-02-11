#!/bin/bash

##################
# create report of all backup sizes and make it email.
##########

echo "List of all Current backups files with size on  `date`." > /home/report-gen/db.txt
printf "\n" >> /home/report-gen/db.txt

echo "Percentage of left space in server : " >> /home/report-gen/db.txt
df -h | egrep -i 'rootf|md2'| awk '{ print $5,$4,$6; }'| tee >> /home/report-gen/db.txt

printf "\n" >> /home/report-gen/db.txt
printf "==================\n" >> /home/report-gen/db.txt
printf "\n" >> /home/report-gen/db.txt

sz=$(find /home/Mysql-DB-Backup/* -size 0)

ez=$(echo 0)

if [[ $sz -eq "0" ]];then

echo "Remark : Currently no any issue in Backup file size."

else 

echo "Remark : $sz == Is have 0KB in file Size."

fi >> /home/report-gen/db.txt

printf "\n" >> /home/report-gen/db.txt
printf "==================\n" >> /home/report-gen/db.txt
printf "\n" >> /home/report-gen/db.txt

du -sh --time /home/Mysql-DB-Backup/* | sort -n -k 2.9 >> /home/report-gen/db.txt
