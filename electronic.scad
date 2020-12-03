/*
 * Copyright (c) 2020, Gilles Bouissac
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
use <scad-utils/lists.scad>


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
// Dz: Distance between top of PCB and mid-height of the bounding box
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
// 5.25" CD Drives
// Specifications:
//    SFF-8551
//    Form Factor of 5.25" CD Drives
//    https://members.snia.org/document/dl/25931
// ----------------------------------------
SFF8551_A_Inch = [
    0,
    1.635, // A1: maximum height
    1.665,
    5.827,
    7.984, // A4: maximum length
    5.750, // A5: width
    5.500, // A6: bottom hole X interval
    0.125,
    3.120, // A8: bottom hole Y interval
    1.866, // A9: bottom hole Y distance from front
    1.866, // A10: side hole Y distance from front
    3.120, // A11: side hole Y interval
    0,
    0.394, // A13: side lower holes Z
    0.860, // A14: side upper holes Z
    0,
    0.256,
    0.197
];
SFF8551_A = [ for (i=SFF8551_A_Inch) inch2mm(i) ];
SFF8551_TD  = 3;   // M3 Thread Diameter
SFF8551_TP  = 0.5; // M3 Thread Pitch
function getDrive525Data()     = SFF8551_A;      // Dimensions in mm
function getDrive525DataInch() = SFF8551_A_Inch; // Dimensions in Inch
function getDrive525TD()       = SFF8551_TD;     // Thread Diameter
function getDrive525TP()       = SFF8551_TP;     // Thread Pitch

module drive525Connector( height=undef, length=undef ) {
    local_w = SFF8551_A[5];
    local_h = min(is_undef(height)?SFF8551_A[1]:height, SFF8551_A[1]);
    local_l = min(is_undef(length)?SFF8551_A[4]:length, SFF8551_A[4]);
    cnx_o   = 3;
    cnx_l   = 20;
    cnx_h   = local_h/2 - 2*cnx_o;
    cnx_w   = local_w - 2*cnx_o;
    difference() {
        translate( [0,local_l,cnx_h/2+cnx_o] )
            cube( [cnx_w, cnx_l, cnx_h], center=true );
    }
}
module drive525Body( height=undef, length=undef ) {
    local_w = SFF8551_A[5];
    local_h = min(is_undef(height)?SFF8551_A[1]:height, SFF8551_A[1]);
    local_l = min(is_undef(length)?SFF8551_A[4]:length, SFF8551_A[4]);
    difference() {
        translate( [0,local_l/2,local_h/2] )
            cube( [local_w, local_l, local_h], center=true );
    }
}
module drive525Facade() {
    local_w = SFF8551_A[5];
    local_h = SFF8551_A[2];
    local_l = SFF8551_A[17];
    translate( [0,-local_l/2,local_h/2] )
        cube( [local_w, local_l, local_h], center=true );
}
module drive525Hole( length=undef ) {
    // SFF8551 says: 2 threads (pitch) minimum
    tapMin    = 2*SFF8551_TP;
    tapLength = max(is_undef(length)?tapMin:length,tapMin);
    tapRadius = (SFF8551_TD-SFF8551_TP)/2;
    translate( [0,0,tapLength/2] )
        cylinder( r=tapRadius, h=tapLength, center=true );
}
module drive525ForEachBottomHole() {
    cloneMirror([1,0,0]) {
        translate( [SFF8551_A[6]/2,SFF8551_A[9],0] )
            children();
        translate( [SFF8551_A[6]/2,SFF8551_A[9]+SFF8551_A[8],0] )
            children();
    }
}
module drive525ForEachSideHole( height ) {
    cloneMirror([1,0,0])
    translate( [SFF8551_A[5]/2,0,height] )
    rotate([0,-90,0]) {
        translate( [0,SFF8551_A[10],0] )
            children();
        translate( [0,SFF8551_A[10]+SFF8551_A[11],0] )
            children();
    }
}
module drive525ForEachSideLowerHole() {
    drive525ForEachSideHole(SFF8551_A[13])
        children();
}
module drive525ForEachSideUpperHole() {
    drive525ForEachSideHole(SFF8551_A[14])
        children();
}
module drive525BottomHoles( length=undef ) {
    drive525ForEachBottomHole()
        drive525Hole( length );
}
module drive525SideUpperHoles( length=undef ) {
    drive525ForEachSideUpperHole()
        drive525Hole( length );
}
module drive525SideLowerHoles( length=undef ) {
    drive525ForEachSideLowerHole()
        drive525Hole( length );
}
module drive525( height=undef, length=undef, thread_l=undef ) {
    difference() {
        drive525Body(height, length);
        drive525Connector(height, length);
#        drive525BottomHoles(thread_l);
#        drive525SideLowerHoles(thread_l);
#        drive525SideUpperHoles(thread_l);
    }
    drive525Facade();
}

// ----------------------------------------
// 3.5" Drives
// Specifications:
//    SFF-8301
//    3.5" Form Factor Drive Dimensions
//    https://members.snia.org/document/dl/25862
// ----------------------------------------
SFF8301_A_Inch = [
    0,     /* A0 */
    [ 0.7, 1.028, 1.654 ], /* A1: height */
    5.787, /* A2: length */
    4.0,   /* A3: width */
    3.75,  /* A4: bottom holes X interval */
    0.125,
    1.75,  /* A6: bottom holes line 2 Y from line 1 */
    1.625, /* A7: bottom holes line 1 Y from back */
    1.122, /* A8: side holes line 1 Y from back */
    4.0,   /* A9: side holes line 2 Y from line 1 */
    0.25,  /* A10: side holes line Z */
    0.01,
    0.02,
    3.0,   /* A6: bottom holes line 3 Y from line 1 */
    0.138, /* A14: TD for UNC #6 32 */
    1/32,  /* A15: TP for UNC #6 32 */
    0.14   /* A16: TL */
];
SFF8301_A = [ for (i=SFF8301_A_Inch) inch2mm(i) ];
SFF8301_TP  = SFF8301_A[15]; // UNC #6 32 Thread Pitch
SFF8301_A1 = concat(
    [[0,SFF8301_A[1][0]]],
    flatten(
        [    for (i=[1:len(SFF8301_A[1])-1]) let(
                    cur  = SFF8301_A[1][i],
                    prev = SFF8301_A[1][i-1],
                    med  = (cur+prev)/2
               ) [[ med, prev ],  [ med+0.001, cur ]]
        ]
    ),
    [[100,SFF8301_A[1][len(SFF8301_A[1])-1]]]
);

function getDrive35Data()     = SFF8301_A;      // Dimensions in mm
function getDrive35DataInch() = SFF8301_A_Inch; // Dimensions in Inch
function getDrive35TP()       = SFF8301_TP;     // Thread Pitch
// Guess the closest valid height A1
function getDrive35ValidA1(h) = let(hv=is_undef(h)?10:h) lookup(hv, SFF8301_A1);

module drive35Body( height=undef, length=undef ) {
    local_w = SFF8301_A[3];
    local_h = getDrive35ValidA1(height);
    local_l = min(is_undef(length)?SFF8301_A[2]:length, SFF8301_A[2]);
    difference() {
        translate( [0,local_l/2,local_h/2] )
            cube( [local_w, local_l, local_h], center=true );
    }
}
module drive35Connector( height=undef, length=undef ) {
    local_w = SFF8301_A[3];
    local_h = getDrive35ValidA1(height);
    local_l = min(is_undef(length)?SFF8301_A[2]:length, SFF8301_A[2]);
    cnx_o   = 1;
    cnx_l   = 10;
    cnx_h   = local_h/2 - 2*cnx_o;
    cnx_w   = local_w - 2*cnx_o;
    difference() {
        translate( [0,0,cnx_h/2+cnx_o] )
            cube( [cnx_w, cnx_l, cnx_h], center=true );
    }
}
module drive35Hole( length=undef ) {
    tapMin    = SFF8301_A[16];
    tapLength = max(is_undef(length)?tapMin:length,tapMin);
    tapRadius = (SFF8301_A[14]-SFF8301_TP)/2;
    translate( [0,0,tapLength/2] )
        cylinder( r=tapRadius, h=tapLength, center=true );
}
module drive35AlignFront( length ) {
    local_l = min(is_undef(length)?SFF8301_A[2]:length, SFF8301_A[2]);
    translate( [0,local_l,0] )
        rotate( [0,0,180] )
            children();
}
module drive35ForEachBottomHoleLine(y) {
    cloneMirror([1,0,0]) {
        translate( [SFF8301_A[4]/2,y,0] )
            children();
    }
}
module drive35ForEachSideHole() {
    cloneMirror([1,0,0])
    translate( [SFF8301_A[3]/2,0,SFF8301_A[10]] )
    rotate([0,-90,0]) {
        translate( [0,SFF8301_A[8],0] )
            children();
        translate( [0,SFF8301_A[8]+SFF8301_A[9],0] )
            children();
    }
}
module drive35ForEachBottomHole1() {
    drive35ForEachBottomHoleLine(SFF8301_A[7])
        children();
}
module drive35ForEachBottomHole2() {
    drive35ForEachBottomHoleLine(SFF8301_A[7]+SFF8301_A[6])
        children();
}
module drive35ForEachBottomHole3() {
    drive35ForEachBottomHoleLine(SFF8301_A[7]+SFF8301_A[13])
        children();
}
module drive35ForEachBottomHole() {
    drive35ForEachBottomHole1()
        children();
    drive35ForEachBottomHole2()
        children();
    drive35ForEachBottomHole3()
        children();
}
module drive35BottomHoles1( length=undef ) {
    drive35ForEachBottomHole1()
        drive35Hole( length );
}
module drive35BottomHoles2( length=undef ) {
    drive35ForEachBottomHole2()
        drive35Hole( length );
}
module drive35BottomHoles3( length=undef ) {
    drive35ForEachBottomHole3()
        drive35Hole( length );
}
module drive35BottomHoles( length=undef ) {
    drive35ForEachBottomHole()
        drive35Hole( length );
}
module drive35SideHoles( length=undef ) {
    drive35ForEachSideHole()
        drive35Hole( length );
}
module drive35( height=undef, length=undef, thread_l=undef ) {
    difference() {
        drive35Body(height, length);
        drive35Connector(height, length);
#        drive35BottomHoles1(thread_l);
#        drive35BottomHoles2(thread_l);
#        drive35BottomHoles3(thread_l);
#        drive35SideHoles(thread_l);
    }
}



// ----------------------------------------
// 2.5" Drives
// Specifications:
//    SFF-8201
//    2.5" Form Factor Drive Dimensions
//    https://members.snia.org/document/dl/25851
// ----------------------------------------
SFF8201_A = [
    0,      /* A0 */
    [5.00, 7.00, 8.47, 9.50, 10.50, 12.70, 15.00, 17.00, 19.05], /* A1: height */
    0.00,
    0.50, 
    69.85,  /* A4: width */
    0.25,
    100.45, /* A6: maximum length */
    0, 0, 0,
    100.20, /* A10 */
    100.50,
    110.20,
    0, 0, 0, 0, 0, 0, 0, 0, /* A20 */ 0, 0,
    3.0,    /* A23: side holes line Z */
    0, 0,
    3.0,    /* A26: TD side holes */
    0.50,
    4.07,
    61.72,  /* A29: bottom holes X interval */
    34.93,  /* A30 */
    38.10,
    3.0,    /* A32: TD bottom holes */
    0.50,
    0, 0, 0,
    8.0,
    [2.0, 3.0], /* A38: TL side holes [if A1<=7, if A1>7] */
    0, 0,   /* A40 */
    2.50,   /* A41: TL bottom holes */
    0, 0, 0, 0, 0, 0, 0, 0,
    14.0,   /* A50: bottom holes line 1 Y from back */
    90.60,  /* A51: bottom holes line 2 Y from back */
    14.00,  /* A52: side holes line 1 Y from back */
    90.60,  /* A53: side holes line 2 Y from back */
];
SFF8201_A_Inch = [ for (i=SFF8201_A) mm2inch(i) ];
SFF8201_TP = 0.5;
SFF8201_A1 = concat(
    [[0,SFF8201_A[1][0]]],
    flatten(
        [    for (i=[1:len(SFF8201_A[1])-1]) let(
                    cur  = SFF8201_A[1][i],
                    prev = SFF8201_A[1][i-1],
                    med  = (cur+prev)/2
               ) [[ med, prev ],  [ med+0.001, cur ]]
        ]
    ),
    [[100,SFF8201_A[1][len(SFF8201_A[1])-1]]]
);

function getDrive25Data()      = SFF8201_A;      // Dimensions in mm
function getDrive25DataInch()  = SFF8201_A_Inch; // Dimensions in Inch
// Guess the closest valid height A1
function getDrive25ValidA1(h) = let(hv=is_undef(h)?10:h) lookup(hv, SFF8201_A1);

module drive25AlignFront( length ) {
    local_l = min(is_undef(length)?SFF8201_A[6]:length, SFF8201_A[6]);
    translate( [0,local_l,0] )
        rotate( [0,0,180] )
            children();
}
module drive25Connector( height=undef, length=undef ) {
    local_w = SFF8201_A[4];
    local_h = getDrive25ValidA1(height);
    local_l = min(is_undef(length)?SFF8201_A[6]:length, SFF8201_A[6]);
    cnx_o   = 1;
    cnx_l   = 10;
    cnx_h   = local_h/2 - 2*cnx_o;
    cnx_w   = local_w - 2*cnx_o;
    difference() {
        translate( [0,0,cnx_h/2+cnx_o] )
            cube( [cnx_w, cnx_l, cnx_h], center=true );
    }
}
module drive25Body( height=undef, length=undef ) {
    local_w = SFF8201_A[4];
    local_h = getDrive25ValidA1(height);
    local_l = min(is_undef(length)?SFF8201_A[6]:length, SFF8201_A[6]);
    difference() {
        translate( [0,local_l/2,local_h/2] )
            cube( [local_w, local_l, local_h], center=true );
    }
}
module drive25BottomHole( length=undef ) {
    tapMin    = SFF8201_A[41];
    tapLength = max(is_undef(length)?tapMin:length,tapMin);
    tapRadius = (SFF8201_A[32]-SFF8201_TP)/2;
    translate( [0,0,tapLength/2] )
        cylinder( r=tapRadius, h=tapLength, center=true );
}
module drive25SideHole( length=undef, height=undef ) {
    local_h = getDrive25ValidA1(height);
    tapMin    = local_h<=7 ? SFF8201_A[38][0] : SFF8201_A[38][1] ;
    tapLength = max(is_undef(length)?tapMin:length,tapMin);
    tapRadius = (SFF8201_A[26]-SFF8201_TP)/2;
    translate( [0,0,-tapLength/2] )
        cylinder( r=tapRadius, h=tapLength, center=true );
}
module drive25ForEachBottomHole() {
    cloneMirror([1,0,0]) {
        translate( [SFF8201_A[29]/2,SFF8201_A[50],0] )
            children();
        translate( [SFF8201_A[29]/2,SFF8201_A[51],0] )
            children();
    }
}
module drive25ForEachSideHole() {
    cloneMirror([1,0,0])
    translate( [SFF8201_A[4]/2,0,SFF8201_A[23]] )
    rotate([0,90,0])
    {
        translate( [0,SFF8201_A[52],0] )
            children();
        translate( [0,SFF8201_A[53],0] )
            children();
    }
}
module drive25BottomHoles( length=undef ) {
    drive25ForEachBottomHole()
        drive25BottomHole(length);
}
module drive25SideHoles( length=undef, height=undef ) {
    drive25ForEachSideHole()
        drive25SideHole( length, height );
}
module drive25( height=undef, length=undef, thread_l=undef ) {
    difference() {
        drive25Body(height, length);
        drive25Connector(height, length);
#        drive25BottomHoles(thread_l);
#        drive25SideHoles(thread_l, height);
    }
}

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

translate( [0, 150, 0] ) {
    drive525(30,$fn=PRECISION);
}
translate( [170, 150, 0] ) {
    drive35AlignFront()
    drive35($fn=PRECISION);
}
translate( [300, 150, 0] ) {
    drive25AlignFront()
    drive25($fn=PRECISION);
}
