/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Box for HW411 pcb module (LM2596 DC-DC step down)
 *              http://tpelectronic.ir/datasheets/20150123144301750.pdf
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
PRECISION  = 100;
SEPARATION = 0;
CABLE_D    = 3;

SCREW = M2_5(tl=16, ahd=5) ;
HW411 = newPcb (
            sx=44, sy=22,
            holes=[
                [-15, +7.5, SCREW ],
                [+15, -7.5, SCREW ]
            ]
        );
ZIP_TIE_CABLE = newZipTie2_5();
ZIP_TIE_BOX   = makeZipU(newZipTie2_5(),7.4,4);

module show_parts( part=0, cut=undef, cut_rotation=undef ) {
    draftbox = newBoxShell ( bsz=8 );
    cables = [
         newCable ( CABLE_D/2, CABLE_D, c=[0,0,0], v=[+1,0,0] )
        ,newCable ( CABLE_D/2, CABLE_D, c=[0,0,0], v=[-1,0,0] )
    ];
    box = newPcbBox (
        pcb          = HW411,
        shell        = draftbox,
        cables       = cables,
        cablezip     = ZIP_TIE_CABLE,
        boxzip       = ZIP_TIE_BOX,
        margin       = nozzle(),
        incrustation = 3
    );

    if ( part==0 ) {
        intersection () {
            union() {
                translate( [0,0,+SEPARATION] )
                    pcbBoxTop( box );
                translate( [0,0,-SEPARATION] )
                    pcbBoxBottom( box );
                %
                translate ( getPcbBoxPcbTranslation(box) )
                    pcbShape ( getPcbBoxPcb(box) );
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    if ( part==1 ) {
        pcbBoxBottom( box );
    }
    if ( part==2 ) {
        rotate( [180,0,0] ) {
            pcbBoxTop( box );
        }
    }
    if ( part==3 ) {
        translate( [0,30,0])
            pcbBoxBottom( box );
        translate( [0,-30,0])
            rotate( [180,0,0] ) {
                pcbBoxTop( box );
            }
    }
}

// 0: all cut to see inside
// 1: bottom
// 2: top
// 3: top+bottom printables
show_parts ( 3, 0, 0, $fn=PRECISION );

