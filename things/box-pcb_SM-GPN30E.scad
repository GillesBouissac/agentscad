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

SCREW = M3(tl=30, ahd=5) ;
PCB = newPcb (
            sx=100, sy=50, above=26,
            holes=[
                [-81/2, +20, SCREW ],
                [-81/2, -20, SCREW ],
                [+81/2, -20, SCREW ],
                [+81/2, +20, SCREW ]
            ]
        );
ZIP_TIE_CABLE = newZipTie2_5();
ZIP_TIE_BOX   = makeZipU(newZipTie2_5(),7.4,4);

module vents ( sx, sy, wt=1, sp=1 ) {
    nb = floor(sy+sp)/(wt+sp);
    aw = nb*(wt+sp)-sp;

    for ( i=[0:nb-1] )
        translate( [0,-aw/2+i*(wt+sp),500] ) {
            cube( [sx-wt,wt,1000], center=true );
            translate( [-sx/2+wt/2,0,0] )
                cylinder ( r=wt/2, h=1000, center=true );
            translate( [+sx/2-wt/2,0,0] )
                cylinder ( r=wt/2, h=1000, center=true );
        }
}

module top_with_vents ( box ) {
    difference() {
        pcbBoxTop( box );

        translate ( [50-40,0,0] ) {
            translate ( [0,0,4.5] )
            rotate( [90,90,0] )
                vents( 18, 17 );
            translate ( [0,-25+11,0] )
                vents( 18, 18 );
        }

        translate ( [-50+28,0,0] ) {
            translate ( [0,0,4.5] )
            rotate( [90,90,0] )
                vents( 18, 20 );
            translate ( [0,-25+12,0] )
                vents( 22, 20 );
        }
    }
}

module show_box() {
    draftbox = newBoxShell ( bsz=8 );
    cables = [
         newCable ( CABLE_D/2, CABLE_D, c=[0,0,0], v=[+1,0,0] )
        ,newCable ( CABLE_D/2, CABLE_D, c=[0,0,0], v=[-1,0,0] )
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

