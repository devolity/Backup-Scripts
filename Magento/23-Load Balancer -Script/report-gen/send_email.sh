#!/bin/bash

##################
## Send Email with report of Backup sizes
##########

ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

sh /home/report-gen/report-in-size.sh

#mail -s "zipker_prod DB backup complete on IP: $ip" arpan.jain@zipker.com avinash.puri@zipker.com server@zipker.com < /home/abhiraw/db.txt

mail -s "zipker_prod DB backup complete on IP: $ip" server@zipker.com < /home/report-gen/db.txt

echo $ip
