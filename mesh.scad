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

// ----------------------------------------
//           Base API
// ----------------------------------------

function classMesh()      = "mesh";

//
// Converts a mesh to a polyhedron module
//
module meshPolyhedron ( mesh, convexity=undef ) {
    class = assertClass(mesh,classMesh());
    convexity = is_undef(convexity) ? 2 : convexity;
    polyhedron ( points=getMeshVertices(mesh), faces=getMeshFaces(mesh), convexity=convexity );
}

//
// Creates a new mesh from a list of vertices and faces
//
function newMesh( vertices, faces ) = [ classMesh(), vertices, faces ];

// Accessor to the list of vertices in a mesh
// @return the list of 3D points
function getMeshVertices( mesh )    = let(class = assertClass(mesh,classMesh())) mesh[1];

// Accessor to the list of faces in a mesh
// @return the list of vertex indices in the mesh
function getMeshFaces( mesh )       = let(class = assertClass(mesh,classMesh())) mesh[2];


// ----------------------------------------
//           Simple Polygons
// ----------------------------------------

// make a regular polygon mesh
// - n: number of edges in the polygon
// - r: radius of the circumscribed circle
function meshRegularPolygon(n,r=1) = let()
    newMesh (
        regularPolygon(n,r),
        [ [ for( i=[0:n-1] ) i ] ]
    );

// make a regular polygon profile
// - n: number of edges in the polygon
// - r: radius of the circumscribed circle
function regularPolygon(n,r=1) = flatten([
    for ( i=[0:n-1] ) transform(rotation([0,0,i*360/n]),[[r,0,0]])
]);
