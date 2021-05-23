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
                    hirthJointPassage( RADIUS, HEIGHT, SHOULDER, INLAY );
            }
        }
    }

    if ( part==0 || part==6 )
    translate( [0,50,0] ) {
        translate( [0,0,0] ) {
            hirthJointSinus( 5, 11, 2, 1, 1, shift=0.5, rmin=0 );
            %hirthJointPassage( 5, 2, 1, 1 );
        }

        translate( [15,0,0] ) {
            hirthJointRectangle( 5, 11, 1, 1, 1, shift=0, rmin=2.5 );
            %hirthJointPassage( 5, 1, 1, 1 );
        }
        translate( [30,0,0] ) {
            hirthJointTriangle( 5, 11, 1, 1, 1, shift=0, rmin=4 );
            %hirthJointPassage( 5, 1, 1, 1 );
        }

        translate( [0,15,0] ) {
            difference() {
                union() {
                    // Automatic rmin
                    hirthJointSinus( 5, 11, 1, 1, 1, shift=0.5 );
                    translate( [0,0,3+0.01] )
                    rotate([0,180,0])
                        hirthJointSinus( 5, 11, 1, 1, 1, shift=0.5 );
                }
                translate( [0,-500,0] )
                    cube( 1000, center=true );
            }
        }
        translate( [15,15,0] ) {
            difference() {
                union() {
                    hirthJointRectangle( 5, 11, 1, 1, 1, shift=0.5 );
                    translate( [0,0,3+0.01] )
                    rotate([0,180,0])
                        hirthJointRectangle( 5, 11, 1, 1, 1, shift=0.5 );
                }
                cylinder(r=2.5,h=10, center=true);
            }
        }
        translate( [30,15,0] ) {
            difference() {
                union() {
                    hirthJointTriangle( 5, 11, 1, 1, 1, shift=0.5 );
                    translate( [0,0,3+0.01] )
                    rotate([0,180,0])
                        hirthJointTriangle( 5, 11, 1, 1, 1, shift=0.5 );
                }
                cylinder(r=2.5,h=10, center=true);
            }
        }

        echo ("test=", hirthJointProfileSinus(1) );
    }

}

$fn=50;

difference() {
    hirthJointShow( 0 );
    cylinder( r=1.5+MARGIN/2, h=100, center=true );
}
