/*
 * Copyright (c) 2020, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 2"5 or 3"5 HDD drive to 5"25 CD Drive adapter
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <agentscad/electronic.scad>

// ----------------------------------------
//              Implementation
// ----------------------------------------

525_A = getDrive525Data();
35_A  = getDrive35Data();
25_A  = getDrive25Data();

ADAPTER_W    = 525_A[5];
ADAPTER_L    = 525_A[11]+2*20;
ADAPTER_H    = 525_A[1]-10;
ADAPTER_Y    = 20;
WALL_T       = 3;
FLANGE_H    = 1;
FLANGE_D    = 10;
HOLES_NB_I   = 5;
SIDE_HOLES_I = 525_A[11]/HOLES_NB_I;
ADAPTER_IN_X = ADAPTER_W-2*WALL_T;
ADAPTER_IN_Y = ADAPTER_L;
ADAPTER_IN_Z = 2*ADAPTER_H;

CELL_D       = 12;
CELL_R       = CELL_D/2;
CELL_l       = 2*CELL_R*sin(30);
CELL_W       = 2*CELL_R*cos(30);
CELL_T       = 4;
CELL_IX      = CELL_D+CELL_l;
CELL_IY      = CELL_W;
CELL_NBX     = floor((ADAPTER_IN_X-CELL_l)/CELL_IX);
CELL_NBY     = floor((ADAPTER_IN_Y-CELL_W)/CELL_IY);
HONEY_X      = CELL_NBX*CELL_IX;
HONEY_Y      = CELL_NBY*CELL_IY;

module adapterAlign() {
    translate([0,525_A[10]+525_A[11]/2,0])
        children();
}
module drive25Align() {
    translate([0,-25_A[6]+ADAPTER_L/2,0])
    drive25AlignFront()
        children();
}
module drive35Align() {
    translate([0,-35_A[2]/2,0])
    drive35AlignFront()
        children();
}
module honeycombCell() {
    difference() {
        cylinder( r=CELL_R+CELL_T/2, h=WALL_T, center=true, $fn=6 );
        cylinder( r=CELL_R-CELL_T/2, h=2*WALL_T, center=true, $fn=6 );
    }
}
module honeycombLine() {
    for (i=[0:CELL_NBX])
        translate( [i*CELL_IX-HONEY_X/2,0,0] )
            honeycombCell();
}
module honeycomb() {
    for (i=[0:2*CELL_NBY])
        translate( [(i%2)*CELL_IX/2,i*CELL_IY/2-HONEY_Y/2,0] )
            honeycombLine();
}
module adapterShape() {
    cube( [ ADAPTER_W, ADAPTER_L, ADAPTER_H ], center=true );
}
module adapterInside() {
    cube( [
        ADAPTER_IN_X,
        ADAPTER_IN_Y+2*gap(),
        ADAPTER_IN_Z
    ], center=true );
}
module adapterSolid() {
    adapterAlign() {
        translate([0,0,ADAPTER_H/2])
        difference() {
            adapterShape();
            translate([0,0,WALL_T/2])
            adapterInside();
        }
        translate([0,0,ADAPTER_H/2])
        intersection() {
            translate( [0,0,-ADAPTER_H/2+WALL_T/2] )
                honeycomb();
            adapterInside();
        }
        drive25Align()
            drive25Flanges();
        drive35Align()
            drive35Flanges();
    }
}
module drive525Passage() {
    // SFF8551 says: 2 threads (pitch) minimum
    length = WALL_T+mfg(2);
    radius = getDrive525TD()/2+gap();
    translate( [0,0,length/2-mfg(1)] )
        cylinder( r=radius, h=length, center=true );
}
module drive25Flanges() {
    drive25ForEachBottomHole()
        cylinder(r=FLANGE_D/2, h=WALL_T+FLANGE_H);
}
module drive25Passage() {
    length = WALL_T+FLANGE_H+mfg(2);
    radius = 25_A[32]/2+gap();
    drive25Align()
    drive25ForEachBottomHole()
    translate( [0,0,length/2-mfg(1)] )
        cylinder( r=radius, h=length, center=true );
}
module drive35Flanges() {
    drive35ForEachBottomHole()
        cylinder(r=FLANGE_D/2, h=WALL_T+FLANGE_H);
}
module drive35Passage() {
    length = WALL_T+FLANGE_H+mfg(2);
    radius = 35_A[14]/2+gap();
    drive35Align()
    drive35ForEachBottomHole()
    translate( [0,0,length/2-mfg(1)] )
        cylinder( r=radius, h=length, center=true );
}

module adapterHollow() {
    for ( i=[0:HOLES_NB_I] )
        translate ([0,(i-HOLES_NB_I/2)*SIDE_HOLES_I,0]) {
            drive525ForEachSideUpperHole()
                drive525Passage();
            drive525ForEachSideLowerHole()
                drive525Passage();
        }
    adapterAlign()
        drive25Passage();
    adapterAlign()
        drive35Passage();
}

module adapter() {
    difference() {
        adapterSolid();
        adapterHollow();
    }
}

// ----------------------------------------
//                Showcase
// ----------------------------------------

module showDrive525() {
    %drive525();
}

module showScrew() {
    translate( [0,0,-20] ) {
        cylinder(r=1.5,h=5,center=true);
        translate( [0,0,-3.0] )
        cylinder(r=3,h=3,center=true);
        translate( [0,0,9] )
        cylinder(r=0.1,h=10,center=true);
    }
}

module showDrive35() {
    %
    color("green", 0.8)
    translate([0,0,WALL_T+FLANGE_H])
    adapterAlign()
    drive35Align() {
        drive35();
        drive35ForEachBottomHole()
            showScrew();
    }
}

module showDrive25() {
    %
    color("blue", 0.8)
    translate([0,0,WALL_T+FLANGE_H])
    adapterAlign()
    drive25Align() {
        drive25($fn=100);
        drive25ForEachBottomHole()
            showScrew();
    }
}

adapter($fn=100);
*showDrive525($fn=100);
*showDrive35($fn=100);
showDrive25($fn=100);

