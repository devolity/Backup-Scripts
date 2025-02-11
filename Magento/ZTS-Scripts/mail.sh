#!/bin/bash

ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

sh /root/abhi/backup.sh

mail -s "zipker_prod db backup complete on $ip" arpan.jain@zipker.com avinash.puri@zipker.com server@zipker.com < /root/abhi/db.txt

#mail -s "zipker_prod db backup complete on $ip" server@zipker.com < /root/db.txt
