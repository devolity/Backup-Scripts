<?php
$con = mysql_connect("51.254.198.42", "zipker_backup", "LL9KcredUhk2AwHw");
mysql_select_db("zipker_prod");
mysql_query("call sp_clearLogs()");
mysql_close($con);
?>
