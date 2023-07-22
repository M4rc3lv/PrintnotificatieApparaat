<?php

date_default_timezone_set('Europe/Amsterdam');
$currentTime = date('H:i');

$Naam=$_GET["printer"];

$to = "yoruemailaddress@gmail.com";
$subject = "3D Print is voltooid!";
$body = "Hoi Marcel,\r\n\r\nJe print-job op printer '$Naam' is voltooid om $currentTime uur.\r\n\r\nGroetjes,\r\nJe 3D-printer.";

$headers = 'From: 3D-printer@yourwebsite.com' . "\r\n" .
    'Reply-To: 3D-printer@yourwebsite.com' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

if(mail($to, $subject, $body, $headers)) {
  echo "Mail verstuurd!";
} else {
  echo "Fout bij versturen mail";
}

