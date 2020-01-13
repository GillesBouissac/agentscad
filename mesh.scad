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




module meshPolyhedron ( mesh ) {
    polyhedron ( points=mesh[0], faces=mesh[1] );
}

function newMesh( vertices, faces ) = [ vertices, faces ];
function getMeshVertices( mesh ) = mesh[0];
function getMeshFaces( mesh )    = mesh[1];



