/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Not so easy pyramid puzzle
 * Author:      Gilles Bouissac
 */

// ----------------------------------------
//    API
// ----------------------------------------

/* [Global] */

// Height of the pyramid
PYRAMID_HEIGHT = 60; // [0:250]

// Beveling around shapes
BEVEL          = 0.5; // [0:5]


// ----------------------------------------
//             Implementation
// ----------------------------------------

/* [Hidden] */

PYRAMID_H = PYRAMID_HEIGHT-2*BEVEL;

ALPHA     = 2*asin( 1/(2*sin(60)) );

FACE_H    = PYRAMID_H/sin(ALPHA);

SIDE_L    = FACE_H/sin(60);
SIDE_l    = SIDE_L/2;

FACE_HS   = SIDE_l*tan(30);
FACE_HL   = FACE_H-FACE_HS;

PYRAMID_HS   = FACE_HS*tan(ALPHA/2);
PYRAMID_HL   = PYRAMID_H-PYRAMID_HS;

module cutter() {
    cut_w = PYRAMID_H*10;
    rotate( [-(180-ALPHA)/2,0,0] )
    translate( [0,0,cut_w/2] )
        cube( [cut_w,cut_w,cut_w], center=true );
}

module pyramid() {
    // [0,0,0] is the center of the pyramid
    translate( [0,0,-PYRAMID_HS] )
    linear_extrude ( height=PYRAMID_H, scale=0 )
        polygon( [
            [      0,  FACE_HL],
            [+SIDE_l, -FACE_HS],
            [-SIDE_l, -FACE_HS]
        ]);
}

module pyramidPart() {
    translate( [0,-PYRAMID_HS-BEVEL,PYRAMID_HS+BEVEL] )
    minkowski() {
        difference() {
            pyramid();
            // Beveling with minkowski adds a thickness we must remove
            translate( [0,-BEVEL*cos(45),-BEVEL*cos(45)] )
                cutter();
        }
        sphere(BEVEL);
    }
}

// ----------------------------------------
//            Final rendering
// ----------------------------------------
pyramidPart( $fn=100 );
translate( [0,PYRAMID_HL+2*BEVEL,0] )
pyramidPart( $fn=100 );
