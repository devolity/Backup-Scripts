#!/bin/bash

#####
find /var/log/ -name "*.*-*" -exec rm -f {} \;
find /var/log/ -name "*_*-*" -exec rm -f {} \;
find /var/log/ -name "*-*" -exec rm -f {} \;
find /var/log/ -name "*.*.*" -exec rm -f {} \;
find /var/log -type f -exec truncate -s 0 {} \;
#####
find /var/spool/postfix/maildrop -type f -delete

##### For Empty All Log files

#truncate -s 0 /var/log/*
#truncate -s 0 /var/log/*/*
###
