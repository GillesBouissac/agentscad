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

module hirthJoint ( r1, r2, tooth_w, height, shoulder=0, inlay=0 ) {
    h1 = height*r1/r2;

    tooth = floor(2*PI*r2/tooth_w);
    width = 2*PI*r2/tooth;

    translate( [0,0,+shoulder/2] )
    intersection() {
        translate( [0,0,+height/2] )
        difference () {
            cylinder( r=r2, h=height,     center=true );
            cylinder( r=r1, h=height+VGG, center=true );
        }

        for ( a=[0:360/tooth:359] ) {
            rotate( [0,0,a] )
                hirthJointTooth( r2, width, height );
        }
    }
    difference () {
        cylinder( r=r2, h=shoulder,     center=true );
        cylinder( r=r1, h=shoulder+VGG, center=true );
    }
    translate( [0,0,-inlay/2] )
        cylinder( r=r2/cos(30), h=inlay, center=true, $fn=6 );
}

module hirthJointPlacement ( r2, inlay=0 ) {
    translate( [0,0,-inlay/2] )
        cylinder( r=(r2+2*OFFSET)/cos(30), h=inlay+2*OFFSET, center=true, $fn=6 );
}


// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------
VGG    = 1;   // Visual Glich Guard
OFFSET = 0.2;

module hirthJointTooth ( radius, width, height ) {
    alpha = atan( (height/2)/radius );

    intersection() {
        linear_extrude( height=height )
        polygon ([
            [0,0],
            [+width/2,radius],
            [-width/2,radius],
            [0,0]
        ]);

        translate( [-width/2,0,0] )
        rotate( [0,90,0] )
        rotate( [0,0,90] )
        linear_extrude( height=width )
        polygon ([
            [0,0],
            [radius,0],
            [0,height/2],
            [0,0]
        ]);
    }

    translate( [0,radius,0] )
    rotate( [90,0,0] )
    rotate( [-alpha,0,0] )
    linear_extrude( height=radius/cos(alpha), scale=0 )
        polygon ([
            [-width/2,0],
            [+width/2,0],
            [0,radius*tan(2*alpha)/cos(alpha)],
        ]);
}


// ----------------------------------------
//
//    Showcase
//
// ----------------------------------------
module hirthJointShow() {
    INTER    = 20;
    HEIGHT   = 2;
    TOOTH_W  = HEIGHT*3;
    R1       = 10;
    R2       = 20;

    color( "LightCyan" )
    translate( [0,0,+HEIGHT/2+INTER/2] )
    rotate( [180,0,0] )
    hirthJoint( R1, R2, TOOTH_W, HEIGHT, 3, 3 );

    color( "cyan" )
    translate( [0,0,-HEIGHT/2-INTER/2] )
    hirthJoint( R1, R2, TOOTH_W, HEIGHT, 5, 5 );

    translate( [0,0,-HEIGHT/2-INTER/2-15] ) {
        difference() {
            color( "RoyalBlue" )
            translate( [0,0,-3] )
                cube( [50,50,6], center=true );
            color( "Blue" )
                hirthJointPlacement( R2, 5 );
        }
    }
}
hirthJointShow( $fn=200 );