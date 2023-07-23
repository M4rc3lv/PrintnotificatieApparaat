#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <WiFiClientSecure.h>

#define WIFI_SSID "Your Wifi ISSD"
#define WIFI_PASSWORD "Your Wifi password"

#define PRINTERTYPE_OCTOPI "OCTO"
#define PRINTERTYPE_MK4 "MK4"

// Array of all your 3D printers
// Every row (printer) has the following 4 elements:
// Printer type (MK4 or Octopi), Human-friendly name of printer, IP address of printer, Password
// The password is the password of the user "maker" of the MK4 or the API Key in case of Octoprint.
const char *Printers[]={  
 PRINTERTYPE_OCTOPI, "Printer1", "http://octopi.local/api/job", "DAAACEB3BE4A4BBF868EBBCAC6CF631F",
 PRINTERTYPE_OCTOPI, "Printer2", "http://octopi2.local/api/job", "95CA0CE42C276F14BED5392EBFC3924",
 PRINTERTYPE_MK4, "MK4","http://192.168.0.49:80/api/printer","passwordMK4",
 PRINTERTYPE_MK4, "MK4-2","http://192.168.0.50:80/api/printer","wachtwoordMK42"
};
const int NUMPRINTERS=sizeof(Printers) / sizeof(Printers[0])/4;

// Hardware wiring of all printer indicator LEd's
const int PrinterLEDs[]={D1,D2,D3,D4};

bool IsPRINTING[NUMPRINTERS];
bool IsMonitoring[NUMPRINTERS];

// URL to my PHP script somewhere online that sends emails
#define WEB_MAILSENDER   "https://marcelv.net/IoT/sendmail.php"

ESP8266WiFiMulti D1Mini;

void setup() {
 for(int i=0; i<NUMPRINTERS; i++) {
  pinMode(PrinterLEDs[i],OUTPUT);
  digitalWrite(PrinterLEDs[i],LOW);
 }
 RunningLight(2);
 
 for(int i=0; i<NUMPRINTERS; i++) digitalWrite(PrinterLEDs[i],HIGH); 
 
 Serial.begin(115200);
 WiFi.mode(WIFI_STA);
 D1Mini.addAP(WIFI_SSID, WIFI_PASSWORD);
 Serial.println("Connected to WiFi"); 

 for(int i=0; i<NUMPRINTERS; i++) digitalWrite(PrinterLEDs[i],LOW); 
}

void loop() {     
 if(D1Mini.run()== WL_CONNECTED){    
  WiFiClient client;
  HTTPClient http;   

  for(int i=0; i<NUMPRINTERS; i++) {
   if(strcmp(Printers[i*4],PRINTERTYPE_MK4)==0) {
    // This is an MK4 printer
    http.begin(client,Printers[i*4+2]);
    http.addHeader("X-Api-Key", Printers[i*4+3]);  
      
    int httpCode = http.GET();
    if(httpCode > 0) {     
     String payload = http.getString();
     DynamicJsonDocument doc(1024);
     deserializeJson(doc, payload);
     JsonObject State = doc["state"];
     bool IsPrinting = State["flags"]["printing"];   
     bool IsOper = State["flags"]["operational"]; 
     if(IsPrinting) IsMonitoring[i]=IsPRINTING[i]=true;
     if(!IsPrinting && IsMonitoring[i]) {
      // Print has been completed: send alert!
      IsMonitoring[i]=false; 
      SendMail(Printers[i*4+1]);    
     }
    } 
    else {
     // MK4 printer is switched off
     IsPRINTING[i]=false;
     digitalWrite(PrinterLEDs[i],LOW);
     Offline(i);
    }
    http.end();
   }
   else {
    // Octoprint printer
    Serial.printf("Check Octopi-printer %s, URL: %s\r\n",Printers[i*4+1],Printers[i*4+2]);
    http.begin(client,Printers[i*4+2]);
    http.addHeader("X-Api-Key", Printers[i*4+3]);      
    int httpCode = http.GET();    
    if(httpCode > 0) {
     String payload = http.getString();     
     bool IsPrinting = payload.indexOf("\"Printing\"") > 0;
     if(IsPrinting) IsMonitoring[i]=IsPRINTING[i]=true;
     if(!IsPrinting && IsMonitoring[i]) {
      // Print has been completed: send alert!
      IsMonitoring[i]=false; 
      SendMail(Printers[i*4+1]);    
     }
     //Serial.println(payload);
     if(payload.indexOf("\"Offline") > 0) { // Note: no trailing " here!
      digitalWrite(PrinterLEDs[i],LOW);
      Offline(i);
     }
    }
    else {
     IsPRINTING[i]=false;
     digitalWrite(PrinterLEDs[i],LOW);
     Offline(i);
    }
   }
   http.end();
  }//printers loop
  
  
 }

 for(int i=0; i<10; i++) {
  for(int p=0; p<NUMPRINTERS; p++) digitalWrite(PrinterLEDs[p],IsPRINTING[p]?HIGH:LOW);
  delay(500);
  for(int p=0; p<NUMPRINTERS; p++) digitalWrite(PrinterLEDs[p],LOW);
  delay(500);
 }
 RunningLight(1);
 for(int p=0; p<NUMPRINTERS; p++) digitalWrite(PrinterLEDs[p],IsPRINTING[p]?HIGH:LOW);  
}

void Offline(int PrinterIX) { 
 Serial.printf("Printer %s is offline.",Printers[PrinterIX*4+1]);
 Serial.println();
}

void SendMail(const char *PrinterName) {
  WiFiClientSecure client;
  client.setInsecure(); 

  String Url(WEB_MAILSENDER);   
  Url+="?printer="+String(PrinterName);
  HTTPClient http;   
  http.begin(client,Url);
  http.GET();
  String payload = http.getString();
  Serial.println(payload);
  http.end();
}

void RunningLight(int n) {
 for(int j=0; j<n; j++) {
  for(int i=0; i<NUMPRINTERS; i++) {    
   digitalWrite(PrinterLEDs[i],HIGH);
   delay(100);
   digitalWrite(PrinterLEDs[i],LOW);
   delay(100);
  }
 }
}
