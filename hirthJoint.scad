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

// ----------------------------------------
//
//    API
//
// ----------------------------------------
VGG    = 1;   // Visual Glich Guard
MARGIN = 0.2;
NOZZLE = 0.4;
R1_MIN_NOZZLE = 5;

module hirthJoint ( r1, r2, tooth_w, height, shoulder=0, inlay=0 ) {

    tooth = floor(2*PI*r2/tooth_w);
    w1    = 2*PI*r1/tooth;
    rmin  = R1_MIN_NOZZLE*NOZZLE>w1 ? R1_MIN_NOZZLE*NOZZLE*tooth/(2*PI) : r1;
    h1    = height*rmin/r2;

    width = 2*PI*r2/tooth;

    echo ( "hirthJoint tooth nb: ", tooth );
    echo ( "hirthJoint r1: ",       r1 );
    echo ( "hirthJoint rmin: ",     rmin );
    echo ( "hirthJoint rmax: ",     r2 );

    translate( [0,0,+shoulder] )
    intersection() {
        translate( [0,0,+height/2] )
        difference () {
            cylinder( r=r2, h=height,     center=true );
            cylinder( r=rmin, h=height+VGG, center=true );
        }

        for ( a=[0:360/tooth:359] ) {
            rotate( [0,0,a] )
                hirthJointTooth( r2, width, height );
        }
    }
    translate( [0,0,+shoulder/2] )
    difference () {
        cylinder( r=r2, h=shoulder,     center=true );
        cylinder( r=rmin, h=shoulder+VGG, center=true );
    }
    translate( [0,0,-inlay/2] )
        cylinder( r=r2/cos(30), h=inlay, center=true, $fn=6 );
}

module hirthJointPassage ( r2, inlay=0 ) {
    translate( [0,0,-inlay/2] )
        cylinder( r=(r2+MARGIN)/cos(30), h=inlay+2*MARGIN, center=true, $fn=6 );
}


// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------

module hirthJointTooth ( radius, width, height ) {
    alpha = atan( (height/2)/radius );

    intersection() {
        linear_extrude( height=height )
        polygon ([
            [0,0],
            [radius,+width/2],
            [radius,-width/2],
            [0,0]
        ]);

        translate( [0,width/2,0] )
        rotate( [90,0,0] )
        linear_extrude( height=width )
        polygon ([
            [0,0],
            [radius,0],
            [0,height/2],
            [0,0]
        ]);
    }

    th = (radius*tan(2*alpha)/cos(alpha))/2;
    translate( [radius,0,0] )
    rotate( [0,-90,0] )
    rotate( [0,alpha,0] )
    linear_extrude( height=radius/cos(alpha), scale=0 )
        // Sinusoidal profile
        polygon ([
            for ( i=[-width/2:+width/30:+width/2+0.1] )
                [th*cos(i*360/width)+th,i]
        ]);

/*
        // Triangle profile
        polygon ([
            [0,-width/2],
            [0,+width/2],
            [th,0],
        ]);
*/
}

// ----------------------------------------
//
//    Showcase
//
// ----------------------------------------
module hirthJointShow( part=0 ) {
    TOOTH_NB = 15;
    INTER    = 10;
    HEIGHT   = 2;
    SHOULDER = 0;
    R1       = 0;
    R2       = 10;
    TOOTH_W  = 2*PI*R2/TOOTH_NB;

    if ( part==0 || part==1 ) {
        color( "Yellow" )
        translate( [0,0,+SHOULDER+HEIGHT/2+INTER/2] )
        rotate( [180,0,0] )
        rotate( [0,0,180] )
        hirthJoint( R1, R2, TOOTH_W, HEIGHT, SHOULDER, 2 );
    }

    if ( part==0 || part==2 ) {
        color( "Lime" )
        translate( [0,0,-SHOULDER-HEIGHT/2-INTER/2] )
        hirthJoint( R1, R2, TOOTH_W, HEIGHT, SHOULDER, 2 );
    }

    if ( part==0 || part==3 ) {
        translate( [0,0,-1.5*INTER-SHOULDER-HEIGHT] ) {
            difference() {
                color( "DarkGreen" )
                translate( [0,0,-2] )
                    cylinder( r=(R2+2)/cos(30), h=4, center=true );
                color( "ForestGreen" )
                    hirthJointPassage( R2, 2 );
            }
        }
    }
}
difference() {
    hirthJointShow( 0, $fn=200 );
    cylinder( r=1.52, h=100, center=true, $fn=200 );
}
