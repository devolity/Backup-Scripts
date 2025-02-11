#!/bin/bash

/usr/bin/php /var/www/html/zipker_courier_tracking_details_bluedart.php | -arg >> /var/log/courier/bluedart.log 2>&1

/usr/bin/php /home/script/phpmail_bludart.php
