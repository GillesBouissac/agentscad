/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Screw stands library
 * Author:      Gilles Bouissac
 */

use <agentscad/printing.scad>
use <agentscad/mx-screw.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// x:  hole x position from center
// y:  hole y position from center
// s:  screw (ex: M3())
// l:  total length of head and drill stands
// d:  drill stand length 
// h:  hollow between top and bottom stands (default: h=gap())
// i:  incrusted length of head in its stand
// t:  stands thickness
// o:  orientation (default top->down, see standOrientation... functions )
function newScrewStand ( x, y, s, l, d, h=undef, i=0, t=WALL_T, o=undef ) =
let (
    hollow = is_undef(h)?gap():h,
    lhead  = l-d-hollow,
    lo     = is_undef(o)?O_TD:o
) [ x, y, s, l, d, lhead, hollow, i, t, lo ];
IS_X     = 0;
IS_Y     = 1;
IS_S     = 2;
IS_L     = 3;
IS_LD    = 4;
IS_LH    = 5;
IS_H     = 6;
IS_I     = 7;
IS_T     = 8;
IS_O     = 9;
O_TD     = 0; // Orientation Top->Down
O_DT     = 1; // Orientation Down->Top

function getScrewStandX(p)         = p[IS_X];
function getScrewStandY(p)         = p[IS_Y];
function getScrewStandScrew(p)     = p[IS_S];
function getScrewStandL(p)         = p[IS_L];
function getScrewStandLD(p)        = p[IS_LD];
function getScrewStandLH(p)        = p[IS_LH];
function getScrewStandH(p)         = p[IS_H];
function getScrewStandI(p)         = p[IS_I];
function getScrewStandT(p)         = p[IS_T];
function getScrewStandO(p)         = p[IS_O];
function standOrientationTopDown() = O_TD;
function standOrientationDownTop() = O_DT;

// Screw head stand
module screwStandHead ( params ) {
    difference() {
        screwStandHeadShape ( params );
        screwStandHeadHollow ( params );
    }
}
// Screw drill stand
module screwStandDrill ( params ) {
    difference() {
        screwStandDrillShape ( params );
        screwStandDrillHollow ( params );
    }
}

module screwStandHeadShape ( params ) {
    stands = is_num(params[0]) ? [params] : params ;
    for ( stand=stands ) {
        translate( [stand[IS_X],stand[IS_Y],stand[IS_L]/2] )
        rotate( [stand[IS_O]==O_DT?180:0,0,0] )
        translate( [0,0,stand[IS_L]/2] )
        {
            scale( [1,1,-1] )
            cylinder(
                r=mxGetAllenHeadD(stand[IS_S])/2+gap()+stand[IS_T],
                h=stand[IS_T]+stand[IS_I]
            );
            scale( [1,1,-1] )
            cylinder(
                r=mxGetThreadDP(stand[IS_S])/2+stand[IS_T],
                h=stand[IS_LH]
            );
        }
    }
}
module screwStandHeadHollow( params ) {
    screwStandBoltHollow ( params );
}

module screwStandDrillShape ( params ) {
    stands = is_num(params[0]) ? [params] : params ;
    for (stand=stands) {
        translate( [stand[IS_X],stand[IS_Y],stand[IS_L]/2] )
        rotate( [stand[IS_O]==O_DT?180:0,0,0] )
        translate( [0,0,-stand[IS_L]/2] )
            cylinder( r=mxGetThreadDP(stand[IS_S])/2+stand[IS_T], h=stand[IS_LD] );
    }
}
module screwStandDrillHollow ( params ) {
    screwStandBoltHollow ( params );
}

// ----------------------------------------
//             Implementation
// ---------------------------------------
WALL_T = 1.2;

module screwStandBoltHollow ( params ) {
    stands = is_num(params[0]) ? [params] : params ;
    for (stand=stands) {
        translate( [stand[IS_X],stand[IS_Y],stand[IS_L]/2] )
        rotate( [stand[IS_O]==O_DT?180:0,0,0] )
        translate( [0,0,stand[IS_L]/2-stand[IS_I]] )
            scale( [1,1,-1] )
            mxBoltAllenPassage(mxClone(stand[IS_S],tlp=stand[IS_LH]-stand[IS_I]));
    }
}


// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 100;
SEPARATION = 0;

module showScrewStands( part=0, cut=undef, cut_rotation=undef ) {
    screw = M3(tl=16);
    stands = [
        newScrewStand ( -10, -5, screw, 20, 4, i=1, h=0.4 ),
        newScrewStand ( -20, -5, screw, 20, 4, i=1, h=0.4, o=standOrientationDownTop() ),
        newScrewStand ( -10, +5, screw, 20, 9, i=1, h=5 ),
        newScrewStand ( -20, +5, screw, 20, 9, i=1, h=5, o=standOrientationDownTop() ),
        newScrewStand ( +10, +5, mxClone(screw,tl=10), 30, 12, i=1, h=0.4 ),
        newScrewStand ( +20, +5, mxClone(screw,tl=10), 30, 12, i=1, h=0.4, o=standOrientationDownTop() )
    ];

    if ( part==0 ) {
        intersection () {
            union() {
                screwStandHead  ( stands );
                screwStandDrill ( stands );
                %screwStandBoltHollow ( stands );
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    if ( part==1 ) {
        screwStandDrill( stands );
    }
    if ( part==2 ) {
        screwStandHead( stands );
    }
}

// 0: all
// 1: drill stand
// 2: head stand
showScrewStands ( 0, undef, 0, $fn=PRECISION );

