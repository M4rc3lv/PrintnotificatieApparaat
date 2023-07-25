<?php

date_default_timezone_set('Europe/Amsterdam');
$currentTime = date('H:i');

$Naam=$_GET["printer"];
$Bestand=isset($_GET["file"])? $_GET["file"] : false;
$ColorChange=isset($_GET["colorchange"])? $_GET["colorchange"] : false;

$to = "marcelveldhuijzen@gmail.com";
$subject = "3D Print is voltooid!";
$body = "Hoi Marcel,\r\n\r\nJe print-job op printer '$Naam' is voltooid om $currentTime uur.\r\n\r\nGroetjes,\r\nJe 3D-printer.";
if($Bestand)
 $body = "Hoi Marcel,\r\n\r\nDe print-job van bestand '$Bestand' op printer '$Naam' is voltooid om $currentTime uur.\r\n\r\nGroetjes,\r\nJe 3D-printer.";

if($ColorChange) {
 $subject = "Filamentwissel voor 3D Print is benodigid!";
 if($Bestand)
  $body = "Hoi Marcel,\r\n\r\nPrinter $Naam is aan het wachten op een filamentwissel voor het printen van '$Bestand'.\r\n\r\nGroetjes,\r\nJe 3D-printer.";
 else
  $body = "Hoi Marcel,\r\n\r\nPrinter $Naam is aan het wachten op een filamentwissel.\r\n\r\nGroetjes,\r\nJe 3D-printer.";
}

$headers = 'From: 3D-printer@marcelv.net' . "\r\n" .
    'Reply-To: 3D-printer@marcelv.net' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

if(mail($to, $subject, $body, $headers)) {
  echo "Mail verstuurd!";
} else {
  echo "Fout bij versturen mail";
}
