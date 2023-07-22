# PrintnotificatieApparaat
Device that sends me a push message everytime a 3D printer completes a printjob.

This projects consists of a D1 Mini (ESP8266 based MCU) that is always on and monitors my 3D printers. Whenever a job on a 3D printer completes, the system sends me an email.

## Setup
1. Place the `sendmail.php` file on a webserver.
2. Upload the edited `.ino` file to the D1 Mini. Edit the file by adding your 3D printers. Every printer that is connected to Octoprint/Octopi is supported and also the Prusa MK4 (which is connected directly to Wifi, without Octoprint) is supported.
3. Power up a 3D printer and you'll receive an email as soon as the print is ready.

## Libraries
The D1 Mini file uses standard ESP8266 libraries and a special JSON library that can be found [here](https://github.com/bblanchon/ArduinoJson.git) or can be isntalled using the Arduino IDE itself.
