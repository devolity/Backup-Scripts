#!/bin/bash

backuplocation="/araw/backup/htdocs-$(date +'%d-%b-%Y')"

function htdocs{
mkdir -p $backuplocation/
for htdocs in $(mysql -uadmin -p`cat /etc/psa/.psa.shadow` -Dpsa --skip-column-names -e"SELECT name FROM domains" -s)
do
/bin/tar czvf $backuplocation/$htdocs.tar.gz $(mysql -uadmin -p`cat /etc/psa/.psa.shadow` -Dpsa -e"SELECT dom.id, dom.name, www_root FROM domains dom LEFT JOIN hosting d ON (dom.id = d.dom_id) WHERE dom.name = '$htdocs'" -s --skip-column-names | awk '{print $3}')
done
}

function mails{
mkdir -p $backuplocation/emails
find /var/qmail/mailnames -type d -maxdepth 1 -mindepth 1 -exec tar czvf {}.tar.gz {}  \;
mv /var/qmail/mailnames/*.tar.gz $backuplocation/emails/
}

### Remove Older Data
find $backuplocation/* -mtime +2 -exec rm -rf {} \;
