/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: UNF screw modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/mx-screw.scad>
use <agentscad/mx-thread.scad>
use <agentscad/mxf-screw.scad>
use <agentscad/mxf-thread.scad>
use <agentscad/unf-screw.scad>
use <agentscad/unf-thread.scad>
use <agentscad/unc-screw.scad>
use <agentscad/unc-thread.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
module renderThread ( d, x ) {
    translate( [x,0,0] ) {
        libBoltHexagonalThreaded (d);
        color( "gold" )
            translate( [0,0,-5] )
            rotate( [90,0,0] )
            linear_extrude(1)
            text( screwGetName(d), halign="center", valign="center", size=2, $fn=100 );
    }
}

module showcase() {
    renderThread ( M4     ( tl=20 ),  -30);
    renderThread ( MF4    ( tl=20 ),  -10);
    renderThread ( UNC_N8 ( tl=20 ),  +10);
    renderThread ( UNF_N8 ( tl=20 ),  +30);
}




showcase ($fn=50);
