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
    s1 = MXF1_6();
    s2 = MXF5();
    s3 = MXF6(tl=20);
    s4 = MXF10(tl=30);
    s5 = MXF12();
    s6 = MXF22();
    translate([0,0,0]) {
        mxfNutHexagonalThreaded(s1, $fn=50);
        showName(s1, -2);
    }
    translate([15,0,0]) {
        mxfNutSquareThreaded(s2, $fn=50);
        showName(s2, -2);
    }
    translate([30,0,0]) {
        mxfBoltHexagonalThreaded(s3, $fn=50);
        showName(s3, -7);
    }
    translate([50,0,0]) {
        mxfBoltAllenThreaded(s4, $fn=50);
        showName(s4, -11);
    }
    translate([70,0,0]) {
        mxfThreadInternal(s5, $fn=50);
        showName(s5, -2);
    }
    translate([90,0,0]) {
        mxfThreadExternal(mxfClone(s6,16),$fn=50);
        showName(s6, -4);
    }
}
if (0) {
    s1 = MXF5(tl=20);
    translate([0*IX,0,0]) {
        mxfNutHexagonalThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([1*IX,0,0]) {
        mxfNutSquareThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([2*IX,0,0]) {
        mxfBoltHexagonalThreaded(s1, $fn=100);
        showName(s1, -7);
    }
    translate([3*IX,0,0]) {
        mxfBoltAllenThreaded(s1, $fn=100);
        showName(s1, -9);
    }
}
if (0) {
    s1 = MXF6(tl=20);
    translate([0*IX,0,0]) {
        mxfNutHexagonalThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([1*IX,0,0]) {
        mxfNutSquareThreaded(s1, $fn=100);
        showName(s1, -2);
    }
    translate([2*IX,0,0]) {
        mxfBoltHexagonalThreaded(s1, $fn=100);
        showName(s1, -9);
    }
    translate([3*IX,0,0]) {
        mxfBoltAllenThreaded(s1, $fn=100);
        showName(s1, -11);
    }
}
