/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Metric fine screw thread modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/mxf-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module mxfThreadExternal ( screw, l=-1, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module mxfThreadInternal ( screw, l=-1, t=-1, f=true ) { libThreadInternal(screw,l,t,f); }

// Nut with Hexagonal head
module mxfNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module mxfNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module mxfBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module mxfBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

if (0) {
    // Can be printed with any printer settings :)
    screw  = MF64();
    translate([0,0*screwGetHeadDP(screw),0])
        mxfNutHexagonalThreaded(screw, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        mxfNutSquareThreaded(screw, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        mxfBoltHexagonalThreaded(screw, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        mxfBoltAllenThreaded(screw, $fn=50);
}

if (1) {
    // Successfuly printed with 0.2mm layers and 0.4 nozzle on MK3S
    screw  = MF6();
    translate([0,0*screwGetHeadDP(screw),0])
        mxfNutHexagonalThreaded(screw, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        mxfNutSquareThreaded(screw, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        mxfBoltHexagonalThreaded(screw, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        mxfBoltAllenThreaded(mxfClone(screw,30), $fn=50);
    translate([0,4*screwGetHeadDP(screw),0])
        mxfThreadInternal(screw, $fn=50);
    translate([0,5*screwGetHeadDP(screw),0])
        mxfThreadExternal(mxfClone(screw,6),$fn=50);
}

if (0) {
    // Successfuly printed with 0.1mm layers and 0.4 nozzle on MK3S
    screw  = MF4();
    translate([0,0*screwGetHeadDP(screw),0])
        mxfNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        mxfNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        mxfBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        mxfBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

if (0) {
    // Didn't manage to print this one with 0.1mm layers and 0.4 nozzle
    // Pitch is 0.5 too close to 0.4, need smaller nozzle
    screw  = MF3();
    translate([0,0*screwGetHeadDP(screw),0])
        mxfNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        mxfNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        mxfBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        mxfBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

// Test thread profile
if (0) {
    !union() {
        polygon ( screwThreadProfile ( MF4(), 1, I=false, $gap=0.01, $fn=50 ) );
        polygon ( screwThreadProfile ( MF4(), 1, I=true,  $gap=0.01, $fn=50 ) );
    }
}
