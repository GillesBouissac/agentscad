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
use <agentscad/printing.scad>
use <agentscad/mx-screw.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
module led_5mm() {
    color( LED_OOLOR, 0.5 ) {
        cylinder( r=LED_D/2, h=LED_L-LED_D/2 );
        cylinder( r=LED_FLANGE_D/2, h=LED_FLANGE_L );
        translate( [0,0,-LED_PINS_H/2] )
            cube( [LED_PINS_W,LED_PINS_L,LED_PINS_H], center=true );
        translate( [0,0,LED_L-LED_D/2] )
            sphere(r=LED_D/2);
    }
}
module led_5mm_passage() {
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
    ) =
[ sx, sy, t, border, above, below, holes ];
function getPcbSx(p)          = p[IP_SX];
function getPcbSy(p)          = p[IP_SY];
function getPcbSz(p)          = p[IP_ABOVE]+p[IP_BELOW]+p[IP_T];
function getPcbT(p)           = p[IP_T];
function getPcbBorder(p)      = p[IP_BORDER];
function getPcbAbove(p)       = p[IP_ABOVE];
function getPcbBelow(p)       = p[IP_BELOW];
function getPcbHoles(p)       = p[IP_HOLES];

module pcbShape ( pcb ) {
    a      = pcb[IP_ABOVE];
    t      = pcb[IP_T];
    b      = pcb[IP_BELOW];
    border = pcb[IP_BORDER];
    sx     = pcb[IP_SX];
    sy     = pcb[IP_SY];
    difference() {
        union() {
            translate( [0,0,a/2] )
                cube( [sx-border, sy-border, a ], center=true );
            color( "#888", 0.9 )
            translate( [0,0,t/2-t] )
                cube( [sx, sy, t ], center=true );
            translate( [0,0,-b/2-t] )
                cube( [sx-border, sy-border, b ], center=true );
        }
        for ( h=pcb[IP_HOLES] )
            translate( [ h[0], h[1] ] )
                cylinder( r=h[2]/2, h=100, center=true );
    }
}



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

IP_SX     = 0;
IP_SY     = 1;
IP_T      = 2;
IP_BORDER = 3;
IP_ABOVE  = 4;
IP_BELOW  = 5;
IP_HOLES  = 6;


// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 50;

translate( [0, 20, 15] ) {
    led_5mm($fn=PRECISION);
    #led_5mm_passage($fn=PRECISION);
}
translate( [0, 0, 0] ) {
    screw = M2_5(tl=16, ahd=5) ;
    pcb  = newPcb ( 40, 20, holes=[
        [-15, +4, screw ],
        [+10, -5, screw ]
    ]);
    %pcbShape(pcb,$fn=PRECISION);
}


