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
// - poly: polygon to prism
// - h: prism height
function meshPrism(poly,h=1) =
    let( vertices=getMeshVertices(poly) )
    let( faces=getMeshFaces(poly) )
    let( n=len(vertices) )
    newMesh (flatten([
            for ( i=[0:n-1] )
                let( v=vertices[i] )
                [ [v.x,v.y,-h/2], [v.x,v.y,+h/2] ]
        ]),
        [
            [ for ( i=[0:n-1] ) 2*faces[0][i] ],
            for( i=[0:2:2*(n-2)] ) [i,i+1,i+3,i+2],
            [2*n-2,2*n-1,1,0],
            [ for ( i=[n-1:-1:0] ) 2*faces[0][i]+1 ]
        ]
    );

// make a frustum mesh from a polygon
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

translate([0,0,0])
meshPolyhedron( meshRegularPolygon(5) );

translate([3,0,0])
meshPolyhedron( meshPrism(meshRegularPolygon(6)) );

translate([6,0,0])
meshPolyhedron( meshFrustum(meshRegularPolygon(7)) );

