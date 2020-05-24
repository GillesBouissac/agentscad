/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Thread standards comparison
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/mx-screw.scad>
use <agentscad/mxf-screw.scad>
use <agentscad/unf-screw.scad>
use <agentscad/unc-screw.scad>
use <agentscad/bsw-screw.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
module renderThread ( d, x ) {
    translate( [x,0,0] ) {
        libBoltHexagonalThreaded (d);
        color( "gold" )
            translate( [0,0,-8] )
            rotate( [90,0,0] )
            linear_extrude(1)
            text( screwGetName(d), halign="center", valign="center", size=2, $fn=100 );
    }
}

INTERVAL=15;
module showcase() {
    renderThread ( M6      ( tl=15 ),  0*INTERVAL);
    renderThread ( MF6     ( tl=15 ),  1*INTERVAL);
    renderThread ( UNC1_4  ( tl=15 ),  2*INTERVAL);
    renderThread ( UNF1_4  ( tl=15 ),  3*INTERVAL);
    renderThread ( BSW1_4  ( tl=15 ),  4*INTERVAL);
}

showcase ($fn=50);
