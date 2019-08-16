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
MFG    = 0.01;  // ManiFold Guard
VGG    = 1;     // Visual Glich Guard
MARGIN = 0.2;
NOZZLE = 0.4;
R1_MIN_NOZZLE = 5;

module hirthJointSinus ( rmax, tooth, height, shoulder=0, inlay=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/tooth;

    hirthJoint ( rmax, tooth, height, shoulder, inlay )
        hirthJointProfileSinus ( width, th );
}

module hirthJointTriangle ( rmax, tooth, height, shoulder=0, inlay=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/tooth;

    hirthJoint ( rmax, tooth, height, shoulder, inlay )
        hirthJointProfileTriangle ( width, th );
}

module hirthJointRectangle ( rmax, tooth, height, shoulder=0, inlay=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/tooth;

    hirthJoint ( rmax, tooth, height, shoulder, inlay )
        hirthJointProfileRectangle ( width, th );
}

module hirthJointPassage ( rmax, inlay=0 ) {
    translate( [0,0,-inlay/2] )
        cylinder( r=(rmax+MARGIN)/cos(30), h=inlay+2*MARGIN, center=true, $fn=6 );
}


// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------
module hirthJoint ( rmax, tooth, height, shoulder=0, inlay=0 ) {

    rmin  = R1_MIN_NOZZLE*NOZZLE*tooth/(2*PI);
    angle = 360/tooth;
    width = 2*PI*rmax/tooth;

    echo ( "hirthJoint rmin: ",                rmin );
    echo ( "hirthJoint tooth angle (degre): ", angle );
    echo ( "hirthJoint tooth width: ",         width );

    translate( [0,0,+shoulder] )
    intersection() {
        translate( [0,0,+height/2] )
        difference () {
            cylinder( r=rmax, h=height,     center=true );
            cylinder( r=rmin, h=height+VGG, center=true );
        }

        for ( a=[0:360/tooth:359] ) {
            rotate( [0,0,a] )
                if ( $children>0 ) {
                    hirthJointTooth( rmax, width, height )
                        children(0);
                }
                else {
                    alpha = atan( (height/2)/rmax );
                    th = (rmax*tan(2*alpha)/cos(alpha))/2;
                    hirthJointTooth( rmax, width, height )
                        hirthJointProfileSinus(width,th);
                }
        }
    }
    translate( [0,0,+shoulder/2] )
    difference () {
        cylinder( r=rmax, h=shoulder,     center=true );
        cylinder( r=rmin, h=shoulder+VGG, center=true );
    }
    translate( [0,0,-inlay/2] )
        cylinder( r=rmax/cos(30), h=inlay, center=true, $fn=6 );
}

module hirthJointProfileSinus ( width, height ) {
    polygon ([
        for ( i=[-width/2-MFG:+width/30:+width/2+MFG] )
            [height/2*cos(i*360/width)+height/2,i]
    ]);
}

module hirthJointProfileTriangle ( width, height ) {
    polygon ([
        [0,-width/2],
        [0,+width/2],
        [height,0],
    ]);
}

module hirthJointProfileRectangle ( width, height ) {
    polygon ([
        [0,-width/2],
        [0,-width/4+MARGIN/2],
        [height,-width/4+MARGIN/2],
        [height,+width/4-MARGIN/2],
        [0,+width/4-MARGIN/2],
        [0,+width/2],
    ]);
}

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
        children();
}

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
                color( "Salmon" )
                    hirthJointPassage( RADIUS, INLAY );
            }
        }
    }
}
difference() {
    hirthJointShow( 0, $fn=200 );
    cylinder( r=1.5+MARGIN/2, h=100, center=true, $fn=200 );
}
