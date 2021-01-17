/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Some geometrical functions
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/geometry.scad>
use <scad-utils/linalg.scad>


// ----------------------------------------
// TEST intersec_planes_3
// ----------------------------------------

test_ip3_0_planes = [
    [ [-3,4,0], [0,0,2] ],
    [ [-4,0,4], [0,3,0] ],
    [ [0,1,-2],  [4,0,0] ] ];
test_ip3_0 = intersec_planes_3(
    test_ip3_0_planes[0],
    test_ip3_0_planes[1],
    test_ip3_0_planes[2]
);
color("yellow") renderPlanes(test_ip3_0_planes);
color("red") renderPoints([test_ip3_0]);
echo("test_ip3_0=",roundDownList(test_ip3_0));
assert(roundDownList(test_ip3_0)==[0,0,0],
    "ERROR intersec_planes_3 test 0");

test_ip3_1_planes = [
    [ [25,-2,0], [0,2,2] ],
    [ [25,-1,4], [0,3,-10] ],
    [ [23,-3,2], [4,8,0] ] ];
test_ip3_1 = intersec_planes_3(
    test_ip3_1_planes[0],
    test_ip3_1_planes[1],
    test_ip3_1_planes[2]
);
color("blue") renderPlanes(test_ip3_1_planes);
color("red") renderPoints([test_ip3_1]);
echo("test_ip3_1=",roundDownList(test_ip3_1));
assert(roundDownList(test_ip3_1)==[26.69,-4.85,2.84],
    "ERROR intersec_planes_3 test 1");

test_ip3_2 = intersec_planes_3(
[ [1,2,0], [0,0,2] ],
[ [4,2,0], [0,0,2] ],
[ [0,5,6], [4,0,0] ]
);
echo("test_ip3_2=",test_ip3_2);
assert(is_undef(test_ip3_2),
    "ERROR intersec_planes_3 test 2");


// ----------------------------------------
// TEST intersec_planes_2
// ----------------------------------------

test_ip2_0_planes = [
    [ [9,2,0], [4,1,-1] ],
    [ [9,5,4], [-2,3,1] ] ];
test_ip2_0 = intersec_planes_2(
    test_ip2_0_planes[0],
    test_ip2_0_planes[1]
);
color("green") renderPlanes(test_ip2_0_planes);
color("red") renderLines([test_ip2_0]);
test_ip2_0_check=roundDownList(test_ip2_0);
echo("test_ip2_0=",test_ip2_0_check);
assert(test_ip2_0_check== [[7.68,5.9,-1.36],[4,-2,14],[0,0,0]],
    "ERROR intersec_planes_2 test 0");

test_ip2_1 = intersec_planes_2(
[ [1,2,0], [2,2,1] ],
[ [3,5,4], [60,60,30] ]
);
echo("test_ip2_1=",test_ip2_1);
assert(is_undef(test_ip2_1),
    "ERROR intersec_planes_2 test 1");



// ----------------------------------------
// Utilities
// ----------------------------------------
$fn=10;

function roundDownList(val) = [ for (v=val)
    if ( is_list(v) )
        [ for (c=v) roundDown(c,0.01) ]
    else
        roundDown(v,0.01)
];
