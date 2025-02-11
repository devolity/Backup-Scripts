<?php
$con = mysql_connect("46.105.112.141", "zipker_arpan", "A<5{b>~X/EYhdJ");
mysql_select_db("zipker_prod");
mysql_query("call sp_clearLogs()");
mysql_close($con);
?>
