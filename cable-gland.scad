/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Cable glands modelisation
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <agentscad/bevel.scad>
use <agentscad/electronic.scad>
use <agentscad/hardware.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// cable: Cable (@see electronic.scad)
//   zip: [Optional] Zip Tie object to tighten the cable (@see hardware.scad)
//    sx: [Optional] Force external cable gland size on X
//    sy: [Optional] Force external cable gland size on Y
//    sz: [Optional] Force external cable gland size on Z
//    wt: [Optional] Wall thickness
function newCableGland (
    cable, zip=undef,
    sx=undef, sy=undef, sz=undef,
    wt=CABLE_GLAND_WT
) = let(
    l_ci  = getCableI(cable),
    l_cd  = 2*getCableR(cable),
    l_cw  = l_ci+l_cd,
    l_zr  = is_undef(zip) ? l_cd/2 : sqrt(
        pow(l_cd/2+getZipTieHh(zip)+2*gap(),2) + pow(getZipTieHl(zip)/2,2) ),
    l_zw  = l_ci+2*l_zr,
    l_zl  = is_undef(zip) ? 0 : getZipTieHw(zip)+2*gap(),
    l_zh  = 2*l_zr,
    l_l   = is_undef(sx) ? l_zl+wt : sx,
    l_w   = is_undef(sy) ? l_zw+2*wt : sy,
    l_h   = is_undef(sz) ? l_zh+2*wt : sz,
    l_zip = is_undef(zip) ? undef : makeZipOblong(zip,getCableR(cable),getCableI(cable))
) [ cable, wt, l_zip, l_cw, l_zr, l_zw, l_zl, l_zh, l_l, l_w, l_h ];
function getCableGlandL(g)    = g[IC_L];
function getCableGlandW(g)    = g[IC_W];
function getCableGlandH(g)    = g[IC_H];

module cableGlandCube ( gland ) {
    wt = gland[IC_WT];
    sx = gland[IC_L];  
    sy = gland[IC_W];
    sz = gland[IC_H];
    difference() {
        cableGlandCubeShape ( gland );
        cableGlandCubeHollow( gland );
        cableGlandCubeBevel ( gland );
    }
    cableGlandCubeShow ( gland );
}

module cableGlandCubeShape ( gland ) {
    alignOnVector ( getCableV(gland[IC_C]) )
        translate( [0,0,gland[IC_L]/2 ] )
        cube( [ gland[IC_H], gland[IC_W], gland[IC_L] ], center=true );
}
module cableGlandCubeShow ( gland ) {
    %
    alignOnVector ( getCableV(gland[IC_C]) )
        translate( [-getCableC(gland[IC_C]).z, getCableC(gland[IC_C]).y, gland[IC_ZL]/2 ] )
        zipShape ( gland[IC_ZIP] );
}
module cableGlandCubeHollow ( gland ) {
    wt = gland[IC_WT];
    sx = gland[IC_L];
    z  = gland[IC_H];
    zh = gland[IC_ZL];
    ch = sx-zh;
    alignOnVector ( getCableV(gland[IC_C]) ) {
        translate( [-getCableC(gland[IC_C]).z, getCableC(gland[IC_C]).y, -zh/2+gland[IC_ZL]-mfg() ] )
            oblong( r=gland[IC_ZR], h=zh+2*mfg(), i=getCableI(gland[IC_C]), center=true );
        translate( [-getCableC(gland[IC_C]).z, getCableC(gland[IC_C]).y, sx-ch/2 ] )
            oblong( r=getCableR(gland[IC_C]), h=ch+2*mfg(), i=getCableI(gland[IC_C]), center=true );
    }
}
module cableGlandCubeBevel ( gland ) {
    alignOnVector ( getCableV(gland[IC_C]) ) {
        translate( [0,-gland[IC_W]/2,gland[IC_L] ] )
            rotate( [0,-90,0] )
            bevelCutLinear( gland[IC_W], gland[IC_H] );
        translate( [gland[IC_H]/2,0,gland[IC_L] ] )
            rotate( [0,-90,0] )
            rotate( [90,0,0] )
            bevelCutLinear( gland[IC_H], gland[IC_W] );
        cloneMirror([0,1,0])
            translate( [0,-gland[IC_W]/2,0 ] )
            rotate( [0,-90,0] )
            rotate( [0,0,-90] )
            bevelCutLinear( gland[IC_L], gland[IC_H] );
    }
}

// ----------------------------------------
//             Implementation
// ----------------------------------------
CABLE_GLAND_WT = 1.2;

IC_C       = 0;
IC_WT      = 1;
IC_ZIP     = 2;
IC_CW      = 3;  // Cable width
IC_ZR      = 4;  // Radius of zip passage
IC_ZW      = 5;  // Width of zip passage
IC_ZL      = 6;  // Length of zip passage
IC_ZH      = 7;  // Height of zip passage
IC_L       = 8;  // Cable Gland Length
IC_W       = 9;  // Cable Gland Width
IC_H       = 10; // Cable Gland Height

// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 100;
SEPARATION = 0;

module show_parts( part=0, cut=undef, cut_rotation=undef ) {
    zip   = newZipTie2_5();
    gland = newCableGland( newCable(3/2, 3, c=[0,6,2], v=[1,1,0]), zip=zip, sz=20, wt=10 );
    if ( part==0 ) {
        intersection () {
            union() {
                cableGlandCube ( gland );
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    if ( part==1 ) {
        cableGlandCube(gland);
    }
}

// 0: all
// 1: cable gland cube
show_parts ( 1, 0, -60, $fn=PRECISION );
