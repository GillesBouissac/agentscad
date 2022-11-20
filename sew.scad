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
use <agentscad/mesh.scad>
use <agentscad/extensions.scad>
use <scad-utils/lists.scad>

//
// Joint n profiles (list of 2D or 3D points) with triangles
//
// @param profiles the list of profiles to joint
// @param caps true to generate start and end caps
// @param convexity convexity for visualisation before rendering
// @return a polyhedron
//
module sew(profiles,caps=true,convexity=undef) {
	mesh = sewMesh(profiles,caps);
	meshPolyhedron(mesh,convexity=convexity);
}

//
// Joint n profiles (list of 2D or 3D points) with triangles
//
// @param profiles the list of profiles to joint
// @param caps true to generate start and end caps
// @return a list of faces
//
function sewMesh(profiles,caps=true) = let(
	n = len(profiles),
	lengths = concat([ for (p=profiles) len(p)],[0]),
	o = [ for (i=[0:len(lengths)-1]) [columnSum(lengths,start=0,end=i-1), lengths[i]] ],
	vertexes = flatten(profiles),
	faces = flatten([
		for (i=[0:n-2])
			sewSelf (vertexes,o[i][0],o[i+1][0],o[i][1],o[i+1][1])
	]),
	scap = caps ? [range([        0 : +1 : o[  1][0]-1])] : [],
	ecap = caps ? [range([o[n][0]-1 : -1 : o[n-1][0]])] : []
) newMesh(vertexes, caps ? concat(scap,faces,ecap) : faces) ;

//
// Joint 2 list of point from the same input profile (list of 2D or 3D points) with triangles
//
// @param points list of points to sew in a continuous list
// @param s1 index of the first point of the first list
// @param s2 index of the first point of the second list
// @param l1 number of points in the first list
// @param l2 number of points in the second list
// @return a list of faces made with 3 indexes of points from input list of points
//
function sewSelf (points,s1,s2,l1=2,l2=2) = (l1<2 || l2<2) ? [] : _sewSelfFrom (points,s1,s2,l1,l2,0,0);
function _sewSelfFrom (points,s1,s2,l1,l2,i1,i2) = let(
	// Candidates for next move
	c1 = i1<l1 ? i1+1 : i1,
	c2 = i2<l2 ? i2+1 : i2,
	// Amount of move on each profile
	p1 = c1/l1,
	p2 = c2/l2,
	// Next move is the one that move less
	movep1 = (c1!=i1) && ((p1==p2 && (l1<l2 || c2==i2)) || (p1<p2)),
	movep2 = (c2!=i2) && !movep1,
	n1 = movep1 ? c1 : i1,
	n2 = movep1 ? i2 : c2,
	triangle = movep1 ? [s1+i1%l1, s2+i2%l2, s1+c1%l1] : [s1+i1%l1, s2+i2%l2, s2+c2%l2]
) (movep1 || movep2) ? concat([triangle], _sewSelfFrom(points,s1,s2,l1,l2,n1,n2)) : [] ;

