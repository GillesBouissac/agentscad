/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: UNC thread modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/unc-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module uncThreadExternal ( screw, l=-1, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module uncThreadInternal ( screw, l=-1, t=-1, f=true ) { libThreadInternal(screw,l,t,f); }

// Nut with Hexagonal head
module uncNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module uncNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module uncBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module uncBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

color( "gold" )
translate( [50,7,-20] )
rotate( [90,0,0] )
linear_extrude(0.1)
    text( "UNC UNF",halign="center",valign="center",size=10,$fn=100 );

IX=20;
module showName( d, z ) {
    %color( "gold" )
        translate( [0,-7,z] )
        rotate( [90,0,0] )
        linear_extrude(0.1)
        text( screwGetName(d), halign="center", valign="center", size=2, $fn=100 );
}

if (1) {
    s1 = UNC_N1();
    s2 = UNC_N5();
    s3 = UNC1_4(tl=20);
    s4 = UNC3_8(tl=30);
    s5 = UNC1_2();
    s6 = UNC7_8();
    translate([2,0,0]) {
        uncNutHexagonalThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([15,0,0]) {
        uncNutSquareThreaded(s2, $fn=50);
        showName(s2, -2);
    }
    translate([30,0,0]) {
        uncBoltHexagonalThreaded(s3, $fn=50);
        showName(s3, -7);
    }
    translate([50,0,0]) {
        uncBoltAllenThreaded(s4, $fn=50);
        showName(s4, -11);
    }
    translate([70,0,0]) {
        uncThreadInternal(s5, $fn=50);
        showName(s5, -2);
    }
    translate([90,0,0]) {
        uncThreadExternal(uncClone(s6,16),$fn=50);
        showName(s6, -4);
    }
}
if (0) {
    s1 = UNC1_4(tl=20);
    translate([0*IX,0,0]) {
        uncNutHexagonalThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([1*IX,0,0]) {
        uncNutSquareThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([2*IX,0,0]) {
        uncBoltHexagonalThreaded(s1, $fn=50);
        showName(s1, -7);
    }
    translate([3*IX,0,0]) {
        uncBoltAllenThreaded(s1, $fn=50);
        showName(s1, -9);
    }
}
if (0) {
    s1 = UNC3_8(tl=20);
    translate([0*IX,0,0]) {
        uncNutHexagonalThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([1*IX,0,0]) {
        uncNutSquareThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([2*IX,0,0]) {
        uncBoltHexagonalThreaded(s1, $fn=50);
        showName(s1, -9);
    }
    translate([3*IX,0,0]) {
        uncBoltAllenThreaded(s1, $fn=50);
        showName(s1, -11);
    }
}

