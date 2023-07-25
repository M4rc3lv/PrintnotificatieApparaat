# PrintnotificatieApparaat
Device that sends me a push message everytime a 3D printer completes a printjob.   
<img src="https://raw.githubusercontent.com/M4rc3lv/PrintnotificatieApparaat/main/Docs/Device-V1.png" width="300" title="Version 1" align="right">
Features since V2:
- Include name of file and name of printer in message.
- Works with 1 or more 3D printers (I use it for 5 printers).
- Also sends an alert when one of the 3D printers is waiting for a filamant change.
- Works with Prusa MK4, MINI printers and every Octoprint printer (like my MK3's).

This projects consists of a D1 Mini (ESP8266 based MCU) that is always on and monitors my 3D printers. Whenever a job on a 3D printer completes, the system sends me an email. Version 2 uses a ESPDuino (but you can use any ESP8266 MCU) and has a NeoPixel LED-strip and a buzzer. See the [schematic](https://github.com/M4rc3lv/PrintnotificatieApparaat/blob/main/3Schematic.png).

## Setup
1. Place the `sendmail.php` file on a webserver.
2. Upload the edited `.ino` file to the ESPDuino or other ESP8266. Edit the file by adding your 3D printers. Every printer that is connected to Octoprint/Octopi is supported and also the Prusa MK4 and Prusa MINI (which are connected directly to your network, without Octoprint) is supported. Compile in the Arduino IDE with Board set to "ESPino (ESP-12 Module)".
3. Power up a 3D printer and you'll receive an email as soon as the print is ready or when you need to change the filament.

## Libraries
The ESPduino/D1 Mini file uses standard ESP8266 libraries and a special JSON library that can be found [here](https://github.com/bblanchon/ArduinoJson.git). Can also be installed using the Arduino IDE itself.
\
\
**Example of a message:**
<table><tr><td>
<img src="https://raw.githubusercontent.com/M4rc3lv/PrintnotificatieApparaat/main/Docs/email.png" border="1">
</td></tr></table>

**Version 2 of the device:**
\
<img src="https://marcelv.net/data/db262_Versie2.jpg" width="80%">



