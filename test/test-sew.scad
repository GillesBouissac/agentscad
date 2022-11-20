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
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <agentscad/sew.scad>



unevenSurface = [
	[ [0,1,0], [3,0,0], [6,1,0] ],
	[ [0,1,1], [2,0,1], [4,0,1], [6,1,1] ],
	[ [0,1,2], [1,0,2], [2,0,2], [3,-0.5,2], [4,0,2], [5,0,2], [6,1,2] ],
	[ [0,1,3], [2,0,3], [4,0,3], [6,1,3] ],
	[ [0,1,4], [3,0,4], [6,1,4] ],
];
color("lime")
	translate( [10,0,0] )
	sew(unevenSurface);


radius = 5;
height = 14;
layers = 10;
candleSurface = [
	for (i=[0:layers-1])
		transform(
			translation([0,0,i*height/layers]) * rotation([0,0,-30*i]),
			circle($fn=6,r=radius))
];
color("lightblue")
	difference() {
		sew(candleSurface,convexity=10);
		cylinder(r=1, h=1000, $fn=50);
	}





