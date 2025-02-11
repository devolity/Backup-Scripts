#!/bin/bash

/usr/bin/php /var/www/html/zipker_pending_order_email.php | -arg >> /var/log/courier/pendingorder.log 2>&1

/usr/bin/php /home/script/phpmail.php
