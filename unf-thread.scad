/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: UNF thread modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/unf-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module unfThreadExternal ( screw, l=-1, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module unfThreadInternal ( screw, l=-1, t=-1, f=true ) { libThreadInternal(screw,l,t,f); }

// Nut with Hexagonal head
module unfNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module unfNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module unfBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module unfBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

if (0) {
    screw  = UNF4();
    translate([0,0*screwGetHeadDP(screw),0])
        unfNutHexagonalThreaded(screw, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        unfNutSquareThreaded(screw, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        unfBoltHexagonalThreaded(screw, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        unfBoltAllenThreaded(screw, $fn=50);
}

if (1) {
    screw  = UNF1_4();
    translate([0,0*screwGetThreadDP(screw),0])
        unfNutHexagonalThreaded(screw, $fn=50);
    translate([0,2*screwGetThreadDP(screw),0])
        unfNutSquareThreaded(screw, $fn=50);
    translate([0,4*screwGetThreadDP(screw),0])
        unfBoltHexagonalThreaded(screw, $fn=50);
    translate([0,6*screwGetThreadDP(screw),0])
        unfBoltAllenThreaded(unfClone(screw,30), $fn=50);
    translate([0,8*screwGetThreadDP(screw),0])
        unfThreadInternal(screw, $fn=50);
    translate([0,10*screwGetThreadDP(screw),0])
        unfThreadExternal(unfClone(screw,6),$fn=50);
}

if (0) {
    screw  = UNF_R8();
    translate([0,0*screwGetHeadDP(screw),0])
        unfNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        unfNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        unfBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        unfBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

if (0) {
    screw  = UNF_R5();
    translate([0,0*screwGetHeadDP(screw),0])
        unfNutHexagonalThreaded(screw,  $gap=0.15, $fn=50);
    translate([0,1*screwGetHeadDP(screw),0])
        unfNutSquareThreaded(screw,     $gap=0.15, $fn=50);
    translate([0,2*screwGetHeadDP(screw),0])
        unfBoltHexagonalThreaded(screw, $gap=0.15, $fn=50);
    translate([0,3*screwGetHeadDP(screw),0])
        unfBoltAllenThreaded(screw,     $gap=0.15, $fn=50);
}

// Test thread profile
if (0) {
    !union() {
        polygon ( screwThreadProfile ( UNF1_4(), 1, I=false, $gap=0.01, $fn=50 ) );
        polygon ( screwThreadProfile ( UNF1_4(), 1, I=true,  $gap=0.01, $fn=50 ) );
    }
}
