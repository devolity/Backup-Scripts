#!/bin/bash
cat /var/www/html/zipker_cron.txt >> /etc/crontab
cat /dev/null > /var/www/html/zipker_cron.txt
