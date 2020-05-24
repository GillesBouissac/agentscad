/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSF thread modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/bsf-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module bsfThreadExternal ( screw, l=-1, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module bsfThreadInternal ( screw, l=-1, t=-1, f=true ) { libThreadInternal(screw,l,t,f); }

// Nut with Hexagonal head
module bsfNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module bsfNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module bsfBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module bsfBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

if (0) {
    screw  = BSF1_1_2();
    translate([0,0*screwGetHeadDP(screw),0])
        bsfNutHexagonalThreaded(screw, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        bsfNutSquareThreaded(screw, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        bsfBoltHexagonalThreaded(screw, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        bsfBoltAllenThreaded(screw, $fn=50);
}

if (1) {
    screw  = BSF1_4();
    translate([0,0*screwGetThreadDP(screw),0])
        bsfNutHexagonalThreaded(screw, $fn=50);
    translate([0,2*screwGetThreadDP(screw),0])
        bsfNutSquareThreaded(screw, $fn=50);
    translate([0,4*screwGetThreadDP(screw),0])
        bsfBoltHexagonalThreaded(screw, $fn=50);
    translate([0,6*screwGetThreadDP(screw),0])
        bsfBoltAllenThreaded(bsfClone(screw,30), $fn=50);
    translate([0,8*screwGetThreadDP(screw),0])
        bsfThreadInternal(screw, $fn=50);
    translate([0,10*screwGetThreadDP(screw),0])
        bsfThreadExternal(bsfClone(screw,6),$fn=50);
}

if (0) {
    screw  = BSF5_32();
    translate([0,0*screwGetHeadDP(screw),0])
        bsfNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        bsfNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        bsfBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        bsfBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

if (0) {
    screw  = BSF1();
    translate([0,0*screwGetHeadDP(screw),0])
        bsfNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        bsfNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        bsfBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        bsfBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

// Test thread profile
if (0) {
    !union() {
        polygon ( screwThreadProfile ( BSF1_4(), 1, I=false, $gap=0.01, $fn=50 ) );
        polygon ( screwThreadProfile ( BSF1_4(), 1, I=true,  $gap=0.01, $fn=50 ) );
    }
}
