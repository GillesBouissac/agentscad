/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Box for ZC255800+MP1584EN pcb modules
 *      ZC255800: AC-DC power supply 5W 240V/12V (0.450 mA)
 *      MP1584EN: DC-DC Step down board 12V to approx 0.8V-7V variable (3A)
 *
 * Author:      Gilles Bouissac
 */

use <agentscad/printing.scad>
use <agentscad/mx-screw.scad>
use <agentscad/electronic.scad>
use <agentscad/hardware.scad>
use <agentscad/box-shell.scad>
use <agentscad/box-pcb.scad>

// ----------------------------------------
//             Implementation
// ----------------------------------------
PRECISION  = 50;
SEPARATION = 0;
CABLE_D    = 3.5;

SCREW = M2_5(tl=14) ;

// AC-DC Converter board
ZC255800_X = 31;
ZC255800_Y = 21;
ZC255800_A = 9;
ZC255800_B = 17-ZC255800_A;

// DC-DC Step down board
MP1584EN_X = 23;
MP1584EN_Y = 17;
MP1584EN_Z = 7;
MP1584EN_POT_X = 7.5;
MP1584EN_POT_Y = 2.2;
MP1584EN_POT_D = 1.5;
MP1584EN_PCB_T = 1.6;

PCB_SEP    = 1;

SCREW_STAND_D = 8.1;

PCB_X      = ZC255800_X+2*SCREW_STAND_D;
PCB_Y      = ZC255800_Y+PCB_SEP+MP1584EN_Z;
PCB = newPcb (
            sx=PCB_X,
            sy=PCB_Y,
            t=0, // Not really a PCB
            below=ZC255800_B,
            above=ZC255800_A,
            holes=[
                 [ +(PCB_X-SCREW_STAND_D)/2, +(PCB_Y-SCREW_STAND_D)/2, SCREW ]
                ,[ -(PCB_X-SCREW_STAND_D)/2, +(PCB_Y-SCREW_STAND_D)/2, SCREW ]
                ,[ +(PCB_X-SCREW_STAND_D)/2, -(PCB_Y-SCREW_STAND_D)/2, SCREW ]
                ,[ -(PCB_X-SCREW_STAND_D)/2, -(PCB_Y-SCREW_STAND_D)/2, SCREW ]
            ]
        );
ZIP_TIE_CABLE = newZipTie2_5();

module vents ( sx, sy, wt=0.8, sp=1.2 ) {
    int = wt+sp;
    nb  = floor((sy-wt)/int);
    aw  = nb*int + wt;
    off = (sy-aw+wt)/2;

    for ( i=[0:nb] )
        translate( [0,-sy/2+off+i*int,500] ) {
            efsx = i==0 ? sx-2*int : i==nb ? sx-2*int : sx;
            cube( [efsx-wt,wt,1000], center=true );
            translate( [-efsx/2+wt/2,0,0] )
                cylinder ( r=wt/2, h=1000, center=true );
            translate( [+efsx/2-wt/2,0,0] )
                cylinder ( r=wt/2, h=1000, center=true );
        }
}

module topWithVents ( box ) {
    difference() {
        pcbBoxTop( box );

        // Vent for everything to breathe (no heatsink on this board)
        translate ( [0,0,0] )
            vents( 18, 18 );
    }
}

module botWithVerticalHolder ( box ) {
    l   = MP1584EN_X;
    h   = MP1584EN_Y;
    w   = PCB_SEP;
    pcb = getPcbBoxPcb(box);
    mrg = getPcbBoxMargin(box);

    offsets = [
        -(getPcbSx(pcb)-l)/2,
        -getPcbSy(pcb)/2 - mrg.y + MP1584EN_Z/2,
        -getPcbSz(pcb)/2 - mrg.z
    ];

    difference() {
        pcbBoxBottom( box );

        // MP1584EN potentiometer access
        translate( [
            offsets.x + l - MP1584EN_POT_X,
            offsets.y + 1/2,
            offsets.z + MP1584EN_POT_Y] )
        rotate( [90,0,0] )
        cylinder( r=MP1584EN_POT_D/2+gap(), h=100 );
    }

    // PCB separation
    translate( [
        offsets.x + l/2,
        offsets.y + 1/2 + MP1584EN_Z/2,
        offsets.z + h/2] )
    cube( [l,w,h], center=true ) ;

    difference() {
        ws = MP1584EN_X-21;
        union() {
            // MP1584EN back stopper
            translate( [
                offsets.x,
                offsets.y + 1/2,
                offsets.z + h/4] )
            cube( [ws,MP1584EN_Z+1,h/2], center=true ) ;

            // MP1584EN front stopper
            translate( [
                offsets.x + l,
                offsets.y + 1/2+1.25,
                offsets.z + 5/2] )
            cube( [ws,MP1584EN_Z-1.5,5], center=true ) ;
        }
        // MP1584EN PCB passage
#
        translate( [
            offsets.x + l/2,
            offsets.y + MP1584EN_Z/2 - MP1584EN_PCB_T/2 - 2,
            offsets.z + MP1584EN_Y/2] )
        cube( [l,MP1584EN_PCB_T+0.2,h], center=true ) ;
    }
}

module show_box() {
    // The draft controls the base parameters of the enclosing box shell
    // bsz forced to have the box joint at 10mm height, ie not in components
    draftbox = newBoxShell ( bsz=10 );
    cables = [
         newCable ( CABLE_D/2, CABLE_D, c=[0,0,-2], v=[+1,0,0] )
        ,newCable ( CABLE_D/2, CABLE_D, c=[0,0,+2], v=[-1,0,0] )
    ];
    box = newPcbBox (
        pcb          = PCB,
        shell        = draftbox,
        cables       = cables,
        cablezip     = ZIP_TIE_CABLE,
        boxzip       = undef,
        margin       = [nozzle(),nozzle(),0],
        incrustation = 3
    );
    echo( getPcbBoxShell(box) );
    translate( [0,30,0]) {
        botWithVerticalHolder ( box );
    }
    translate( [0,-30,0])
        rotate( [180,0,0] )
            topWithVents( box );
}

show_box ( $fn=PRECISION );

