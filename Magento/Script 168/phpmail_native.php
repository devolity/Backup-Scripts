<?php
// the message
$msg = "Native Task Completed Data copy at ".date('l jS \of F Y h:i:s A')."";

// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);

// send email
mail("arpan.jain@zipker.com,avinash.puri@zipker.com","Native Zipker Courier Data Move",$msg);
?>
