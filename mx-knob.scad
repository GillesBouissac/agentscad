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
MFG      = 0.01;  // ManiFold Guard
VGG      = 1;     // Visual Glich Guard
MARGIN   = 0.2;
NOZZLE   = 0.4;
CAP_GRIP = 0.3; // Amount of overlap between cap grips and knob handle

// Knob that for mx hexagonal screw
// - screw:    the screw: M2(), M3() etc...
// - diameter: required diameter, can be larger if the screw don't fit
//             computed from screw dimensions if -1
// - height:   required total height, can be larger if the screw don't fit
//             computed from screw dimensions if -1
module mxKnob( screw, diameter=-1, height=-1, part=0 ) {
    bottom_t    = mxGetHeadDP(screw)/3;
    wall_t      = mxGetHeadDP(screw)/4;

    base_h      = mxGetHexagonalHeadL(screw)+bottom_t;
    base_r      = mxGetHeadDP(screw)/2+wall_t/2;

    knob_h_min  = mxGetHeadDP(screw) + wall_t;
    knob_r_min  = mxGetHeadDP(screw)/2+2*wall_t/2;

    knob_h    = height>knob_h_min     ? height : knob_h_min;
    knob_r    = diameter/2>knob_r_min ? diameter/2 : knob_r_min;

    cap_h     = knob_h-base_h-NOZZLE;
    cap_r     = min(knob_r-wall_t,base_r);

    if ( part==0 ) {
        translate( [0,0,-cap_h+2*knob_h] )
            color ( "white" )
            mxKnobCap ( cap_r, cap_h, screw, wall_t );
        mxKnobHandle ( knob_r, knob_h, bottom_t, base_r, base_h, cap_r, cap_h, screw, wall_t );
    }
    if ( part==1 ) {
         mxKnobHandle ( knob_r, knob_h, bottom_t, base_r, base_h, cap_r, cap_h, screw, wall_t );
        %translate( [0,0,knob_h-cap_h] )
            mxKnobCap ( cap_r, cap_h, screw, wall_t );
    }
    if ( part==2 ) {
        rotate( [180,0,0] ) {
            translate( [0,0,-cap_h] )
                mxKnobCap ( cap_r, cap_h, screw, wall_t );
            %
            translate( [0,0,-knob_h] )
                mxKnobHandle ( knob_r, knob_h, bottom_t, base_r, base_h, cap_r, cap_h, screw, wall_t );
        }
    }
    if ( part==3 ) {
        // Special rendering, the cap in the knob
        translate( [0,0,knob_h-cap_h] )
            color ( "white" )
            mxKnobCap    ( cap_r, cap_h, screw, wall_t );
        mxKnobHandle ( knob_r, knob_h, bottom_t, base_r, base_h, cap_r, cap_h, screw, wall_t );
    }
}

// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------

// Complete knob handle
module mxKnobHandle ( knob_r, knob_h, base_t, base_r, base_h, cap_r, cap_h, screw, wall_t ) {
    difference() {
        mxKnobHandleShape ( knob_r, knob_h, cap_r, screw, wall_t );
        mxKnobHandleHoles ( knob_r, knob_h, cap_r, screw, wall_t );
        translate( [0,0,knob_h-cap_h] )
            mxKnobCapPassage ( cap_r, cap_h, wall_t );
    }
    mxKnobBase ( base_r, base_h, screw, base_t, wall_t);
}

// Knob base with inlay for the screw
// - thickness: wall thickness
module mxKnobBase ( base_r, base_h, screw, bottom_t, wall_t ) {
    difference() {
        cylinder( r=base_r, h=base_h );
        translate( [0,0,bottom_t+MFG] )
            rotate( [180,0,0] )
            mxBoltHexagonalPassage( screw );
        translate( [base_r,base_r,+base_h] )
            bevelCutArc( base_r-MFG, 2*base_h, 360 ) ;
    }
}

// Knob handle with screw passage and grips
module mxKnobHandleShape ( knob_r, knob_h, cap_r, screw, thickness ) {
    sphere_r = knob_r*1.2;
    intersection() {
        cylinder( r=knob_r, h=knob_h );
        translate( [0,0,sphere_r+thickness/2] )
            sphere( r=sphere_r );
    }
}

// Knob handle with screw passage and grips
module mxKnobHandleHoles ( knob_r, knob_h, cap_r, screw, thickness ) {
    grip_d   = mxGetThreadD(screw);
    grip_nb  = 9;

    // Main hole
    cylinder( r=cap_r, h=knob_h+MFG );

    // Beveling of top part
    translate( [knob_r,knob_r,0] )
        bevelCutArc( knob_r-MFG, 2*knob_h, 360,
            $bevel=thickness*2/3,
            $bevelProfile=bevelArc() ) ;

    // Handle grips
    for ( a=[0:360/grip_nb:360] ) {
        rotate( [0,0,a] )
        translate( [knob_r+grip_d/3,0,0] )
            cylinder( r=grip_d/2, h=knob_h+VGG );
    }
}

// Knob cap
module mxKnobCap ( cap_r, cap_h, screw, thickness ) {
    local_cap_r1  = cap_r-MARGIN;
    local_cap_r2  = local_cap_r1+thickness/3;
    local_scale   = local_cap_r2/local_cap_r1;
    cap_thickness = 4*NOZZLE;

    difference() {
        union() {
            // Main shape
            cylinder( r=local_cap_r1, h=cap_h );

            // Top hat
            translate( [0,0,cap_h-thickness] )
                linear_extrude( height=thickness, scale=local_scale )
                circle( r=local_cap_r1 );

            // Grips
            for ( a=[0:120:360] )
                rotate( [0,0,a] )
                translate( [cap_r-cap_thickness/2+CAP_GRIP,0,0] )
                    cylinder( r=cap_thickness/2, h=cap_h );
        }
        // Main hole
        cylinder( r=local_cap_r1-cap_thickness, h=cap_h-thickness );

        // Final beveling of bottom part
        translate( [local_cap_r2,local_cap_r2,cap_h] )
            bevelCutArc( local_cap_r2-MFG, 2*cap_h, 360, $bevel=thickness/3+0.5 ) ;
    }
    // Pole to keep the screw in place
    // This allow as well to pull up the cap by pushing back the screw
    cylinder( r=mxGetThreadD(screw)/2, h=cap_h );
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
mxKnob ( M6(), part=0, $fn=100 );
