/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Knob modelisation
 * Author:      Gilles Bouissac
 */

use <mx-screw.scad>
use <bevel.scad>

// ----------------------------------------
//
//    API
//
// ----------------------------------------
MFG    = 0.01;  // ManiFold Guard
VGG    = 1;     // Visual Glich Guard
MARGIN = 0.2;
NOZZLE = 0.4;

// Knob that for mx hexagonal screw
// - screw:    the screw: M2(), M3() etc...
// - diameter: required diameter, can be larger if the screw don't fit
//             computed from screw dimensions if -1
// - height:   required total height, can be larger if the screw don't fit
//             computed from screw dimensions if -1
module mxKnob( screw, diameter=-1, height=-1, part=0 ) {
    bottom_t    = mxHeadDiameterPassage(screw)/3;
    wall_t      = mxHeadDiameterPassage(screw)/4;

    base_h      = mxHeadLengthHexa(screw)+bottom_t;
    base_r      = mxHeadDiameterPassage(screw)/2+wall_t/2;

    knob_h_min  = mxHeadDiameterPassage(screw) + wall_t;
    knob_r_min  = mxHeadDiameterPassage(screw)/2+2*wall_t/2;

    knob_h    = height>knob_h_min     ? height : knob_h_min;
    knob_r    = diameter/2>knob_r_min ? diameter/2 : knob_r_min;

    cap_h     = knob_h-base_h-NOZZLE;
    cap_r     = min(knob_r-wall_t,base_r);

    translate( [0,0,-bottom_t] ) {
        if ( part==0 || part==2 ) {
            translate( [0,0,knob_h-cap_h+knob_h] )
                color ( "white" )
                mxKnobCap    ( cap_r, cap_h, screw, wall_t );
        }
        if ( part==3 ) {
            translate( [0,0,knob_h-cap_h] )
                color ( "white" )
                mxKnobCap    ( cap_r, cap_h, screw, wall_t );
        }
        if ( part==0 || part==1 ) {
            difference() {
                mxKnobHandle ( knob_r, knob_h, cap_r, screw, wall_t );
                translate( [0,0,knob_h-cap_h] )
                    mxKnobCapPassage ( cap_r, cap_h, wall_t );
                cylinder( r=cap_r, h=knob_h );
            }
            mxKnobBase ( base_r, base_h, screw, bottom_t, wall_t);
        }
    }
}

// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------

// Knob base with inlay for the screw
// - thickness: wall thickness
module mxKnobBase ( base_r, base_h, screw, bottom_t, wall_t ) {
    difference() {
        cylinder( r=base_r, h=base_h );
        translate( [0,0,bottom_t+MFG] )
            mxScrewHexagonalPassage( screw );
        translate( [base_r,base_r,+base_h] )
            bevelCutArc( base_r-MFG, 2*base_h, 360 ) ;
    }
}

// Knob handle with screw passage and grips
module mxKnobHandle ( knob_r, knob_h, cap_r, screw, thickness ) {
    sphere_r = knob_r*1.2;

    knob_c   = 2*PI*knob_r;
    grip_d   = mxThreadDiameter(screw);
    grip_nb  = 9;

    echo( "mxKnobHandle: grip_nb=", grip_nb );

    difference () {
        union () {
            intersection() {
                cylinder( r=knob_r, h=knob_h );
                translate( [0,0,sphere_r+thickness/2] )
                    difference () {
                        sphere( r=sphere_r );
                        sphere( r=sphere_r-thickness );
                    }
            }
            intersection() {
                difference () {
                    cylinder( r=knob_r, h=knob_h );
                    cylinder( r=cap_r, h=knob_h+MFG );
                }
                translate( [0,0,sphere_r+thickness/2] )
                    sphere( r=sphere_r );
            }
        }
        translate( [knob_r,knob_r,0] )
            bevelCutArc( knob_r-MFG, 2*knob_h, 360,
                $bevel=thickness*2/3,
                $bevelProfile=bevelArc() ) ;

        for ( a=[0:360/grip_nb:360] ) {
            rotate( [0,0,a] )
            translate( [knob_r+grip_d/3,0,0] )
                cylinder( r=grip_d/2, h=knob_h+VGG );
        }
    }
}

// Knob cap
module mxKnobCap ( cap_r, cap_h, screw, thickness ) {
    local_cap_r   = cap_r-MARGIN;
    local_scale   = (local_cap_r+thickness/3)/local_cap_r;
    cap_thickness = 4*NOZZLE;

    difference() {
        cylinder( r=local_cap_r, h=cap_h );
        cylinder( r=local_cap_r-cap_thickness, h=cap_h-thickness );
        translate( [local_cap_r,local_cap_r,cap_h] )
            bevelCutArc( local_cap_r-MFG, 2*cap_h, 360 ) ;
    }
    translate( [0,0,cap_h-thickness] )
        linear_extrude( height=thickness, scale=local_scale )
        circle( r=local_cap_r );

    for ( a=[0:120:360] )
        rotate( [0,0,a] )
        translate( [local_cap_r-cap_thickness/2+MARGIN,0,0] )
            cylinder( r=cap_thickness/2, h=cap_h );

    // Pole to keep the screw in place
    // This allow as well to pull up the cap by pushing back the screw
    cylinder( r=mxThreadDiameter(screw)/2, h=cap_h );
}

module mxKnobCapPassage ( cap_r, cap_h, thickness ) {
    local_cap_r = cap_r;
    local_scale = (local_cap_r+thickness/3)/local_cap_r;

    cylinder( r=local_cap_r, h=cap_h );

    translate( [0,0,cap_h-thickness] )
        linear_extrude( height=thickness+MFG, scale=local_scale )
        circle( r=local_cap_r );
}


// ----------------------------------------
//
//    Showcase
//
// ----------------------------------------
// mxKnob ( M6(), $fn=100 );
