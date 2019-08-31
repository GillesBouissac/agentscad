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
use <list-comprehension-demos/skin.scad>
use <scad-utils/lists.scad>
use <printing.scad>

// ----------------------------------------
//                    API
// ----------------------------------------

// rmax:     Radius of external cylinder containing teeth
// teeth:    Nunber of required teeth
// height:   Teeth height
// shoulder: Shoulder height (base cylinder below teeth)
// inlay:    Inlay height (hexagonal inlay below shoulder)
// shift:    Number of tooth to rotate the resuting teeth set

// Hirth Joint with sinusoidal profile
module hirthJointSinus ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/teeth;

    hirthJoint ( hirthJointProfileSinus(teeth), rmax, teeth, height, shoulder, inlay, shift )
        hirthJointProfileSinus(teeth);
}

// Hirth Joint with triangular profile
module hirthJointTriangle ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/teeth;

    hirthJoint ( hirthJointProfileTriangle(), rmax, teeth, height, shoulder, inlay, shift )
        hirthJointProfileTriangle ();
}

// Hirth Joint with rectangular profile
module hirthJointRectangle ( rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {
    alpha = atan( (height/2)/rmax );
    th = (rmax*tan(2*alpha)/cos(alpha));
    width = 2*PI*rmax/teeth;

    hirthJoint ( hirthJointProfileRectangle(), rmax, teeth, height, shoulder, inlay, shift )
        hirthJointProfileRectangle ();
}

module hirthJointPassage ( rmax, height, shoulder=0, inlay=0 ) {
    height = inlay+height+shoulder;
    translate( [0,0,-inlay] )
        cylinder( r=rmax/cos(30)+gap()/2, h=height, $fn=6 );
}


// ----------------------------------------
//             Implementation
// ----------------------------------------.

VGG           = 1; // Visual Glich Guard for better previews
NB_MIN_NOZZLE = 3; // Minimal nb nozzle pass for a tooth width

module hirthJoint ( profile, rmax, teeth, height, shoulder=0, inlay=0, shift=0 ) {

    rmin  = NB_MIN_NOZZLE*nozzle()*teeth/(2*PI);
    angle = 360/teeth;

//    echo ( "hirthJoint rmin: ",                rmin );
//    echo ( "hirthJoint teeth angle (degre): ", angle );

    translate( [0,0,+shoulder] )
    difference () {
        step=360/teeth;
        rotate ([0,0,shift*step])
        for ( a=[0:step:360] ) {
            rotate( [0,0,a] )
                if ( $children>0 ) {
                    hirthJointTooth( profile, teeth, rmax, angle, height )
                        children(0);
                }
                else {
                    alpha = atan( (height/2)/rmax );
                    th = (rmax*tan(2*alpha)/cos(alpha))/2;
                    hirthJointTooth( hirthJointProfileSinus(teeth), teeth, rmax, angle, height );
                }
        }
        translate( [0,0,+height/2] )
            cylinder( r=rmin, h=height+VGG, center=true );

    }
    if ( shoulder>0 ) {
        translate( [0,0,+shoulder/2] )
        difference () {
            cylinder( r=rmax, h=shoulder,     center=true );
            cylinder( r=rmin, h=shoulder+VGG, center=true );
        }
    }
    if ( inlay>0 ) {
        translate( [0,0,-inlay/2] )
            cylinder( r=rmax/cos(30), h=inlay, center=true, $fn=6 );
    }
}

// Profile job is to give a list at least 3 points with these constraints:
//   x: in range [-1,1]
//   y: in range [0,1], y=0 is the base of the joint
function hirthJointProfileSinus(teeth=1) =
let (
    required_step = $fn>0?teeth*360/$fn:180,
    step = required_step>18?18:required_step
)[
    for ( a=[-180-step/2:step:180+step/2] )
        [a/180,1/2*cos(a)+1/2]
];

function hirthJointProfileTriangle() = [
    [-1, 0],
    [0,  1],
    [1,  0],
];

function hirthJointProfileRectangle() = [
    [-1,0],
    [-1/2+gap()/2,0],
    [-1/2+gap()/2,1],
    [+1/2-gap()/2,1],
    [+1/2-gap()/2,0],
    [+1,0],
];

module hirthJointTooth ( profile, teeth, radius, angle, height ) {

    // The profile must be enought subdivided
    max_dist      = (2*PI/$fn)*radius;
    local_profile = [ for (i = [0:len(profile)-1])
        if ( i==(len(profile)-1) )
            profile[i]
        else
            let(
                dist   = profile[i+1].x-profile[i].x,
                subdiv = ceil(dist/max_dist) > 1 ? ceil(dist/max_dist):1
            )
            for (p = interpolate(profile[i],profile[i+1],subdiv))
                p
    ];
    points = concat (
        flatten([ for ( pr=local_profile )
            let (
                a  = pr.x*angle/2
            )[
                [ radius*cos(a), radius*sin(a), height*pr.y ],
                [ radius*cos(a), radius*sin(a), 0 ],
            ]
        ]),
        [
            [ 0, 0, height/2 ],
            [ 0, 0, 0 ]
        ]
    );
    o1 = len(points)-2;
    o2 = len(points)-1;
    faces = concat (
        flatten([ for ( i=[0:len(local_profile)-2] )
            [
                [ 2*i+1, 2*i+0, 2*i+2, 2*i+3 ],
                [ 2*i+2, 2*i+0, o1 ],
                [ 2*i+1, 2*i+3, o2 ]
            ]
        ]),
        [ [ 0, 1, o2, o1 ] ],
        [ [ 2*(len(local_profile)-1)+1, 2*(len(local_profile)-1)+0, o1, o2 ] ]
    );

    polyhedron(points,faces,convexity=10);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
PRECISION=100;
translate( [0,0,0] ) {
    difference() {
        hirthJointSinus( 5, 11, 2, 1, 1, shift=0.5, $fn=PRECISION );
        cylinder(r=2.5,h=10, center=true, $fn=PRECISION);
    }
    %hirthJointPassage( 5, 2, 1, 1, $fn=PRECISION );
}
translate( [15,0,0] ) {
    difference() {
        hirthJointRectangle( 5, 11, 1, 1, 1, shift=0, $fn=PRECISION );
        cylinder(r=2.5,h=10, center=true, $fn=PRECISION);
    }
    %hirthJointPassage( 5, 1, 1, 1, $fn=PRECISION );
}
translate( [30,0,0] ) {
    difference() {
        hirthJointTriangle( 5, 11, 1, 1, 1, shift=0, $fn=PRECISION );
        cylinder(r=2.5,h=10, center=true, $fn=PRECISION);
    }
    %hirthJointPassage( 5, 1, 1, 1, $fn=PRECISION );
}

translate( [0,15,0] ) {
    difference() {
        union() {
            hirthJointSinus( 5, 11, 1, 1, 1, shift=0.5, $fn=PRECISION );
            translate( [0,0,3+0.01] )
            rotate([0,180,0])
                hirthJointSinus( 5, 11, 1, 1, 1, shift=0.5, $fn=PRECISION );
        }
        cylinder(r=2.5,h=10, center=true, $fn=PRECISION);
    }
}
translate( [15,15,0] ) {
    difference() {
        union() {
            hirthJointRectangle( 5, 11, 1, 1, 1, shift=0.5, $fn=PRECISION );
            translate( [0,0,3+0.01] )
            rotate([0,180,0])
                hirthJointRectangle( 5, 11, 1, 1, 1, shift=0.5, $fn=PRECISION );
        }
        cylinder(r=2.5,h=10, center=true, $fn=PRECISION);
    }
}
translate( [30,15,0] ) {
    difference() {
        union() {
            hirthJointTriangle( 5, 11, 1, 1, 1, shift=0.5, $fn=PRECISION );
            translate( [0,0,3+0.01] )
            rotate([0,180,0])
                hirthJointTriangle( 5, 11, 1, 1, 1, shift=0.5, $fn=PRECISION );
        }
        cylinder(r=2.5,h=10, center=true, $fn=PRECISION);
    }
}
