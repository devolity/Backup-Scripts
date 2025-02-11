#!/bin/bash

/usr/bin/php /var/www/html/zipker_courier_tracking_details_ecom.php | -arg >> /var/log/courier/ecom.log 2>&1

/usr/bin/php /home/script/phpmail_ecom.php
