#!/bin/bash
###################
# Devolity Enterprise
# www.devolity.com
# info@devolity.com
###################

#---- DIR Lists
BAKUP_USER=backup_admin
BAKUP_DIR=/home/Raw_Aidbs_com
DATA_DIR=/home/.Raw2022s
LOGPATH=$DATA_DIR/Logs-Record
#---- Location of sync log [will be rotated with savelog]
LOGFILE=$LOGPATH/cloud-sync.log
#---- Location of cron log
CRONLOG=$LOGPATH/cloud-sync-cron.log
#####################################################

#---- Log startup
echo $(date -u)' | Starting Cloud Backup. . .!' >> $CRONLOG

#---- Web Database Backup
/usr/bin/bash "${DATA_DIR}"/DB-Backup-All.sh 1 >> "${LOGPATH}"/mysqlbkup.log 2>>"${LOGPATH}"/mysqlbkup-err.log

#---- Web Data File Backup
/usr/bin/bash "${DATA_DIR}"/File-Dir-Backup.sh 1 >> "${LOGPATH}"/filebkup.log 2>>"${LOGPATH}"/filebkup-err.log

######################################################

#---- Report Backup Sizes
ls -l -R -h -go $BAKUP_DIR > $BAKUP_DIR/Report.txt

#---- Change of permissions
chown -R "${BAKUP_USER}":"${BAKUP_USER}" "${BAKUP_DIR}"

#---- log success
echo $(date -u)' | Completed Cloud Backup..!' >> $CRONLOG

#---- Send Mail Report
emailbody=$(ls -l -R -h -go $BAKUP_DIR)
emailsub=$(hostname -f)

#---- Email Sending
curl -s --user 'api:xxxxxxxxx- key - ' \
  https://api.mailgun.net/v3/sandbox4a4d99a138ed405abed4ed40fa325db3.mailgun.org/messages \
  -F from='Devolity Backup Report <mailgun@sandbox4a4d99a138ed405abed4ed40fa325db3.mailgun.org>' \
  -F to=alert@devolity.com \
  -F subject="$emailsub -- Backups Report" \
  -F text="Today Backup Files Records == $emailbody"
#----
### EOF
