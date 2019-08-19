/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Metric screw modelisation
 * Author:      Gilles Bouissac
 */

use <../hirth-joint.scad>

MARGIN = 0.2;

// ----------------------------------------
//
//    Showcase
//
// ----------------------------------------
module hirthJointShow( part=0 ) {
    INTER    = 10;

    RADIUS   = 10;
    TOOTH    = 21;
    HEIGHT   = 1.2;
    SHOULDER = 0;
    INLAY    = 2;

    if ( part==0 || part==1 ) {
        color( "YellowGreen" )
        translate( [0,0,+SHOULDER+HEIGHT/2+INTER/2] )
        rotate( [180,0,0] )
        rotate( [0,0,180] )
        hirthJointSinus( RADIUS, TOOTH, HEIGHT, SHOULDER, INLAY );
    }

    if ( part==0 || part==2 ) {
        color( "Lime" )
        translate( [0,0,-SHOULDER-HEIGHT/2-INTER/2] )
        hirthJointSinus( RADIUS, TOOTH, HEIGHT, SHOULDER, INLAY );
    }

    if ( part==0 || part==3 ) {
        color( "SkyBlue" )
        translate( [0,3*RADIUS,-SHOULDER-HEIGHT/2-INTER/2] )
        hirthJointTriangle( RADIUS, TOOTH, HEIGHT, SHOULDER, INLAY );
    }

    if ( part==0 || part==4 ) {
        color( "Khaki" )
        translate( [2.5*RADIUS,1.5*RADIUS,-SHOULDER-HEIGHT/2-INTER/2] )
        hirthJointRectangle( RADIUS, TOOTH, HEIGHT, SHOULDER, INLAY );
    }

    if ( part==0 || part==5 ) {
        translate( [0,0,-1.5*INTER-SHOULDER-HEIGHT] ) {
            difference() {
                color( "DarkGreen" )
                translate( [0,0,-2] )
                    cylinder( r=(RADIUS+2)/cos(30), h=4, center=true );
                    hirthJointPassage( RADIUS, INLAY );
            }
        }
    }
}
difference() {
    hirthJointShow( 0, $fn=200 );
    cylinder( r=1.5+MARGIN/2, h=100, center=true, $fn=200 );
}

/*
$fn=100;

// Sinusoidal profile
//   Radius:       10 mm
//   Nb tooth:     20
//   Tooth height: 1.2 mm
hirthJointSinus( 10, 21, 1.2 );

// Sinusoidal profile with shoulder
//   Radius:          10 mm
//   Nb tooth:        20
//   Tooth height:    1.2 mm
//   Shoulder height: 2 mm
hirthJointSinus( 10, 21, 1.2, 2 );

// Sinusoidal profile with shoulder and inlay
//   Radius:          10 mm
//   Nb tooth:        20
//   Tooth height:    1.2 mm
//   Shoulder height: 2 mm
//   Inlay height:    1 mm
hirthJointSinus( 10, 21, 1.2, 2, 1 );

// Triangle profile
//   Radius:          10 mm
//   Nb tooth:        20
//   Tooth height:    1.2 mm
//   Shoulder height: 2 mm
//   Inlay height:    1 mm
hirthJointTriangle( 10, 21, 1.2, 1, 1 );

// Rectangle profile
//   Radius:          10 mm
//   Nb tooth:        20
//   Tooth height:    1.2 mm
//   Shoulder height: 2 mm
//   Inlay height:    1 mm
hirthJointRectangle( 10, 21, 1.2, 1, 1 );

// Inlay passage
//   Radius:          10 mm
//   Inlay height:    1 mm
difference() {
    translate( [0,0,-2] )
        cylinder( r=15, h=4, center=true );
    hirthJointPassage( 10, 1 );
}

*/

