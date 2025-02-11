#!/bin/bash

/usr/bin/php /var/www/html/zipker_courier_tracking_details_aramex.php >> /var/log/courier/aramex.log 2>&1

/usr/bin/php /home/script/phpmail_aramex.php
