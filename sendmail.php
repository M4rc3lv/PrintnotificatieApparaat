<?php

date_default_timezone_set('Europe/Amsterdam');
$currentTime = date('H:i');

$Naam=$_GET["printer"];
$Bestand=isset($_GET["file"])? $_GET["file"] : false;

$to = "marcelveldhuijzen@gmail.com";
$subject = "3D Print is voltooid!";
$body = "Hoi Marcel,\r\n\r\nJe print-job op printer '$Naam' is voltooid om $currentTime uur.\r\n\r\nGroetjes,\r\nJe 3D-printer.";
if($_GET["file"])
 $body = "Hoi Marcel,\r\n\r\nDe print-job van bestand '$Bestand' op printer '$Naam' is voltooid om $currentTime uur.\r\n\r\nGroetjes,\r\nJe 3D-printer.";

$headers = 'From: 3D-printer@marcelv.net' . "\r\n" .
    'Reply-To: 3D-printer@marcelv.net' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

if(mail($to, $subject, $body, $headers)) {
  echo "Mail verstuurd!";
} else {
  echo "Fout bij versturen mail";
}

