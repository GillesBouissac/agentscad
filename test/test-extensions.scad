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
module showLine( line ) {
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

// ----------------------------------------
//  Showcase
// ----------------------------------------
color( "#99ff66" ) showLine( wrinkle(showPoly2wrinkle,-0.6) );
color( "#ccff66" ) showLine( wrinkle(showPoly2wrinkle,-0.4) );
color( "#ccff33" ) showLine( wrinkle(showPoly2wrinkle,-0.2) );
color( "#66ffff" ) showLine( showPoly2wrinkle );
color( "#ffff66" ) showLine( wrinkle(showPoly2wrinkle,+0.2) );
color( "#ffff99" ) showLine( wrinkle(showPoly2wrinkle,+0.4) );
color( "#ffffcc" ) showLine( wrinkle(showPoly2wrinkle,+0.6) );
color( "#ffffff" ) showLine( wrinkle(showPoly2wrinkle,+0.8) );

// ----------------------------------------
//  Utilities
// ----------------------------------------
function roundDownList(val) = [ for (v=val)
    if ( is_list(v) )
        [ for (c=v) roundDown(c,0.01) ]
    else
        roundDown(v,0.01)
];
