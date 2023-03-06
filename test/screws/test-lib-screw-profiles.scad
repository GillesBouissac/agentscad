/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: lib-screw testing
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/extensions.scad>

PRECISION = 50;
PART_TO_SHOW = 0; // [0:Profile,1:Complex structure]
SHOW_HOLLOW = true;

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
function profile_m() = "M"; // Metric or UTS profile
function profile_w() = "W"; // Whitworth profile

module showName( d, dy=0 ) {
    translate( [screwGetPitch(d),dy,0.1] )
    linear_extrude(1)
    text( screwGetName(d), halign="center", valign="center", size=1 );
}

// Thread profiles visualisation
module showParts( part=0 ) {
    if ( part==0 ) {
        screw_w = libScrewDataCompletion([["Profile BSW / BSF",     6,12,1]],0,prf=profile_w());
        screw_m = libScrewDataCompletion([["Profile M / UNC / UNF", 6,12,1]],0,prf=profile_m());
        !union() {
            color("white")
            union() {
                intersection() {
                    rotate( [90,0,90] )
                    union() {
                        libThreadExternal(screw_m,l=2*screwGetPitch(screw_m),f=true);
                        libThreadInternal(screw_m,l=2*screwGetPitch(screw_m),f=true,t=1);
                    }
                    cube( [100,100,0.01], center=true );
                }
                showName(screw_m,-0.6);
            }
            translate( [0,0,-2] )
            color("lightblue")
            union() {
                intersection() {
                    rotate( [90,0,90] )
                    union() {
                        libThreadExternal(screw_w,l=2*screwGetPitch(screw_m),f=true);
                        libThreadInternal(screw_w,l=2*screwGetPitch(screw_m),f=true,t=1);
                    }
                    cube( [100,100,0.01], center=true );
                }
                showName(screw_w,-0.6);
            }
        }
    }

    // Complex structure
    if ( part==1 ) {
        screw_w = libScrewDataCompletion([["Profile BSW / BSF",inch2mm(1/16),inch2mm(3/8),1]],0,prf=profile_w());
        screw_hole = libScrewDataCompletion([["B",2,6,1]],0,prf=profile_w());

        difference() {
            render(convexity=20)
            union() {
                libThreadExternal( screw_w, 10, f=false );
                libThreadInternal( screw_w, 10, f=false, t=1 );
            }
            if (SHOW_HOLLOW) {
                #negative_parts(screw_hole);
            }
            else {
                negative_parts(screw_hole);
            }
        }
    }
}

module negative_parts(screw_hole) {
    render(convexity=20)
    union() {
        translate( [-1,0,9] )
            rotate( [ 60, 20, -60 ] )
            translate( [0,0,-10] )
            libThreadExternal( screw_hole, 16 );
        rotate( [ 0, 0, -90 ] )
            translate( [5,5,3] )
            cylinder( r=4.5,10 );
    }
}

showParts(PART_TO_SHOW, $fn=PRECISION);

