/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Some geometrical functions
 * Author:      Gilles Bouissac
 */

use <scad-utils/linalg.scad>
use <scad-utils/spline.scad>
use <agentscad/extensions.scad>


// ----------------------------------------
//           3D Geometry
// ----------------------------------------

// Normalise a plane defined this way
//   [
//      [px, py, pz], // mandatory: any point on the plane
//      [nx, ny, nz], // mandatory: vector normal to the plane
//      [ox, oy, oz]  // optional:  vector origin (default [0,0,0])
//   ]
function plane3(plane) =
    let( _p = vec3(plane[0]) )
    let( _o = len(plane)>2 ? vec3(plane[2]) : [0,0,0] )
    let( _n = vec3(plane[1])-_o)
[ _p, _n, [0,0,0] ];

// Normalise a line defined this way
//   [
//      [px, py, pz], // mandatory: any point on the line
//      [vx, vy, vz], // mandatory: vector parallel to the line
//      [ox, oy, oz]  // optional:  vector origin (default [0,0,0])
//   ]
function line3(line) =
    let( _p = vec3(line[0]) )
    let( _o = len(line)>2 ? vec3(line[2]) : [0,0,0] )
    let( _v = vec3(line[1])-_o)
[ _p, _v, [0,0,0] ];

// ----------------------------------------
//           3D Operations
// ----------------------------------------

// Intersection of three planes (Graphics Gems 1 - V.4)
//    - PInt={(P1.N1)(V2xV3)+(P2.V2)(V3xV1)+(P3.V3)(V1xV2)}/Det(V1,V2,V3).
// Params:
//    - p1,p2,p3: 3 plane3
// Returns:
//    - undef if 2 of the 3 planes are parallels
//    - otherwise: a 3D point
function intersec_planes_3(p1,p2,p3) =
    let( _pl1=plane3(p1) )
    let( _pl2=plane3(p2) )
    let( _pl3=plane3(p3) )
    let( _p1=_pl1[0], _p2=_pl2[0], _p3=_pl3[0] )
    let( _n1=_pl1[1], _n2=_pl2[1], _n3=_pl3[1] )
    let( d=det([_n1,_n2,_n3]) )
d==0 ? undef : (
    (_p1*_n1)*cross(_n2,_n3)+
    (_p2*_n2)*cross(_n3,_n1)+
    (_p3*_n3)*cross(_n1,_n2)
)/d;

// Intersection of two planes
//    - computation derived from intersec_planes_3
//      we create the 3rd plane with:
//        - point [0,0,0]
//        - normal computed as the normal to input planes normal
//      this give the common points to the 3 planes
// Params:
//    - p1,p2: 2 plane3
// Returns:
//    - undef if 2 planes are parallels
//    - otherwise: a 3D line defined this way:
//      [
//         [px, py, pz], // one point on the line
//         [vx, vy, vz]  // direction vector of the line
//      ]
function intersec_planes_2(p1,p2) =
    let( _pl1=plane3(p1) )
    let( _pl2=plane3(p2) )
    let( _p1=_pl1[0], _p2=_pl2[0] )
    let( _n1=_pl1[1], _n2=_pl2[1] )
    let( _n3=cross(_n1,_n2) )
    let( _p3=intersec_planes_3(p1,p2,[[0,0,0],_n3]) )
is_undef(_p3) ? undef : [_p3,_n3,[0,0,0]];


// ----------------------------------------
//  Useful tools to show basic 3D objects
// ----------------------------------------

module renderPoint(point) {
    let( pt=vec3(point) )
    translate(pt)
        sphere( 0.1 );
}
module renderPoints(points) {
    for ( p=points ) renderPoint(p);
}
module renderPlane(plane, size=10) {
    let( _pl=plane3(plane) )
    let( pt=_pl[0], vn=_pl[1] )
    let( a=angle_vector(vn,[0,0,1]) )
    let( c=cross(vn,[0,0,1]) )
    {
        renderPoints([pt]);
        translate(pt)
            rotate(-a,c)
            cube( [size,size,0.01], center=true );
    }
}
module renderPlanes(planes, size=10) {
    for ( p=planes ) renderPlane(p,size);
}
module renderLine(line, length=undef) {
    let( pt=vec3(line[0]), vc=vec3(line[1]) )
    let( _l=is_undef(length) ? norm(vc) : length )
    let( a=angle_vector(vc,[0,0,1]) )
    let( c=cross(vc,[0,0,1]) )
    {
        renderPoints([pt]);
        translate(pt)
            rotate(-a,c)
            cylinder( r=0.05, h=_l, center=true );
    }
}
module renderLines(lines) {
    for ( l=lines ) renderLine(l);
}


