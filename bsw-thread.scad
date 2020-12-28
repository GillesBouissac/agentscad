/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSW thread modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/bsw-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module bswThreadExternal ( screw, l=undef, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module bswThreadInternal ( screw, l=undef, f=true, t=undef ) { libThreadInternal(screw,l,f,t); }

// Nut with Hexagonal head
module bswNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module bswNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module bswBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module bswBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

module showName( d, z ) {
    %color( "gold" )
        translate( [0,-7,z] )
        rotate( [90,0,0] )
        linear_extrude(0.1)
        text( screwGetName(d), halign="center", valign="center", size=2, $fn=100 );
}

module showParts( part=0 ) {
    IX=20;
    color( "silver" )
    translate( [50,7,-20] )
    rotate( [90,0,0] )
    linear_extrude(0.1)
        text( "BSW BSF",halign="center",valign="center",size=10,$fn=100 );

    if ( part==0 ) {
        s1 = BSW1_16();
        s2 = BSW5_32();
        s3 = BSW1_4(tl=20);
        s4 = BSW3_8(tl=30); // AKA: Congrès thread
        s5 = BSW1_2();
        s6 = BSW7_8();
        translate([0,0,0]) {
            bswNutHexagonalThreaded(s1, $fn=50);
            showName(s1, -2);
        }
        translate([15,0,0]) {
            bswNutSquareThreaded(s2, $fn=50);
            showName(s2, -2);
        }
        translate([30,0,0]) {
            bswBoltHexagonalThreaded(s3, $fn=50);
            showName(s3, -7);
        }
        translate([50,0,0]) {
            bswBoltAllenThreaded(s4, $fn=50);
            showName(s4, -11);
        }
        translate([70,0,0]) {
            bswThreadInternal(screw=s5,$fn=50);
            showName(s5, -2);
        }
        translate([90,0,0]) {
            bswThreadExternal(bswClone(s6,16),$fn=50);
            showName(s6, -4);
        }
    }
    if ( part==1 ) {
        s1 = BSW1_4(tl=20);
        translate([0*IX,0,0]) {
            bswNutHexagonalThreaded(s1, $fn=100);
            showName(s1, -2);
        }
        translate([1*IX,0,0]) {
            bswNutSquareThreaded(s1, $fn=100);
            showName(s1, -2);
        }
        translate([2*IX,0,0]) {
            bswBoltHexagonalThreaded(s1, $fn=100);
            showName(s1, -7);
        }
        translate([3*IX,0,0]) {
            bswBoltAllenThreaded(s1, $fn=100);
            showName(s1, -9);
        }
    }
    if ( part==2 ) {
        s1 = BSW3_8(tl=20);
        translate([0*IX,0,0]) {
            bswNutHexagonalThreaded(s1, $fn=100);
            showName(s1, -2);
        }
        translate([1*IX,0,0]) {
            bswNutSquareThreaded(s1, $fn=100);
            showName(s1, -2);
        }
        translate([2*IX,0,0]) {
            bswBoltHexagonalThreaded(s1, $fn=100);
            showName(s1, -9);
        }
        translate([3*IX,0,0]) {
            bswBoltAllenThreaded(s1, $fn=100);
            showName(s1, -11);
        }
    }
}
*
showParts(0);

