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
module mxThreadExternal ( screw, l=undef, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module mxThreadInternal ( screw, l=undef, f=true, t=undef ) { libThreadInternal(screw,l,f,t); }

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

color( "DodgerBlue" )
translate( [50,7,-20] )
rotate( [90,0,0] )
linear_extrude(0.1)
    text( "MC MF",halign="center",valign="center",size=10,$fn=100 );

IX=20;
module showName( d, z ) {
    %color( "gold" )
        translate( [0,-7,z] )
        rotate( [90,0,0] )
        linear_extrude(0.1)
        text( screwGetName(d), halign="center", valign="center", size=2, $fn=100 );
}

if (1) {
    s1 = M1_6();
    s2 = M5();
    s3 = M6(tl=20);
    s4 = M10(tl=30);
    s5 = M12();
    s6 = M22();
    translate([0,0,0]) {
        mxNutHexagonalThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([15,0,0]) {
        mxNutSquareThreaded(s2, $fn=50);
        showName(s2, -2);
    }
    translate([30,0,0]) {
        mxBoltHexagonalThreaded(s3, $fn=50);
        showName(s3, -7);
    }
    translate([50,0,0]) {
        mxBoltAllenThreaded(s4, $fn=50);
        showName(s4, -11);
    }
    translate([70,0,0]) {
        mxThreadInternal(s5, $fn=50);
        showName(s5, -2);
    }
    translate([90,0,0]) {
        mxThreadExternal(mxClone(s6,16),$fn=50);
        showName(s6, -4);
    }
}
if (0) {
    s1 = M5(tl=20);
    translate([0*IX,0,0]) {
        mxNutHexagonalThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([1*IX,0,0]) {
        mxNutSquareThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([2*IX,0,0]) {
        mxBoltHexagonalThreaded(s1, $fn=100);
        showName(s1, -7);
    }
    translate([3*IX,0,0]) {
        mxBoltAllenThreaded(s1, $fn=100);
        showName(s1, -9);
    }
}
if (0) {
    s1 = M6(tl=20);
    translate([0*IX,0,0]) {
        mxNutHexagonalThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([1*IX,0,0]) {
        mxNutSquareThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([2*IX,0,0]) {
        mxBoltHexagonalThreaded(s1, $fn=100);
        showName(s1, -9);
    }
    translate([3*IX,0,0]) {
        mxBoltAllenThreaded(s1, $fn=100);
        showName(s1, -11);
    }
}
