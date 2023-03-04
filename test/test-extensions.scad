/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Test file
 * Author:      Gilles Bouissac
 */

use <scad-utils/transformations.scad>
use <agentscad/extensions.scad>


// ----------------------------------------
//            Test:  reduce
// ----------------------------------------
reduce_0 = reduce(function(a,b) max(a,b),[]);
echo("reduce_0=",reduce_0);
assert(reduce_0==0, "ERROR reduce_0");

reduce_1 = reduce(function(a,b) max(a,b),[2,1,5,10,6,4,3]);
echo("reduce_1=",reduce_1);
assert(reduce_1==10, "ERROR reduce_1");

reduce_2 = reduce(function(a,b) a+b,[2,1,5,10,6,4,3], 10);
echo("reduce_2=",reduce_2);
assert(reduce_2==41, "ERROR reduce_2");

// ----------------------------------------
//            Test:  sum
// ----------------------------------------
sum_0 = sum([]);
echo("sum_0=",sum_0);
assert(sum_0==0, "ERROR sum_0");

sum_1 = sum([2]);
echo("sum_1=",sum_1);
assert(sum_1==2, "ERROR sum_1");

sum_2 = sum([2,1,5,10,6,4,3]);
echo("sum_2=",sum_2);
assert(sum_2==31, "ERROR sum_2");

sum_3 = sum([2,1,5,10,6,4,3],10);
echo("sum_3=",sum_3);
assert(sum_3==41, "ERROR sum_3");

// ----------------------------------------
//            Test:  round_down
// ----------------------------------------
round_down_0 = roundDown(100.45654, 1);
echo("round_down_0=",round_down_0);
assert(round_down_0==100, "ERROR round_down_0");

round_down_1 = roundDown(100.112545, 7);
echo("round_down_1=",round_down_1);
assert(round_down_1==98, "ERROR round_down_1");

round_down_2 = roundDown(100.2135, 13);
echo("round_down_2=",round_down_2);
assert(round_down_2==91, "ERROR round_down_2");

round_down_3 = roundDown(0.12654547897, 0.01);
echo("round_down_3=",round_down_2);
assert(round_down_3==0.12, "ERROR round_down_3");

// ----------------------------------------
//            Test:  angle_vector
// ----------------------------------------
angle_vector_0 = angle_vector([1,0],[0,1]);
echo("angle_vector_0=",angle_vector_0);
assert(angle_vector_0==90, "ERROR angle_vector_0");

angle_vector_1 = angle_vector([0,1],[-1,0]);
echo("angle_vector_1=",angle_vector_0);
assert(angle_vector_1==90, "ERROR angle_vector_1");

angle_vector_2 = angle_vector([-1,0],[0,-1]);
echo("angle_vector_2=",angle_vector_0);
assert(angle_vector_2==90, "ERROR angle_vector_2");

angle_vector_3 = angle_vector([0,-1],[1,0]);
echo("angle_vector_3=",angle_vector_0);
assert(angle_vector_3==90, "ERROR angle_vector_3");

angle_vector_4 = angle_vector([1,0],[-1,0]);
echo("angle_vector_4=",angle_vector_0);
assert(angle_vector_4==180, "ERROR angle_vector_4");

angle_vector_5 = angle_vector([-1,0],[1,0]);
echo("angle_vector_5=",angle_vector_0);
assert(angle_vector_5==180, "ERROR angle_vector_5");

angle_vector_6 = angle_vector([0,1],[0,-1]);
echo("angle_vector_6=",angle_vector_0);
assert(angle_vector_6==180, "ERROR angle_vector_6");

angle_vector_7 = angle_vector([0,-1],[0,1]);
echo("angle_vector_7=",angle_vector_0);
assert(angle_vector_7==180, "ERROR angle_vector_7");

// ----------------------------------------
//            Test:  wrinkle
// ----------------------------------------
module extrudeProfile( line ) {
    lineBot = to_3d(line);
    lineTop = transform( translation([0,0,1]), lineBot);
    showPolyFaces = [ for ( i=[0:len(line)-2] ) [i,len(line)+i,len(line)+i+1,i+1] ];
    polyhedron(points=concat(lineBot,lineTop), faces=showPolyFaces);
}
showPoly2wrinkle = [
    [1,8], [2,7], [2,6], [1,5],   [1,4],
    [2,3], [2,2], [1,2], [1,0.5], [2,0.5] ];

showPoly2wrinkle_0_check = [
    [0.57, 7.57], [1.4, 6.75], [1.4, 6.24], [0.4, 5.24], [0.4, 3.75], [1.4, 2.75], [1.4, 2.6], [0.4, 2.6], [0.4, -0.1], [2, -0.1]];
showPoly2wrinkle_0 = roundDownList(wrinkle(showPoly2wrinkle,-0.6));
echo("showPoly2wrinkle_0 = ", showPoly2wrinkle_0);
assert(showPoly2wrinkle_0==showPoly2wrinkle_0_check,
    "ERROR wrong showPoly2wrinkle_0");

closedPoly = [
    [-1.0, +0.3], [-0.3, +1.0],
    [+0.3, +1.0], [+1.0, +0.3],
    [+1.0, -0.3], [+0.3, -1.0],
    [-0.3, -1.0], [-1.0, -0.3],
];
closedPoly_0 = roundDownList(wrinkle(closedPoly,0.2,true));
closedPoly_0_check = [
    [-1.2, 0.38],  [-0.39, 1.2],
    [0.38, 1.2],   [1.2, 0.38],
    [1.2, -0.39],  [0.38, -1.2],
    [-0.39, -1.2], [-1.2, -0.39]
];
echo("closedPoly_0 = ", closedPoly_0);
assert(closedPoly_0==closedPoly_0_check,
    "ERROR wrong closedPoly_0");

// ----------------------------------------
//  Visual check
// ----------------------------------------
color( "#99ff66" ) extrudeProfile( wrinkle(showPoly2wrinkle,-0.6) );
color( "#ccff66" ) extrudeProfile( wrinkle(showPoly2wrinkle,-0.4) );
color( "#ccff33" ) extrudeProfile( wrinkle(showPoly2wrinkle,-0.2) );
color( "#66ffff" ) extrudeProfile( showPoly2wrinkle );
color( "#ffff66" ) extrudeProfile( wrinkle(showPoly2wrinkle,+0.2) );
color( "#ffff99" ) extrudeProfile( wrinkle(showPoly2wrinkle,+0.4) );
color( "#ffffcc" ) extrudeProfile( wrinkle(showPoly2wrinkle,+0.6) );
color( "#ffffff" ) extrudeProfile( wrinkle(showPoly2wrinkle,+0.8) );

translate([5,0,0]) {
    color("red")
    linear_extrude(height=2)
        polygon( to_2d(closedPoly) );
    color("green")
    translate([0,0,-1])
    linear_extrude(height=2)
        polygon( to_2d(closedPoly_0) );
}

// ----------------------------------------
//  Utilities
// ----------------------------------------
function roundDownList(val) = [ for (v=val)
    if ( is_list(v) )
        [ for (c=v) roundDown(c,0.01) ]
    else
        roundDown(v,0.01)
];
