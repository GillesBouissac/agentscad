/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Mesh manipulations
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/mesh.scad>
use <agentscad/sew.scad>
use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>
use <scad-utils/lists.scad>

//
// Generates a extrusion of given profile:
//
// @param profile the profile to extrude
// @param height the z height of the generated end profile
// @param caps true to generate start and end caps
// @param vanishLineX vanishing line parallel to x axis
// @param vanishLineY vanishing line parallel to y axis
// @returns a mesh made of the initial profile and the extruded profile
//
module extrude(profile, height, caps=true, vanishLineX=undef, vanishLineY=undef, convexity=undef) {
    meshPolyhedron(extrudeProfile(profile, height, caps=caps, vanishLineX=vanishLineX, vanishLineY=vanishLineY), convexity=convexity);
}

//
// Generates an extrusion of given profile
//
// @param profile the profile to extrude
// @param height the z height of the generated end profile
// @param caps true to generate start and end caps
// @param vanishLineX vanishing line parallel to x axis
// @param vanishLineY vanishing line parallel to y axis
// @returns a mesh made of the initial profile and the extruded profile
//
function extrudeProfile(profile, height, caps=true, vanishLineX=undef, vanishLineY=undef) =
    sewMesh( [ profile, projectProfile(profile, height, vanishLineX=vanishLineX, vanishLineY=vanishLineY) ], caps=caps );


//
// make a prism mesh from a polygon
//
// @param poly polygon to extrude
// @param height prism height
// @returns a mesh made of the initial profile and the extruded profile
//
module prism(poly, height=1, caps=true) {
    meshPolyhedron( prismMesh(poly=poly, height=height, caps=caps ));
}

function prismMesh(poly, height=1, caps=true) =
    extrudeProfile ( transform(translation([0,0,-height/2]), getMeshVertices(poly)), height=height, caps=caps );

//
// make a frustum mesh from a polygon
//
// @param poly polygon to extrude
// @param height frustum height
// @param a frustum angle (0 = vertical)
// @returns a mesh made of the initial profile and the extruded profile
//
module frustum(poly, height=1, angle=-45, caps=true) {
    meshPolyhedron(frustumMesh(poly=poly,height=height,angle=angle,caps=caps));
}

function frustumMesh(poly, height=1, angle=-45, caps=true) =
    let( vertices=getMeshVertices(poly) )
    let( faces=getMeshFaces(poly) )
    let( n=len(vertices) )
    newMesh (flatten([
            for ( i=[0:n-1] )
                let( v=vertices[i] )
                let( i=atan2(v.y,v.x) )
                let( dr=(height/2)*tan(angle) )
                let( dx=dr*cos(i) )
                let( dy=dr*sin(i) )
                [ [v.x-dx,v.y-dy,-height/2], [v.x+dx,v.y+dy,+height/2] ]
        ]),
        [
            if (caps) [ for ( i=[0:n-1] ) 2*faces[0][i] ],
            for( i=[0:2:2*(n-2)] ) [i,i+1,i+3,i+2],
            [2*n-2,2*n-1,1,0],
            if (caps) [ for ( i=[n-1:-1:0] ) 2*faces[0][i]+1 ]
        ]
    );

//
// Scales a profile (list of points) along vectors directed to vanishing lines
//
// input profile is assumed to be in z=0 plane
// 2 vanishing lines can be used:
//   - vanishLineX: [undef,y,z] position of the vanishing line parallel to x axis
//                  Result is a scaling of the projected profile on y
//   - vanishLineY: [x,undef,z] position of the vanishing line parallel to y axis
//                  Result is a scaling of the projected profile on x
//
// for a vanishing point:
//   - vanishLineX.z == vanishLineY.z
//   - the vanishing point coordinates are [vanishLineY.x, vanishLineX.y, vanishLineX.z]
//
// for a vertical scaling:
//   - only on x:  vanishLineX == undef
//   - only on y:  vanishLineY == undef
//   - no scaling: vanishLineX == vanishLineY == undef
//
// @param profile: list of 2D (x,y) points
// @param height the projection stops at specified height
// @returns the projected profile
//
function projectProfile(profile, height, vanishLineX=undef, vanishLineY=undef) =
let (
    vy = is_undef(vanishLineY) ? [0,0,0] : [ vanishLineY.x, 0, vanishLineY.z ],
    vx = is_undef(vanishLineX) ? [0,0,0] : [ 0, vanishLineX.y, vanishLineX.z ],

    try = is_undef(vanishLineX) ? identity4() :
        translation(+vx) * scaling([1, (vx.z - height)/vx.z, 1]) * translation(-vx),
    trx = is_undef(vanishLineY) ? identity4() :
        translation(+vy) * scaling([(vy.z - height)/vy.z, 1, 1]) * translation(-vy)
) transform(translation([0,0,height]) * try * trx, profile);
