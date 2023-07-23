$fn=200;

Bottom=1;
Top=1;
Frontpanel=1;
Backpanel=1;
Foot=0;

WIDTH=100;
HEIGHT=50;
DEPTH=120;

XPP=1.4;

if(Foot) {
 cylinder(d=3.8,h=3);
 translate([0,0,3]) cylinder(d=8,h=3);
}

if(Backpanel) translate([0,3,1])  {
 color("white") difference() {
  cube([WIDTH-0.6,3,HEIGHT-2]); 
  //USB-kabel
  translate([0,-1,5])cube([2.7,20,5.2]);
 }
 //2,6 5,2 
}

if(Frontpanel) translate([0,3,1])  {
 difference() {
  color("white") cube([WIDTH-0.6,3,HEIGHT-2]);
  translate([0,0,-6]) {
   translate([18,4,28]) rotate([90,0,0])cylinder(d=5,h=10);
   translate([39,4,28]) rotate([90,0,0])cylinder(d=5,h=10);
   translate([61,4,28]) rotate([90,0,0])cylinder(d=5,h=10);
   translate([82,4,28]) rotate([90,0,0])cylinder(d=5,h=10);
  }
 }
 
 translate([0,0,-6]) {
  // Rand om LED's
  difference() {
   translate([18,0,28]) color("grey")rotate([90,0,0])cylinder(d=8,h=0.6);
   translate([18,4,28]) rotate([90,0,0])cylinder(d=6,h=10);
  }
  difference() {
   translate([39,0,28]) color("grey")rotate([90,0,0])cylinder(d=8,h=0.6);
   translate([39,4,28]) rotate([90,0,0])cylinder(d=6,h=10);
  }
  difference() {
   translate([61,0,28]) color("grey")rotate([90,0,0])cylinder(d=8,h=0.6);
   translate([61,4,28]) rotate([90,0,0])cylinder(d=6,h=10);
  }
  difference() {
   translate([82,0,28]) color("grey")rotate([90,0,0])cylinder(d=8,h=0.6);
   translate([82,4,28]) rotate([90,0,0])cylinder(d=6,h=10);
  }
   
  color("grey")translate([6,0,42])rotate([90,0,0])
   linear_extrude(height=0.6) text(size=4.55,"3D-Print Notifier", halign="left",
     //font="Nimbus Sans Narrow:style=Bold");
  font="SF Atarian System Extended");
  
  color("grey")translate([18,0,20])rotate([90,0,0])
   linear_extrude(height=0.6) text(size=3.8,"PR1", halign="center", valign="center",
     font="SF Atarian System Extended");
  
  color("grey")translate([39,0,20])rotate([90,0,0])
   linear_extrude(height=0.6) text(size=3.8,"PR2", halign="center", valign="center",
     font="SF Atarian System Extended");
  
  color("grey")translate([61,0,20])rotate([90,0,0])
   linear_extrude(height=0.6) text(size=3.8,"PR3", halign="center", valign="center",
     font="SF Atarian System Extended");
  
  color("grey")translate([82,0,20])rotate([90,0,0])
   linear_extrude(height=0.6) text(size=3.8,"PR4", halign="center", valign="center",
     font="SF Atarian System Extended");
   
  }//translate  
 
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
  translate([-2,DEPTH-DEPTH/4,HEIGHT/4+2])cube([10,1.6,40]);
  translate([-2,DEPTH-DEPTH/4-6,HEIGHT/4+2])cube([10,1.6,40]);
  translate([-2,DEPTH-DEPTH/4-12,HEIGHT/4+2])cube([10,1.6,40]);
  translate([WIDTH+2-10,DEPTH-DEPTH/4,HEIGHT/4+2])cube([10,1.6,40]);
  translate([WIDTH+2-10,DEPTH-DEPTH/4-6,HEIGHT/4+2])cube([10,1.6,40]);
  translate([WIDTH+2-10,DEPTH-DEPTH/4-12,HEIGHT/4+2])cube([10,1.6,40]);
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
 }
 translate([0,DEPTH-6.4-2,1])cube([WIDTH,2,5]);
// hull() 
// {
//  #translate([0,0,1])cube([WIDTH,0.1,0.1]);//rotate([90,0,90])cylinder(d=0.8,h=WIDTH);
//  //translate([0,1.4,1])rotate([90,0,90])cylinder(d=1.8,h=WIDTH);
// }

}

module Cube(xdim ,ydim ,zdim,rdim=1) {
 hull(){
  translate([rdim,rdim,0])cylinder(h=zdim,r=rdim);
  translate([xdim-rdim,rdim,0])cylinder(h=zdim,r=rdim);
  translate([rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim);
  translate([xdim-rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim);
 }
}