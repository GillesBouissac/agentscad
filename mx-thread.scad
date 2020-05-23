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
use <agentscad/lib-screw.scad>
use <agentscad/mx-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module mxThreadExternal ( screw, l=-1, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module mxThreadInternal ( screw, l=-1, t=-1, f=true ) { libThreadInternal(screw,l,t,f); }

// Nut with Hexagonal head
module mxNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module mxNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module mxBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module mxBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

if (0) {
    // Can be printed with any printer settings :)
    screw  = M64();
    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw, $fn=50);
    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw, $fn=50);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw, $fn=50);
    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw, $fn=50);
}

if (1) {
    // Successfuly printed with 0.2mm layers and 0.4 nozzle on MK3S
    screw  = M6();
    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw, $fn=50);
    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw, $fn=50);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw, $fn=50);
    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(mxClone(screw,30), $fn=50);
    translate([0,4*mxGetHeadDP(screw),0])
        mxThreadInternal(screw, $fn=50);
    translate([0,5*mxGetHeadDP(screw),0])
        mxThreadExternal(mxClone(screw,6),$fn=50);
}

if (0) {
    // Successfuly printed with 0.1mm layers and 0.4 nozzle on MK3S
    screw  = M4();
    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

if (0) {
    // Didn't manage to print this one with 0.1mm layers and 0.4 nozzle
    // Pitch is 0.5 too close to 0.4, need smaller nozzle
    screw  = M3();
    translate([0,0*mxGetHeadDP(screw),0])
        mxNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*mxGetHeadDP(screw),0])
        mxNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*mxGetHeadDP(screw),0])
        mxBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*mxGetHeadDP(screw),0])
        mxBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

