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

use <agentscad/extensions.scad>
use <scad-utils/transformations.scad>
use <scad-utils/lists.scad>
use <scad-utils/linalg.scad>
use <list-comprehension-demos/skin.scad>

// ----------------------------------------
//           Base API
// ----------------------------------------

function classMesh()      = "mesh";

module meshPolyhedron ( mesh, convexity=undef ) {
    class = assertClass(mesh,classMesh());
    polyhedron ( points=getMeshVertices(mesh), faces=getMeshFaces(mesh), convexity=convexity );
}

function newMesh( vertices, faces ) = [ classMesh(), vertices, faces ];
function getMeshVertices( mesh )    = let(class = assertClass(mesh,classMesh())) mesh[1];
function getMeshFaces( mesh )       = let(class = assertClass(mesh,classMesh())) mesh[2];


// ----------------------------------------
//           Helpers API
// ----------------------------------------

// make a regular polygon
// the result is a mesh with only one face
// - n: number of edges in the polygon
// - r: radius of the circumscribed circle
function meshRegularPolygon(n,r=1) =
    newMesh (
        flatten([
            for ( i=[0:n-1] ) transform(rotation([0,0,i*360/n]),[[r,0,0]])
        ]),
        [ [ for( i=[0:n-1] ) i ] ]
    );

// make a prism mesh from a polygon
//   the given polygon defines the center profile of the generated prism centered on z=0
// - poly: polygon to prism
// - h: prism height
function meshPrism(poly,h=1) =
    meshExtrude ( transform(translation([0,0,-h/2]), getMeshVertices(poly)), h );

// make a frustum mesh from a polygon
//   the given polygon defines the center profile of the generated frustum centered on z=0
// - poly: polygon to transform
// - h: frustum height
// - a: frustum angle (0 = vertical)
function meshFrustum(poly,h=1,a=-45) =
    let( vertices=getMeshVertices(poly) )
    let( faces=getMeshFaces(poly) )
    let( n=len(vertices) )
    newMesh (flatten([
            for ( i=[0:n-1] )
                let( v=vertices[i] )
                let( i=atan2(v.y,v.x) )
                let( dr=(h/2)*tan(a) )
                let( dx=dr*cos(i) )
                let( dy=dr*sin(i) )
                [ [v.x-dx,v.y-dy,-h/2], [v.x+dx,v.y+dy,+h/2] ]
        ]),
        [
            [ for ( i=[0:n-1] ) 2*faces[0][i] ],
            for( i=[0:2:2*(n-2)] ) [i,i+1,i+3,i+2],
            [2*n-2,2*n-1,1,0],
            [ for ( i=[n-1:-1:0] ) 2*faces[0][i]+1 ]
        ]
    );

//
// Same as skin from list-comprehension-demos but without buiding the final shape
// Returnes the mesh
//
function skin_quad(i,P,o) = [[o+i, o+i+P, o+i%P+P+1], [o+i, o+i%P+P+1, o+i%P+1]];
function skin_profile_triangles(max_len,tindex) = [
    for (index = [0:max_len-1]) 
        let (qs = skin_quad(index+1, max_len, max_len*(tindex-1)-1)) 
            for (q = qs) q
];
function meshSkin(profiles) = 
let(
	P = max_len(profiles),
	N = len(profiles),

	profiles = [ 
		for (p = profiles)
			for (pp = augment_profile(to_3d(p),P))
				pp
	],

    triangles = [ 
		for(index = [1:N-1])
        	for(t = skin_profile_triangles(P,index)) 
				t
	],

	start_cap = [range([0:P-1])],
	end_cap   = [range([P*N-1 : -1 : P*(N-1)])]
) newMesh ( profiles, concat(start_cap, triangles, end_cap) );

//
// Scales a profile (list of points) along vectors directed to vanishing lines
//
// input profile is assumed to be in z=0 plane:
//   - profile: list of 2D (x,y) points
//   - height: The projection stops at specified height
//
// 2 vanishing lines can be used:
//   - vanishLineX: [-,y,z] position of the vanishing line parallel to x axis
//   - vanishLineY: [x,-,z] position of the vanishing line parallel to y axis
//
// for a vanishing point:
//   - vanishLineX.z == vanishLineY.z
//
// for a vertical projection:
//   - on Y: vanishLineX == undef
//   - on X: vanishLineY == undef
//   - on both: vanishLineX == vanishLineY == undef
//
function meshProjectProfile(profile, height, vanishLineX, vanishLineY=undef) =
let (
    vy = is_undef(vanishLineY) ? [0,0,0] : [ vanishLineY.x, 0, vanishLineY.z ],
    vx = is_undef(vanishLineX) ? [0,0,0] : [ 0, vanishLineX.y, vanishLineX.z ],

    try = is_undef(vanishLineX) ? identity4() :
        translation(+vx) * scaling([1, (vx.z - height)/vx.z, 1]) * translation(-vx),
    trx = is_undef(vanishLineY) ? identity4() :
        translation(+vy) * scaling([(vy.z - height)/vy.z, 1, 1]) * translation(-vy)
) transform(translation([0,0,height]) * try * trx, profile);

//
// Generates an extrusion of given profile:
//   - along z axis
//   - the extrusion stops at specified height
//   - the extrusion follows vectors directed to vanishing lines
//
function meshExtrude(profile, height, vanishLineX, vanishLineY=undef) =
    meshSkin( [ profile, meshProjectProfile(profile, height, vanishLineX, vanishLineY) ] );

// ----------------------------------------
//               Showcase
// ----------------------------------------

module showParts() {
    translate([-12,0,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, [undef,2,2], [0,undef,4] ) );

    translate([-12,3,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, [undef,0,4], [2,undef,2] ) );

    translate([-9,0,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, [undef,1,1] ) );

    translate([-9,3,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, undef, [1,undef,1] ) );

    translate([-6,0,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, [undef,1,1], [0,undef,1.3] ) );

    translate([-6,3,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, [undef,0,1.3], [1,undef,1] ) );

    translate([-3,3,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1 ) );

    translate([-3,0,0])
    meshPolyhedron( meshExtrude(getMeshVertices(meshRegularPolygon(8)), 1, [undef,0,1], [0,undef,1] ) );

    translate([0,0,0])
    meshPolyhedron( meshRegularPolygon(5) );

    translate([3,0,0])
    meshPolyhedron( meshPrism(meshRegularPolygon(6)) );

    translate([6,0,0])
    meshPolyhedron( meshFrustum(meshRegularPolygon(7), 1, 30) );
}

*
showParts();
