/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Hirth Joint modelisation
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
R1_MIN_NOZZLE = 3;

// rmax:     Radius of external cylinder containing teeth
// teeth:    Nunber of required teeth
// height:   Teeth height
// shoulder: Shoulder height (base cylinder below teeth)
// inlay:    Inlay height (hexagonal inlay below shoulder)
// shift:    Number of tooth to rotate the resuting teeth set
module hirthJointSinus ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/teeth;

    hirthJoint ( rmax, teeth, height, shoulder, inlay, shift )
        hirthJointProfileSinus ( width, th );
}

module hirthJointTriangle ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/teeth;

    hirthJoint ( rmax, teeth, height, shoulder, inlay, shift )
        hirthJointProfileTriangle ( width, th );
}

module hirthJointRectangle ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/teeth;

    hirthJoint ( rmax, teeth, height, shoulder, inlay, shift )
        hirthJointProfileRectangle ( width, th );
}

module hirthJointPassage ( rmax, height, shoulder=0, inlay=0 ) {
    height = inlay+height+shoulder;
    translate( [0,0,-inlay-MARGIN] )
        cylinder( r=(rmax+MARGIN)/cos(30), h=height+2*MARGIN, $fn=6 );
}


// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------
module hirthJoint ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {

    rmin  = R1_MIN_NOZZLE*NOZZLE*teeth/(2*PI);
    angle = 360/teeth;
    width = 2*PI*rmax/teeth;

    echo ( "hirthJoint rmin: ",                rmin );
    echo ( "hirthJoint teeth angle (degre): ", angle );
    echo ( "hirthJoint teeth width: ",         width );

    translate( [0,0,+shoulder] )
    intersection() {
        translate( [0,0,+height/2] )
        difference () {
            cylinder( r=rmax, h=height,     center=true );
            cylinder( r=rmin, h=height+VGG, center=true );
        }

        rotate ([0,0,shift*360/teeth])
        for ( a=[0:360/teeth:359] ) {
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
difference() {
    hirthJointSinus( 5, 11, 1, 1, 1, shift=0.5, $fn=100 );
    cylinder(r=2.5+MARGIN,h=10,center=true, $fn=100);
}
translate( [15,0,0] )
    hirthJointRectangle( 5, 11, 1, 1, 1, shift=0, $fn=100 );
