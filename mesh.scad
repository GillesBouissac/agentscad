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

// ----------------------------------------
//           API
// ----------------------------------------

function classMesh()      = "mesh";

module meshPolyhedron ( mesh, convexity=undef ) {
    class = assertClass(mesh,classMesh());
    polyhedron ( points=getMeshVertices(mesh), faces=getMeshFaces(mesh), convexity=convexity );
}

function newMesh( vertices, faces ) = [ classMesh(), vertices, faces ];
function getMeshVertices( mesh )    = let(class = assertClass(mesh,classMesh())) mesh[1];
function getMeshFaces( mesh )       = let(class = assertClass(mesh,classMesh())) mesh[2];

