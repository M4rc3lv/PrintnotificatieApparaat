$fn=200;

Bottom=1;
Top=1;
Frontpanel=1;
Backpanel=1;
Foot=1;

WIDTH=140;
HEIGHT=50;
DEPTH=120;

XPP=1.4;

if(Foot) {
 cylinder(d=3.8,h=3);
 translate([0,0,3]) cylinder(d=14,h=3);
}

if(Backpanel) translate([0,DEPTH-6.2,1])  {
 color("white") difference() {
  cube([WIDTH-0.6,3,HEIGHT-2]); 
  // USB-aansluiting ESPDuino
  translate([60,-4,3]) cube([13,20,12]);
 }
 //2,6 5,2 
}

if(Frontpanel) translate([0,3,1])  {
 
 D=16.6*4;
 difference() {
  color("white") cube([WIDTH-0.6,3,HEIGHT-2]);
  translate([WIDTH/2-D/2,0,0])
  for(i=[0:1:4]) {   
   translate([16.6*i-2.7,0,0]) translate([0,-1,20])cube([5.4,10,5.4]);  
  }
   
  translate([(WIDTH-2)/2-D/2,0,0]) {
   // LED 0 en LED 6 (niet zichtbaar en niet in gebruik)
   translate([-16.6-2.7,2.4,0]) translate([0,-1,20])cube([5.4,10,5.4]);  
   translate([16.6*5-2.7,2.4,0]) translate([0,-1,20])cube([5.4,10,5.4]);  
  }
 
 }// diff
   
  color("grey")translate([7,0,35])rotate([90,0,0])
   linear_extrude(height=0.6) text(size=7,"3D-Print Notifier", halign="left",
     //font="Nimbus Sans Narrow:style=Bold");
  font="SF Atarian System Extended");

  translate([WIDTH/2-D/2-2.7,3,0]) {
   color("grey")translate([16.5*0+2.7,-3,14])rotate([90,30,0])
    linear_extrude(height=0.6) text(size=4,"P1", halign="center", valign="center",
     font="Arial Black");
   color("grey")translate([16.5*1+2.7,-3,14])rotate([90,30,0])
    linear_extrude(height=0.6) text(size=4,"P2", halign="center", valign="center",
     font="Arial Black");
   color("grey")translate([16.5*2+2.7,-3,14])rotate([90,30,0])
    linear_extrude(height=0.6) text(size=4,"MK4", halign="center", valign="center",
     font="Arial Black");
   color("grey")translate([16.5*3+2.7,-3,14])rotate([90,30,0])
    linear_extrude(height=0.6) text(size=4,"MK4-2", halign="center", valign="center",
     font="Arial Black");
   color("grey")translate([16.5*4+2.7,-3,14])rotate([90,30,0])
    linear_extrude(height=0.6) text(size=4,"MINI", halign="center", valign="center",
     font="Arial Black");
  }  
 
}


if(Top) translate([0,0,HEIGHT/2+1]){
 //if(Top) translate([0,0,HEIGHT/2+1]){
 difference() {
  hull() {
   translate([0,0,HEIGHT/2-1]) rotate([-90,0,0])cylinder(d=2,h=DEPTH);
   translate([0,0,HEIGHT/2-1]) translate([WIDTH,0,0])rotate([-90,0,0])cylinder(d=2,h=DEPTH);  
   translate([-1,0,0]) cube([2,DEPTH,2]);
   translate([WIDTH-1,0,0])cube([2,DEPTH,2]);
  }
  translate([1,-1,-1]) 
   cube([WIDTH-2,DEPTH+10,HEIGHT/2-1]);
  
  // Sleuf frontpanel 
  translate([0,3,-HEIGHT/2+14])cube([WIDTH,3.4,HEIGHT/2+10]);
  // Sleuf backpanel 
  translate([0,DEPTH-6.4,-HEIGHT/2+14])cube([WIDTH,3.4,HEIGHT/2+10]);
  
  // Koeling gaten - Let op dat deze soms fout gaan bij afmetingen
  translate([WIDTH/2-50/2,20,HEIGHT/4+5])  cube([50,2,10]);  
  translate([WIDTH/2-50/2,28,HEIGHT/4+5])  cube([50,2,10]);  
  translate([WIDTH/2-50/2,36,HEIGHT/4+5])  cube([50,2,10]);  
 }//diff
 
 // Front sleeve
 translate([WIDTH,0,HEIGHT/2-1]) {
  rotate([0,180,0])difference() {
   translate([0,0,1])cube([WIDTH,3,3]);
   translate([-1,-1,4])rotate([90,0,90])cylinder(d=6,h=WIDTH+10);
  }
  rotate([0,180,0])translate([0,6.4,1])cube([WIDTH,2,5]);
 }
 // Back sleeve
 translate([0,DEPTH,HEIGHT/2-1]) {
  rotate([0,180,180])difference() {
   translate([0,0,1])cube([WIDTH,3,3]);
   translate([-1,-1,4])rotate([90,0,90])cylinder(d=6,h=WIDTH+10);
  }
  rotate([0,180,180])translate([0,DEPTH-6.4-2,1])cube([WIDTH,2,5]);
 }
 
 // Bevestigingsschroeven zijkant
 translate([1,DEPTH/5,-8]) difference() {
  cube([6,10,HEIGHT/2+8]);
  translate([-1,5,4])rotate([90,0,90])cylinder(d=3.4,h=5);
 } 
 translate([1,DEPTH-DEPTH/5,-8]) difference() {
  cube([6,10,HEIGHT/2+8]);
  translate([-1,5,4])rotate([90,0,90])cylinder(d=3.4,h=5);
 } 
 translate([WIDTH-7,DEPTH/5,-8]) difference() {
  cube([6,10,HEIGHT/2+8]);
  translate([2,5,4])rotate([90,0,90])cylinder(d=3.4,h=5);
 } 
 translate([WIDTH-7,DEPTH-DEPTH/5,-8]) difference() {
  cube([6,10,HEIGHT/2+8]);
  translate([2,5,4])rotate([90,0,90])cylinder(d=3.4,h=5);
 }   
}


if(Bottom) { 
 difference() {
  hull() {
   rotate([-90,0,0])cylinder(d=2,h=DEPTH);
   translate([WIDTH,0,0])rotate([-90,0,0])cylinder(d=2,h=DEPTH);  
   translate([-1,0,HEIGHT/2-1]) cube([2,DEPTH,2]);
   translate([-1,0,HEIGHT/2-1])translate([WIDTH,0,0])cube([2,DEPTH,2]);  
  }
  translate([1,-1,1]) cube([WIDTH-2,DEPTH+10,HEIGHT/2+10]);
      
  // Schroefgaten zijkant
  translate([-2,DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=2.6,h=5);
  translate([-5,DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=5,h=5);
  translate([-2,DEPTH-DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=2.6,h=5);
  translate([-5,DEPTH-DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=5,h=5);
  
  translate([WIDTH-2,DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=2.6,h=5);
  translate([WIDTH,DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=5,h=5);
  
  translate([WIDTH-2,DEPTH-DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=2.6,h=5);
  translate([WIDTH,DEPTH-DEPTH/5+5,HEIGHT/2-3]) rotate([90,0,90])cylinder(d=5,h=5);
  
  // Sleuven frontpanel 
  translate([0,3,0])cube([WIDTH,3.4,HEIGHT/2+10]);
  // Sleuven backpanel
  translate([0,DEPTH-6.6,0])cube([WIDTH,3.4,HEIGHT/2+10]);
  // Gaatjes voor voetjes
  translate([11,11,-2]) cylinder(d=4,h=10);
  translate([WIDTH-11,11,-2]) cylinder(d=4,h=10);
  translate([WIDTH-11,DEPTH-11,-2]) cylinder(d=4,h=10);
  translate([11,DEPTH-11,-2]) cylinder(d=4,h=10);
 }
 
 // Front sleeve
 difference() {
  translate([0,0,1])cube([WIDTH,3,3]);
  translate([-1,-1,4])rotate([90,0,90])cylinder(d=6,h=WIDTH+10);
 }
 translate([0,6.4,1])cube([WIDTH,2,5]);
 // Back
 difference() {
  translate([0,DEPTH-3,1])cube([WIDTH,3,3]);
  translate([-1,DEPTH+1,5])rotate([90,0,90])cylinder(d=6,h=WIDTH+10);
  // USB-aansluiting ESPDuino
  translate([60,DEPTH-14,3]) cube([13,20,12]);
 }
 difference() {
  translate([0,DEPTH-6.4-2,1])cube([WIDTH,2,5]); 
  // USB-aansluiting ESPDuino
  translate([60,DEPTH-14,3]) cube([13,20,12]);
 }
}

module Cube(xdim ,ydim ,zdim,rdim=1) {
 hull(){
  translate([rdim,rdim,0])cylinder(h=zdim,r=rdim);
  translate([xdim-rdim,rdim,0])cylinder(h=zdim,r=rdim);
  translate([rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim);
  translate([xdim-rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim);
 }
}

