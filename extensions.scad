/*
 * Copyright (c) 2021, Gilles Bouissac
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
use <scad-utils/transformations.scad>

// ----------------------------------------
//           Control
// ----------------------------------------

// ManiFold Guard
MFG = 0.01;
function mfg(mult=1) = is_undef($mfg) ? mult*MFG : mult*$mfg;

// Step in range [0:1] from $fn/ratio
function getStep(ratio=1) = ratio/($fn<=0 ? 10 : $fn );

// Check if given value is defined and in range [minv:maxv],
// If not returns the closest range limit,
//   or default value if undef,
// default defv is optional, minv is returned if not given
function forceValueInRange ( value, minv, maxv, defv ) = let (
    _min = is_undef(minv)?-1e6:minv,
    _max = is_undef(maxv)?+1e6:maxv,
    _def = is_undef(defv)?_min:defv
) is_undef(value)?_def:(value<_min?_min:(value>_max?_max:value)) ;

// Object class accessors/control
function getClass(object) = is_list(object) ? object[0] : undef;
function isClass(object,class) = let (
    classList = [ if(is_list(class)) class else [class] ][0],
    found = [ for ( c=classList ) if ( c==getClass(object) ) c ]
) len(found)>0 ;
function assertClass(object,class) = let (
    classList = [ if(is_list(class)) class else [class] ][0],
    a = assert( isClass( object, classList ),
        str("object class \"",getClass(object),"\" not in ", classList) )
) a ;

// ----------------------------------------
//           Mathematics
// ----------------------------------------

// Round down a as multiple of m
function roundDown(a,m) = let(ar=round(a*1000000),mr=round(m*1000000)) (mr*floor(ar/mr))/1000000;

// Modulo
function mod(a,m) = a - roundDown(a,m);

// Sums all the elements of a list of elements
function sum(l) = __sum(l,0);

INCH=25.4;

// millimeter to inch conversion
// - if d is a vector every number will be converted, non number are preserved unchanged
function mm2inch(d) =
    is_list(d) ?
    [ for ( e=d ) is_num(e) ? e/INCH : e ]
    :
    is_num(d) ? d/INCH : d ;

// inch to millimeter conversion
// - if d is a vector every number will be converted, non number are preserved unchanged
function inch2mm(d) =
    is_list(d) ?
    [ for ( e=d ) is_num(e) ? e*INCH : e ]
    :
    is_num(d) ? d*INCH : d ;

// ----------------------------------------
//           Lists 
// ----------------------------------------

// input : list of numbers
// output: sorted list of numbers
function sortNum(arr) = [ for ( e=sortIndexed(arr) ) e[0] ];

// input : list of numbers
// output: sorted list of numbers in couple [value,originalIdx]
function sortIndexed(arr) = !(len(arr)>0) ? [] : let(
    indexed = [ for ( i=[0:len(arr)-1] ) [ arr[i], i ]  ]
) __sortIndexed( indexed );

// Sum all the numbers at column 'col' of every element from list
//   only elements at indexes [start:end] are taken into account
//   if col=undef then elements from list are considered as numbers
function columnSum ( list, col=undef, start=undef, end=undef ) =
    __columnSum(list,col,start,end,0);

// ----------------------------------------
//           Euclidean space functions
// ----------------------------------------
function vec2(p) = len(p) < 2 ? concat(p,0) : [p[0],p[1]];
function vec3(p) = len(p) < 3 ? concat(p,0) : [p[0],p[1],p[2]];
function to_2d(list) = [ for(v = list) vec2(v) ];
function unit(v) = let( n=norm(v) ) n==0 ? [0,0,1] : v/n;

// Returns a vector of distance from each point in list and ref
function distanceToPoint ( list, ref ) =
let ( ref3=vec3(ref) ) [
    for ( e=list )
        norm ( vec3(e)-ref3 )
];

// Returns the index in list of the closest point to ref
function closestToPoint ( list, ref=undef ) =
let (
    sorted_dist = is_undef(ref) ? list : sortIndexed ( distanceToPoint(list,ref) )
) sorted_dist[0][1];

// Computes angle (degree) for the given fragment of circle ciconference
function angle_for_circ ( circ, radius ) = (180/PI)*(circ/radius);

// Computes ciconference fragment for the given circle angle (degree)
function circ_for_angle ( angle, radius ) = (180/PI)*(angle*radius);

// Computes angle (degree) for the given segment length that cut the circle
function angle_for_cut ( segment, radius ) = radius==0 ? 360 : 2*asin((segment/2)/radius);

// https://stackoverflow.com/a/33920320
//    atan2( (Va x Vb) . Vn, Va . Vb)
function angle_vector ( a, b ) =
let ( va = vec3(a) )
let ( vb = vec3(b) )
let ( vc = cross(va,vb) )
let ( vn = unit(vc) )
atan2 ( vc*vn, va*vb );

// Apply a rotation matrix on a 2D vector for given angle
function rot2d ( v, a ) = [ [cos(a), -sin(a)], [sin(a), cos(a)] ]*v;

//
// Project given list of vertices on a sphere using cylindrical projection
//    Point x and y places the point on the sphere, z augments radius for elevation
// The whole sphere is covered by points where:
//    x = [0,2] from left to right
//    y = [0,1] from bottom to top
//
// vertices: list of 3D vertices to project
// radius:   radius of the sphere (elevation 0)
//
function projectSphereCylindrical ( vertices, radius=undef ) =
let ( r=forceValueInRange(radius,minv=0,defv=100) ) [
    for ( pt=vertices ) let (
        theta     = 180*(1-pt.y),
        phi       = 180*pt.x,
        elevation = r+pt.z
    ) [ elevation*sin(theta)*cos(phi), elevation*sin(theta)*sin(phi), elevation*cos(theta) ]
];

//
// Project given list of vertices on a sphere using cylindrical projection
//    Point x and y places the point on the cylinder, z augments radius for elevation
// The whole cylinder is covered by points where:
//    x = [0,2] from left to right
//    y = [0,1] from bottom to top
//
// vertices: list of 3D vertices to project
// radius:   radius of the cylinder (elevation 0)
// height:   cylinder height
//
function projectCylinder ( vertices, radius=undef, height=undef ) =
let (
    r=forceValueInRange(radius,minv=0,defv=height/PI),
    h=forceValueInRange(height,minv=0,defv=radius*PI)
)[
    for ( pt=vertices ) let (
        z         = h*(pt.y-0.5),
        phi       = 180*pt.x,
        elevation = r+pt.z
    )
    [ elevation*cos(phi), elevation*sin(phi), z ]
];

// ----------------------------------------
//           List Comprehension
// ----------------------------------------

// Turn points in buffer so that element at index idx becomes element at index 0
function rotateBuffer( list, idx ) = 
let (
    pivot  = idx==0 ? [] : [ list[idx] ],
    before = idx==0 ? [] : (idx-1<0) ? [] : [ for (i=[0:idx-1]) list[i] ],
    after  = idx==0 ? [] : (idx+1>len(list)-1) ? [] : [ for (i=[idx+1:len(list)-1]) list[i] ]
) idx==0 ? list : concat( pivot, after, before );

// After this function the point at idx=0 is the closest point to zenith
function faceTheZenith( list, zenith=[0,100000] ) = rotateBuffer(list,closestToPoint(list,zenith));

// Duplicates the given 2D polygon and shift it
//   the returned polygon's edges are shifted by 'distance' like wrinkles
// source:   2D polygon
// distance: distance between each target edge and source edge
function wrinkle ( source, distance ) = let( last=len(source)-1 )
[
    for ( i=[0:last] ) let (
        c   = source[i],
        p   = (i==0)    ? 2*c-source[i+1] : source[i-1],
        n   = (i==last) ? 2*c-source[i-1] : source[i+1],
        cp  = p-c,
        cn  = n-c,
        p1  = c + distance/norm(cp)*cp,
        n1  = c + distance/norm(cn)*cn,
        p2  = c + rot2d(p1-c,-90),
        n2  = c + rot2d(n1-c,+90),
        a   = sign(cross(n2-c,p2-c))*angle_vector( p2-c, n2-c )/2,
        n3  = c + rot2d(n2-c,a)/cos(a)
    ) n3
];

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

//
// Computes pt.z given its x,y and 4 reference points in a rectangle x1,x2,y1,y2
//   q11, q12, q21, q22 are the corner of the rectangle for which z is known
// see: https://en.wikipedia.org/wiki/Bilinear_interpolation#Unit_square
//
function interpolateBilinear ( pt, q11, q12, q21, q22 ) = let(
    x = (pt.x-q11.x)/(q22.x-q11.x),
    y = (pt.y-q11.y)/(q22.y-q11.y),
    i = q11.z*(1-x)*(1-y) + q21.z*x*(1-y) + q12.z*(1-x)*y + q22.z*x*y
) i;

// ----------------------------------------
//           Modules
// ----------------------------------------

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
    length = norm([v.x,v.y,v.z]);                    // radial distance
    b = length==0 ? 0 : sign(v.x)*acos(v.z/length);  // inclination angle
    c = v.y==0 ? 0 : atan2(v.y,v.x);                 // azimuthal angle
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

function __columnSum ( list, col, start, end, current ) =
let(
    maxEnd   = len(list)-1,
    startIdx = is_undef(start) ? 0      : (start<0    ? 0:start),
    endIdx   = is_undef(end)   ? maxEnd : (end>maxEnd ? maxEnd : end),
    curValue = forceValueInRange ( current, 0 ),
    itemVal  = is_undef(col)     ? list[startIdx] : list[startIdx][col]
) startIdx>endIdx ? curValue : itemVal+__columnSum(list,col,startIdx+1,endIdx,curValue);
