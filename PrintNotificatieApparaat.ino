// Versie 2: voor ESPDuino met LEDstrip met voor elke printer een LED
// In de mail staat nu ook de naam van het bestand dat geprint werd.
// Compileren met Board = "ESPino (ESP-12 Module)"
// Rood: printer OFFLINE (staat uit)
// Groen: printer ONLINE en aan het printen
// Oranje: printer staat aan maar is niet aan het printen

// Buzzer: geeft in Morse (...-.) aan als een printer klaar is

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <WiFiClientSecure.h>
#include <Adafruit_NeoPixel.h>
#include <UrlEncode.h>

#define BUZZER 13

#define WIFI_SSID "Your Wifi ISSD"
#define WIFI_PASSWORD "Wifi password"

#define PRINTERTYPE_OCTOPI "OCTO"
#define PRINTERTYPE_MK4 "MK4"

#define ROOD   (LEDStrip.Color(80,0,0))
#define GROEN  (LEDStrip.Color(0,60,0))
#define BLAUW  (LEDStrip.Color(0,0,80))
#define ORANJE (LEDStrip.Color(40,20,0))

#define PRINTERTYPE_OCTOPI "OCTO"
#define PRINTERTYPE_MK4 "MK4"

// Array of all your 3D printers
// Every row (printer) has the following 4 elements:
//  Human-friendly name of printer, I address of printer, Password, Printer type (MK4 or Octopi)
// The password is the password of the user "maker" of the MK4. 
const char *Printers[]={
 "Printer1", "http://192.168.0.11/api/job", "924DCEB3BEAPI-Key8EBBCAC6CF631F",PRINTERTYPE_OCTOPI,
 "Printer2", "http://192.168.0.10/api/job", "5B9379API-KeyBB981B1C728",PRINTERTYPE_OCTOPI,
 "MK4","http://192.168.0.49:80/api/job","hdAPI-KeyDfHpN",PRINTERTYPE_MK4,
 "MK4-2","http://192.168.0.50:80/api/job","wAPI-Key",PRINTERTYPE_MK4,
 "MINI","http://192.168.0.4:80/api/job","XFMAPI-Keyg2y",PRINTERTYPE_MK4
};
const int NUMPRINTERS=sizeof(Printers) / sizeof(Printers[0])/4;

bool IsPRINTING[NUMPRINTERS];
bool IsMonitoring[NUMPRINTERS];
bool IsOranje[NUMPRINTERS];
String Files[NUMPRINTERS]; // Bewaar bestandsnamen zodat je die in de mail erbij kunt zetten later
bool IsFilamentMailVerstuurd[NUMPRINTERS];

// URL to my PHP script somewhere online that sends emails
#define WEB_MAILSENDER   "https://marcelv.net/IoT/sendmail.php"

ESP8266WiFiMulti EspDuino;
Adafruit_NeoPixel LEDStrip = Adafruit_NeoPixel(6,15, NEO_GRB + NEO_KHZ800);

void setup() {
 Serial.begin(115200);
 Serial.println("Opstarten..");
 pinMode(BUZZER,OUTPUT);
 digitalWrite(BUZZER,LOW);
 LEDStrip.begin(); 
 Alles(BLAUW); 
 WiFi.mode(WIFI_STA);
 EspDuino.addAP(WIFI_SSID, WIFI_PASSWORD);
 Serial.println("Verbonden met wifi!"); 
 AllesUit(); 
 Alles(ROOD);
 
 PieperdePiep();
}

void loop() {     
 if(EspDuino.run()== WL_CONNECTED){    
  WiFiClient client;
  HTTPClient http;   
  
  for(int i=0; i<NUMPRINTERS; i++) {         
   // This is an MK4 printer    
   http.begin(client,Printers[i*4+1]);
   http.addHeader("X-Api-Key", Printers[i*4+2]);
        
   int httpCode = http.GET();
   if(httpCode > 0) {     
    String payload = http.getString();
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, payload);
    // MK4: "State":"Operational";
    // Octoprint:       
    String Status = doc["state"].as<String>();
    bool IsPrinting = Status.indexOf("Printing")>=0; 
    IsOranje[i]=Status.indexOf("Operational")>=0; 
    
    if(IsPrinting) {
     bool IsWaiting=IsWaitingForColourChange(i);
     if(IsWaiting && !IsFilamentMailVerstuurd[i]) {
      SendMail(Printers[i*4],Files[i].c_str(),true);   
      IsFilamentMailVerstuurd[i]=true; 
     }
     
     IsMonitoring[i]=IsPRINTING[i]=true; ZetLEDKleur(i+1,GROEN);
     String s = doc["file"]["name"].as<String>(); // MK4 en MINI
     if(s=="null") s=doc["job"]["file"]["name"].as<String>(); // Octoprint
     Files[i]=s;             
    }
    else {ZetLEDKleur(i+1,IsOranje[i]? ORANJE : ROOD); IsFilamentMailVerstuurd[i]=false;} 
    if(!IsPrinting && IsMonitoring[i]) {
     // Print is klaar: verstuur alert
     IsMonitoring[i]=false; 
     IsPRINTING[i]=false;
     SendMail(Printers[i*4],Files[i].c_str(),false);    
     Files[i]="";
    }
   } 
   else {
    // MK4/MINI-Printer staat uit of Octopi niet bereikbaar 
    IsPRINTING[i]=false;
    ZetLEDKleur(i+1,ROOD);
    Offline(i);
    IsOranje[i]=false;
   }
   http.end();

  }//printers loop    
 }//Is Connected

 for(int p=0; p<NUMPRINTERS; p++) 
  ZetLEDKleur(p+1,IsPRINTING[p]? GROEN : IsOranje[p]? ORANJE : ROOD); 

 delay(10000);
}

void PieperdePiep() {
 // Morse letter V! ...-.
 for(int i=0; i<3; i++) {
  digitalWrite(BUZZER,HIGH);
  delay(80);
  digitalWrite(BUZZER,LOW);delay(80);
 }
 digitalWrite(BUZZER,HIGH);
 delay(240);
 digitalWrite(BUZZER,LOW);delay(80);
 digitalWrite(BUZZER,HIGH);
 delay(80);
 digitalWrite(BUZZER,LOW); 
}

void ZetLEDKleur(int IX,int Kleur) {
 LEDStrip.setPixelColor(IX,Kleur);
 LEDStrip.show();
}

void Offline(int PrinterIX) { 
 Serial.printf("Printer %s is offline.",Printers[PrinterIX*4]);
 Serial.println();
}

bool IsWaitingForColourChange(int PrinterIX) {
 static double PrevCompletion[NUMPRINTERS];
 String URL = Printers[PrinterIX*4+1];
    
 if(Printers[PrinterIX*4+3]==PRINTERTYPE_MK4) { 
  // Prusa printer
  URL.replace("job","printer");
  WiFiClient client; 
  HTTPClient http;   
  http.begin(client,URL);
  http.addHeader("X-Api-Key", Printers[PrinterIX*4+2]);
  int code=http.GET(); 
  String payload = http.getString();
  DynamicJsonDocument doc(1024);
  deserializeJson(doc, payload);
  http.end();
  return doc["telemetry"]["material"].as<String>()=="---";
 }
 else {
  // Octopi printer - we kunnen alleen de temperatuur bekijken om te zien of er een colour change nodig is
  // http://192.168.0.10:80/api/printer?history=true&limit=10

 /*Kijk naar progress.completion en naar progress.printtime
 Indien printtime>0 DAN pas kijken naar compltion (zodat hij niet meteen ah begin mailt)
 compltion is een double
 COMPLETION Verandert elke keer. Is getest met ene print van 2 dagen lang*/
  WiFiClient client; 
  HTTPClient http;   
  http.begin(client,URL);
  http.addHeader("X-Api-Key", Printers[PrinterIX*4+2]);
  int code=http.GET(); 
  String payload = http.getString();
  DynamicJsonDocument doc(1024);
  deserializeJson(doc, payload);
  http.end();
  
  int pt=doc["progress"]["printTime"];
  Serial.print("pt=");Serial.println(pt);
  if(pt>0) {
   double completion = doc["progress"]["completion"];

   Serial.printf("%lf %lf\r\n",completion,PrevCompletion[PrinterIX]);
   
   if(completion==PrevCompletion[PrinterIX]) {
    PrevCompletion[PrinterIX]=completion;
    return true;
   }
   PrevCompletion[PrinterIX]=completion;
  }    
 }
 return false;
}

void SendMail(const char *PrinterName,const char *Bestand,bool ColChange) {
  WiFiClientSecure client;
  client.setInsecure(); 
  
  String Url(WEB_MAILSENDER);   
  Url+="?printer="+String(PrinterName)+"&file="+urlEncode(Bestand);
  if(ColChange) Url+="&colorchange=1";
  HTTPClient http;   
  http.begin(client,Url);
  http.GET();
  String payload = http.getString();
  Serial.println(payload);
  http.end();

  PieperdePiep();
}

void AllesUit() {
 Alles(0);
}

void Alles(int Kleur) {
 LEDStrip.clear();
 for(int i=1; i<=NUMPRINTERS; i++) // Eerste LED (LED 0) wordt niet gebruikt
  LEDStrip.setPixelColor(i,Kleur);
 LEDStrip.show();
}
