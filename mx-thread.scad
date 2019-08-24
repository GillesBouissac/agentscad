/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Metric screw thread modelisation
 * Author:      Gilles Bouissac
 */
use <scad-utils/lists.scad>
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <mx-screw.scad>
use <printing.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------
module mxThreadExternal ( screw, l=-1, t=-1 ) {
    local_l   = l<0 ? mxGetThreadL(screw): l;
    rotations = local_l / mxGetPitch(screw);
    profile = mxThreadProfile ( screw, I=false );
    rotate([0,-90,0])
        skin( mxThreadSlices(profile, mxGetPitch(screw), rotations) );
}

module mxThreadInternal ( screw, l=-1, t=-1 ) {
    local_l   = l<0 ? mxGetThreadL(screw): l;
    rotations = local_l / mxGetPitch(screw);
    profile = mxThreadProfile ( screw, I=true );
    rotate([0,-90,0])
        skin( mxThreadSlices(profile, mxGetPitch(screw), rotations) );
}

module mxNutHexagonalThreaded( screw ) {
    length = mxGetHexagonalHeadL(screw)+2*mxGetPitch(screw);
    clipL = length-2*mxGetPitch(screw);
    clipW = mxGetThreadD(screw)+10;
    intersection() {
        union() {
            translate([0,0,-mxGetPitch(screw)])
                mxThreadInternal ( screw, length );
        }
        translate([0,0,clipL/2])
            cube([clipW, clipW, clipL],center=true);
    }
    difference() {
        mxNutHexagonal(screw);
        mxBoltPassage(screw,clipL);
    }
}

module mxNutSquareThreaded( screw ) {
    length = mxGetSquareHeadL(screw)+2*mxGetPitch(screw);
    clipL = length-2*mxGetPitch(screw);
    clipW = mxGetThreadD(screw)+10;
    intersection() {
        union() {
            translate([0,0,-mxGetPitch(screw)])
                mxThreadInternal ( screw, length );
        }
        translate([0,0,clipL/2])
            cube([clipW, clipW, clipL],center=true);
    }
    difference() {
        mxNutSquare(screw);
        mxBoltPassage(screw,clipL);
    }
}

module mxBoltHexagonalThreaded( screw, length=-1 ) {
    local_l = length<0 ? mxGetThreadL(screw): length;
    clipL = local_l-2*mxGetPitch(screw);
    clipW = mxGetThreadD(screw)+10;
    intersection() {
        union() {
            translate([0,0,-mxGetPitch(screw)])
                mxThreadExternal ( screw, local_l );
        }
        translate([0,0,clipL/2])
            cube([clipW, clipW, clipL],center=true);
    }
    translate([0,0,-MFG])
        mxBoltHexagonal(screw,0);
}

module mxBoltAllenThreaded( screw, length=-1 ) {
    local_l = length<0 ? mxGetThreadL(screw): length;
    clipL = local_l-2*mxGetPitch(screw);
    clipW = mxGetThreadD(screw)+10;
    intersection() {
        union() {
            translate([0,0,-mxGetPitch(screw)])
                mxThreadExternal ( screw, local_l );
        }
        translate([0,0,clipL/2])
            cube([clipW, clipW, clipL],center=true);
    }
    translate([0,0,0-MFG])
        mxBoltAllen(screw,0);
}

// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------
MFG     = 0.001;
MXANGLE = 60;

// Metric screw profile is well defined by wikipedia:
//   https://en.wikipedia.org/wiki/ISO_metric_screw_thread
//
// T: Optional Thickness of the cylinder holding internal thread (default: NOZZLE)
// I: Optional Internal (nut) profile if true, External (bolt) if false (default), 
function mxThreadProfile( data, t=-1, I=false ) =
    let (
        Theta  = mxGetFlankAngle(data)/2,
        p      = mxGetPitch(data),
        delta  = I ? +gap() : -gap(1/2),
        Rmaj   = mxGetFunctionalRadiuses(data)[1] + delta,
        Rmin   = mxGetFunctionalRadiuses(data)[0] + delta,
        RBot   = mxGetGlobalRadiuses(data)[0],
        Fmin   = mxGetFlatHalfLenght(data)[0],
        Fmaj   = mxGetFlatHalfLenght(data)[1],
        RRmin  = mxGetSmoothRadiuses(data)[0],
        RRmaj  = mxGetSmoothRadiuses(data)[1],
        Cmino  = mxGetSmoothCenters(data)[0],
        Cmajo  = mxGetSmoothCenters(data)[1],
        Cmin   = [Cmino.x,Cmino.y+delta],
        Cmaj   = [Cmajo.x,Cmajo.y+delta],

        Tmin   = (Rmin-RBot)+nozzle(1.5),
        Tloc   = (t<Tmin ? Tmin : t)
    )
    I ?
        flatten([
            [ [0+MFG,Rmaj+Tloc] ],
            [
                [ 0+MFG,      Rmin ],
                [ 2*Fmin,     Rmin ]
            ],
            mxThreadRounding( RRmaj, Cmaj, +(180-Theta), +(Theta) ),
            [ [ p, Rmin ], [ p, Rmaj+Tloc ] ]
        ])
    :
        flatten([
            [ [0+MFG,0+MFG] ],
            mxThreadRounding( RRmin, Cmin, -(180-Theta), -(Theta) ),
            [
                [ Fmin+p/2-Fmaj, Rmaj ],
                [ Fmin+p/2+Fmaj, Rmaj ],
            ],
            [ [ p, Rmin ], [ p, 0+MFG ] ]
        ])
    ;
function mxThreadRounding( R, C, T1, T2) = [
    let ( range=T2-T1, step=range/($fn<10?1:$fn/10) )
    for ( a=[T1:step:T2] )
        [ C.x+R*cos(a), C.y+R*sin(a) ]
];
function mxThreadSlices( profile, pitch, rotations=1 ) = [
    let ( step=360/($fn<3?3:$fn) )
    for ( a=[-step/2:step:rotations*360-step/2] )
        transform(translation([a*pitch/360,0,0])*rotation([a,0,0]), profile )
];

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

$fn=50;

// Test thread profile
if (0) {
    !union() {
        polygon ( mxThreadProfile ( M5(), 1, I=false, $gap=0.01 ) );
        polygon ( mxThreadProfile ( M5(), 1, I=true,  $gap=0.01 ) );
    }
}

if (0) {
    // Can be printed with any printer settings :)
    screw  = M64();
*    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw);
*    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw);
*    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw);
}

if (1) {
    // Successfuly printed with 0.2mm layers and 0.4 nozzle on MK3S
    screw  = M6();
*    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw);
*    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw);
*    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw);
}

if (0) {
    // Successfuly printed with 0.1mm layers and 0.4 nozzle on MK3S
    screw  = M4();
*    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw,  $gap=0.15);
*    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw,     $gap=0.15);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw, $gap=0.15);
*    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw,     $gap=0.15);
}

if (0) {
    // Didn't manage to print this one with 0.1mm layers and 0.4 nozzle
    // Pitch is 0.5 too close to 0.4, need smaller nozzle
    screw  = M3();
*    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw,  $gap=0.15);
*    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw,     $gap=0.15);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw, $gap=0.15);
*    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw,     $gap=0.15);
}

