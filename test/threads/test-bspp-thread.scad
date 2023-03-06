/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSPP thread test
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/bspp-screw.scad>
use <agentscad/bspp-thread.scad>
use <agentscad/bsw-screw.scad>
use <agentscad/bsw-thread.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
$fn=50;

module showVerticalText(t, z) {
    %color( "gold" )
        translate( [0,-7,z] )
        rotate( [90,0,0] )
        linear_extrude(0.1)
        text( t, halign="center", valign="center", size=2 );
}

module showName( d, z ) {
    showVerticalText(screwGetName(d), z);
}

module showParts( part=0 ) {
    IX=20;
    color( "silver" )
    translate( [40,7,-20] )
    rotate( [90,0,0] )
    linear_extrude(0.1)
        text( "BSPP",halign="center",valign="center",size=10 );

    if ( part==0 ) {
        translate([00,0,0]) {
            screw = BSPP1_4();
            difference() {
                bsppBoltHexagonalThreaded(screw);
                cylinder(r=bsppGetPipeD(screw)/2, h=1000, center=true);
            }
            showName(screw, -12);
        }
        translate([40,0,0]) {
            screw = BSPP1_2();
            difference() {
                bsppThreadExternal(screw);
                cylinder(r=bsppGetPipeD(screw)/2, h=1000, center=true);
            }
            showName(screw, -2);
        }
        translate([80,0,0]) {
            screw1 = BSPP1_8(tl=7.26);
            screw2 = BSW3_8(tl=5.15);
            difference() {
                union() {
                    bsppThreadExternal(screw1);
                    translate([0,0,-screwGetHexagonalHeadL(screw2)])
                    rotate([180,0,0])
                        bswBoltHexagonalThreaded(screw2);
                }
                cylinder(r=bsppGetPipeD(screw1)/2, h=1000, center=true);
            }
            showVerticalText("BSPP 1/8 to BSW 3/8 adapter", -22);
        }
    }
}

showParts(0);

