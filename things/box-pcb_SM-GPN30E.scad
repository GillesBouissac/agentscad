/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Box for SM-GPN30E pcb module (AC-DC power supply 30W / 5-36V)
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

SCREW = M3(tl=20, ahd=5) ;
PCB = newPcb (
            sx=100, sy=50, below=4, above=26,
            holes=[
                [-81/2, +20, SCREW ],
                [-81/2, -20, SCREW ],
                [+81/2, -20, SCREW ],
                [+81/2, +20, SCREW ]
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

module top_with_vents ( box ) {
    difference() {
        pcbBoxTop( box );

        // Vent for 7N65C Mosfet heatsink
        translate ( [50-40,0,0] ) {
            translate ( [0,0,5.5] )
            rotate( [90,90,0] )
                vents( 16, 18 );
            translate ( [0,-25+11,0] )
                vents( 18, 18 );
        }

        // Vent for MBR20100F Schottky Barrier heatsink
        translate ( [-50+28,0,0] ) {
            translate ( [0,0,5.5] )
            rotate( [90,90,0] )
                vents( 16, 22 );
            translate ( [0,-25+12,0] )
                vents( 22, 20 );
        }
    }
}

module show_box() {
    // The draft controls the base parameters of the enclosing box shell
    // bsz forced to have the box joint at 10mm height, ie not in components
    // t forced because this is a relative big box, one more layer bot and top is better
    draftbox = newBoxShell ( bsz=10, t=1.2 );
    cables = [
         newCable ( CABLE_D/2, CABLE_D, c=[0,0,-5], v=[+1,0,0] )
        ,newCable ( CABLE_D/2, CABLE_D, c=[0,0,+5], v=[-1,0,0] )
    ];
    box = newPcbBox (
        pcb          = PCB,
        shell        = draftbox,
        cables       = cables,
        cablezip     = ZIP_TIE_CABLE,
        boxzip       = undef,
        margin       = nozzle(),
        incrustation = 3
    );
    translate( [0,30,0])
        pcbBoxBottom( box );
    translate( [0,-30,0])
        rotate( [180,0,0] ) {
            top_with_vents( box );
        }
}

show_box ( $fn=PRECISION );

