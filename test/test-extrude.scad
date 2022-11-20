/*
 * Copyright (c) 2022, Gilles Bouissac
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
use <agentscad/extrude.scad>

translate([+4.5,0,0])
extrude(regularPolygon(100), 1, false, [undef,2,2], [0,undef,4] );

translate([+4.5,3,0])
extrude(regularPolygon(100), 1, true, [undef,0,4], [2,undef,2] );

translate([+1.5,0,0])
extrude(regularPolygon(12), 1, true, [undef,1,1] );

translate([+1.5,3,0])
extrude(regularPolygon(12), 1, true, undef, [1,undef,1] );

translate([-1.5,0,0])
extrude(regularPolygon(8), 1, true, [undef,1,1], [0,undef,1.3] );

translate([-1.5,3,0])
extrude(regularPolygon(8), 1, true, [undef,0,1.3], [1,undef,1] );

translate([-4.5,3,0])
extrude(regularPolygon(3), 1 );

translate([-4.5,0,0])
extrude(regularPolygon(3), 1, true, [undef,0,1], [0,undef,1] );

translate([-1.5,6,0])
prism(meshRegularPolygon(6));

translate([-4.5,6,0])
prism(meshRegularPolygon(12), caps=false);

translate([1.5,6,0])
frustum(meshRegularPolygon(7), 1, 30);

translate([4.5,6,0])
frustum(meshRegularPolygon(7), 1, 30, caps=false);
