#!/bin/bash

/usr/bin/php /var/www/html/zipker_courier_tracking_details_fedex.php | -arg >> /var/log/courier/fedex.log 2>&1

/usr/bin/php /home/script/phpmail_fedex.php 
