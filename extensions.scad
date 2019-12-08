/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD extensions to scad language
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/linalg.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// ManiFold Guard
MFG = 0.01;
function mfg(mult=1) = is_undef($mfg) ? mult*MFG : mult*$mfg;

// Modulo
function mod(a,m) = a - m*floor(a/m);

// Sums all the elements of a list of elements
function sum(l) = __sum(l,0);

// Returns a vector of distance from each point in list and ref
function distanceToPoint ( list, ref ) =
let ( ref3=vec3(ref) ) [
    for ( e=list )
        norm ( vec3(e)-ref3 )
];

// Computes angle (degree) for the given fragment of circle ciconference
function angle_for_circ ( circ, radius ) = (180/PI)*(circ/radius);

// Computes ciconference fragment for the given circle angle (degree)
function circ_for_angle ( angle, radius ) = (180/PI)*(angle*radius);

// Computes angle (degree) for the given segment length that cut the circle
function angle_for_cut ( segment, radius ) = radius==0 ? 360 : 2*asin((segment/2)/radius);

// input : list of numbers
// output: sorted list of numbers
function sortNum(arr) = [ for ( e=sortIndexed(arr) ) e[0] ];

// input : list of numbers
// output: sorted list of numbers in couple [value,originalIdx]
function sortIndexed(arr) = !(len(arr)>0) ? [] : let(
    indexed = [ for ( i=[0:len(arr)-1] ) [ arr[i], i ]  ]
) __sortIndexed( indexed );

// Returns the index in list of the closest point to ref
function closestToPoint ( list, ref=undef ) =
let (
    sorted_dist = is_undef(ref) ? list : sortIndexed ( distanceToPoint(list,ref) )
) sorted_dist[0][1];

// Turn points in buffer so that element at index idx becomes element at index 0
function rotateBuffer( list, idx ) = 
let (
    pivot  = idx==0 ? [] : [ list[idx] ],
    before = idx==0 ? [] : (idx-1<0) ? [] : [ for (i=[0:idx-1]) list[i] ],
    after  = idx==0 ? [] : (idx+1>len(list)-1) ? [] : [ for (i=[idx+1:len(list)-1]) list[i] ]
) idx==0 ? list : concat( pivot, after, before );

// After this function the point at idx=0 is the closest point to zenith
function faceTheZenith( list, zenith=[0,100000] ) = rotateBuffer(list,closestToPoint(list,zenith));

// Compute a profile made from ratio of 2 given profiles
// The total participation of both profiles is 1
// We assume that:
//   - profile1 and profile2 are 3D points vectors
//   - profile1 and profile2 have the exact same number of points
//     use augment_profile from skin.scad if they don't
function interpolateProfile(profile1, profile2, t, speed=1) = [
    for ( i=[0:len(profile1)-1] )
        [   (1-t)*profile1[i].x+t*profile2[i].x,
            (1-t)*profile1[i].y+t*profile2[i].y,
            (1-pow(t,speed))*profile1[i].z+pow(t,speed)*profile2[i].z
        ]
];

function vec2(p) = len(p) < 2 ? concat(p,0) : [p[0],p[1]];
function to_2d(list) = [ for(v = list) vec2(v) ];

// Keep the original object and add a mirrored copy
module cloneMirror( m ) {
    children();
    mirror(m) children();
}
// Keep the original object and add a scaled copy
module cloneScale( m ) {
    children();
    scale(m) children();
}
// Keep the original object and add a rotated copy
module cloneRotate( m ) {
    children();
    rotate(m) children();
}
// Keep the original object and add a translated copy
module cloneTranslate( m ) {
    children();
    translate(m) children();
}

// r: cylinders radius
// h: oblong height
// i: interval between cylinders axis
// center: @see cylinder
module oblong ( r, h=1, i=0, center=false ) {
    if ( i>0 ) {
        translate( [0,+i/2,0] )
            cylinder( r=r, h=h, center=center );
        translate( [0,-i/2,0] )
            cylinder( r=r, h=h, center=center );
        translate( [0,0,center ? 0 : h/2 ] )
            cube( [ 2*r, i, h ], center=true ) ;
    }
    else {
        cylinder( r=r, h=h, center=center );
    }
}

// Rotates a shape from [0,0,1] to given vector
module alignOnVector(v) {
    length = norm([v.x,v.y,v.z]);  // radial distance
    b = acos(v.z/length);          // inclination angle
    c = atan2(v.y,v.x);            // azimuthal angle
    rotate([0, b, c])
        children();
}

// ----------------------------------------
//              Implementation
// ----------------------------------------
function __sortIndexed(arr) = !(len(arr)>0) ? [] : let(
    pivot   = arr[floor(len(arr)/2)][0],
    lesser  = [ for (y = arr) if (y[0]  < pivot) y ],
    equal   = [ for (y = arr) if (y[0] == pivot) y ],
    greater = [ for (y = arr) if (y[0]  > pivot) y ]
) concat(
    __sortIndexed(lesser), equal, __sortIndexed(greater)
);
function __sum(l,i=0) = i<len(l)-1 ? l[i] + __sum(l,i+1) : l[i];

