/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Electronic components
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <agentscad/mx-screw.scad>


// ----------------------------------------
// LED component 5mm
// ----------------------------------------
module led5mm() {
    color( LED_OOLOR, 0.5 ) {
        cylinder( r=LED_D/2, h=LED_L-LED_D/2 );
        cylinder( r=LED_FLANGE_D/2, h=LED_FLANGE_L );
        translate( [0,0,-LED_PINS_H/2] )
            cube( [LED_PINS_W,LED_PINS_L,LED_PINS_H], center=true );
        translate( [0,0,LED_L-LED_D/2] )
            sphere(r=LED_D/2);
    }
}
module led5mmPassage() {
    cylinder( r=LED_DP/2, h=LED_L-LED_D/2 );
    translate( [0,0,-LED_PINS_H-gap()] )
        cylinder( r=LED_FLANGE_DP/2, h=LED_PINS_H+LED_FLANGE_L+2*gap() );
    translate( [0,0,LED_L-LED_D/2] )
        sphere(r=LED_DP/2);
}
function getLed5mmFlangeD()  = LED_FLANGE_D;
function getLed5mmFlangeDP() = LED_FLANGE_DP;
function getLed5mmFlangeL()  = LED_FLANGE_L;
function getLed5mmD()        = LED_D;
function getLed5mmDP()       = LED_DP;
function getLed5mmL()        = LED_L;
function getLed5mmPinsW()    = LED_PINS_W;
function getLed5mmPinsL()    = LED_PINS_L;
function getLed5mmPinsH()    = LED_PINS_H;

// ----------------------------------------
// PCB object
// ----------------------------------------

// sx:     size on x
// sy:     size on y
// t:      pcb thickness
// border: free border around pcb
// above:  reserved space above pcb (components)
// below:  reserved space below pcb (wires)
// holes:  holes definition list.
//         each hole is defined by [ x, y, screw ]
//         x:     x position of the hole from pcb center
//         y:     y position of the hole from pcb center
//         screw: screw object for hole (ex M4())
// 
function newPcb (
    sx, sy,
    t      = PCB_THICKNESS,
    border = PCB_BORDER,
    above  = ELECTRONICS_COMPS_H,
    below  = ELECTRONICS_PINS_H,
    holes  = []
) = let(
    sz     = t+above+below,
    pcbh   = t+below,
    dz     = sz/2-pcbh
) [ sx, sy, sz, dz, t, border, above, below, holes ];
function getPcbSx(p)          = p[IP_SX];
function getPcbSy(p)          = p[IP_SY];
function getPcbSz(p)          = p[IP_SZ];
function getPcbDz(p)          = p[IP_DZ];
function getPcbT(p)           = p[IP_T];
function getPcbBorder(p)      = p[IP_BORDER];
function getPcbAbove(p)       = p[IP_ABOVE];
function getPcbBelow(p)       = p[IP_BELOW];
function getPcbHoles(p)       = p[IP_HOLES];
IP_SX     = 0;
IP_SY     = 1;
IP_SZ     = 2;
IP_DZ     = 3;
IP_T      = 4;
IP_BORDER = 5;
IP_ABOVE  = 6;
IP_BELOW  = 7;
IP_HOLES  = 8;

module pcbShape ( pcb ) {
    a      = pcb[IP_ABOVE];
    t      = pcb[IP_T];
    b      = pcb[IP_BELOW];
    border = pcb[IP_BORDER];
    sx     = pcb[IP_SX];
    sy     = pcb[IP_SY];
    difference() {
        union() {
            translate( [0,0,a/2-pcb[IP_DZ]] )
                cube( [sx-border, sy-border, a ], center=true );
            color( "#888", 0.9 )
            translate( [0,0,t/2-t-pcb[IP_DZ]] )
                cube( [sx, sy, t ], center=true );
            translate( [0,0,-b/2-t-pcb[IP_DZ]] )
                cube( [sx-border, sy-border, b ], center=true );
        }
        for ( h=pcb[IP_HOLES] )
            translate( [ h[0], h[1], 0 ] )
                cylinder( r=h[2]/2, h=100, center=true );
    }
}

// ----------------------------------------
// Cable object
// ----------------------------------------

// r:  Cable diameter
// i:  [Optional] Distance between centers is cable section is oblong
// t:  [Optional] Cable length
// c:  [Optional] [x,y,z] position of cable starting point
// v:  [Optional] [x,y,z] vector of cable orientation
function newCable ( r, i=undef, l=undef, c=undef, v=undef ) = [
    r,
    is_undef(i) ? 0 : i,
    is_undef(l) ? 0 : l,
    is_undef(c) ? [0,0,0] : c,
    is_undef(v) ? [1,0,0] : v
];
function getCableR(p) = p[IC_R];
function getCableI(p) = p[IC_I];
function getCableL(p) = p[IC_L];
function getCableC(p) = p[IC_C];
function getCableV(p) = p[IC_V];
IC_R    = 0;
IC_I    = 1;
IC_L    = 2;
IC_C    = 3;
IC_V    = 4;

module cableShape ( cable, l=undef ) {
    l_l = is_undef(l) ? getCableL(cable) : l;
    translate( [ cable[IC_C][0], cable[IC_C][1], cable[IC_C][2] ] )
        alignOnVector ( cable[IC_V] )
            oblong ( r=getCableR(cable), h=getCableL(cable), i=getCableI(cable) );
}

// ----------------------------------------
// E27 Corn Bulb based on
//   Gezee LED Silver Corn Bulb
//   Type:E27 Watt:15W Input Volt:85-265V Color:6000K
// ----------------------------------------
CORN_BULB_E27_TD     = 25;
CORN_BULB_E27_TL     = 21;
CORN_BULB_E27_BD     = 30;
CORN_BULB_E27_BL     = 53;
CORN_BULB_E27_SINK_L = 19;
CORN_BULB_E27_BASE_D = 10;
CORN_BULB_E27_BASE_L =  9;

// Gezee LED Silver Corn Bulb
// Type:E27 Watt:15W Input Volt:85-265V Color:6000K
module cornBulbE27() {
    color("#dd8",0.5)
    translate( [0,0,CORN_BULB_E27_SINK_L+CORN_BULB_E27_BL/2] )
        cylinder( r=CORN_BULB_E27_BD/2, h=CORN_BULB_E27_BL, center=true );
    translate( [0,0,CORN_BULB_E27_SINK_L/2] )
        cylinder( r=CORN_BULB_E27_BD/2, h=CORN_BULB_E27_SINK_L, center=true );
    translate( [0,0,-CORN_BULB_E27_TL/2] )
        cylinder( r=CORN_BULB_E27_TD/2, h=CORN_BULB_E27_TL, center=true );
    translate( [0,0,-CORN_BULB_E27_TL-CORN_BULB_E27_BASE_L/2] )
        cylinder(
            r1=CORN_BULB_E27_BASE_D/2,
            r2=CORN_BULB_E27_TD/2,
            h=CORN_BULB_E27_BASE_L, center=true );
}
function getCornBulbE27TD() = CORN_BULB_E27_TD;     // Thread Diameter
function getCornBulbE27TL() = CORN_BULB_E27_TL;     // Thread Length
function getCornBulbE27D()  = CORN_BULB_E27_BD;     // Bulb Diameter
function getCornBulbE27L()  = CORN_BULB_E27_BL;     // Bulb Length
function getCornBulbE27SL() = CORN_BULB_E27_SINK_L; // Heatsink Length
function getCornBulbE27BD() = CORN_BULB_E27_BASE_D; // Base Diameter
function getCornBulbE27BL() = CORN_BULB_E27_BASE_L; // Base Length

// ----------------------------------------
// E27 LAMP HOLDER
// ----------------------------------------
E27_HOLDER_TD     = 40;
E27_HOLDER_TDP    = E27_HOLDER_TD+1.4;
E27_HOLDER_TL     = 35;
E27_HOLDER_HAND_H = 7;
E27_HOLDER_RING_D = 58;
E27_HOLDER_T      = 3;
E27_HOLDER_SOCK_D = 48;

module lampHolderE27() {
    difference() {
        color ( "#777" ) {
            translate( [0,0,E27_HOLDER_TL/4+E27_HOLDER_HAND_H/2+E27_HOLDER_T/2] )
                cylinder( r=E27_HOLDER_SOCK_D/2, h=E27_HOLDER_HAND_H, center=true );
            translate( [0,0,E27_HOLDER_TL/4] )
                cylinder( r=E27_HOLDER_RING_D/2, h=E27_HOLDER_T, center=true );
        }
        cylinder( r=E27_HOLDER_TDP/2, h=100, center=true );
    }
    color ( "#555" ) {
        translate( [0,0,0] )
            cylinder( r=E27_HOLDER_TD/2, h=E27_HOLDER_TL, center=true );
        translate( [0,0,-E27_HOLDER_T/2] )
            cylinder( r=E27_HOLDER_SOCK_D/2, h=E27_HOLDER_T, center=true );
        translate( [0,0,-E27_HOLDER_TL/2] )
            sphere( r=E27_HOLDER_TD/2 );
    }
    translate ( [ 0,0,getLampHolderE27BH()] )
        children();
}
function getLampHolderE27TD()  = E27_HOLDER_TD;     // External Thread Diameter
function getLampHolderE27TDP() = E27_HOLDER_TDP;    // TD Passage
function getLampHolderE27TL()  = E27_HOLDER_TL;     // Thread Length
function getLampHolderE27BH()  = E27_HOLDER_TL/2;   // Bulb Height position
function getLampHolderE27HH()  = E27_HOLDER_HAND_H; // Handle Height
function getLampHolderE27RD()  = E27_HOLDER_RING_D; // Handle Ring Diameter
function getLampHolderE27T()   = E27_HOLDER_T;      // Handle Ring Thickness
function getLampHolderE2SD()   = E27_HOLDER_SOCK_D; // Socket Diameter

// ----------------------------------------
//              Implementation
// ----------------------------------------
LED_D         = 5;
LED_L         = 9;
LED_DP        = LED_D+2*gap();
LED_FLANGE_D  = 5.6;
LED_FLANGE_DP = LED_FLANGE_D+2*gap();
LED_FLANGE_L  = 1;
LED_PINS_W    = 1.4;
LED_PINS_L    = 4.6;
LED_PINS_H    = 10;
LED_OOLOR     = "#aa6";

ELECTRONICS_COMPS_H = 12;
ELECTRONICS_PINS_H  = 3;
PCB_THICKNESS       = 1.5;
PCB_BORDER          = 0.8;



// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 100;

translate( [0, 20, 15] ) {
    led5mm($fn=PRECISION);
//    #led5mmPassage($fn=PRECISION);
}
translate( [0, 0, 0] ) {
    screw = M2_5(tl=16, ahd=5) ;
    pcb  = newPcb ( 40, 20, holes=[
        [-15, +4, screw ],
        [+10, -5, screw ]
    ]);
    %pcbShape(pcb,$fn=PRECISION);
}
translate( [0, 0, 0] ) {
    cable  = newCable ( r=3, i=6, l=30, c=[5, -30, 7], v=[1,-1,1] );
    cableShape(cable,$fn=PRECISION);
}
translate( [0, 60, 0] ) {
    lampHolderE27($fn=PRECISION);
    translate ( [ 0,0,E27_HOLDER_TL/2] )
        cornBulbE27($fn=PRECISION);
}

