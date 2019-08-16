/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Metric screw modelisation
 * Author:      Gilles Bouissac
 */

// ----------------------------------------
//
//    API
//
// ----------------------------------------

VGG = 0.01; // Visual Glich Guard
MFG = 0.01; // Manifold Guard
GAP = 0.4;  // Screw passage is deeper than screw by this amount

//
// Actually this API is just for fun,
//   not useful to desing part that receive screw
//   because this really draw the screw with 0 margin
//
// Draw a screw with hexagonal head
// p:   screw params (M1_6(), M2(), M2_5(), M3(), etc...)
// tl:  screw thread length, <0 means use default from p
// tlp: screw thread passage length, <0 means use default from p
//
// Notes:
//   screw thread starts at [0,0,0] and goes on Z-
//   screw head   starts at [0,0,0] and goes on Z+
//
module screwAllen( p=M2(), tl=-1, tlp=-1 ) {
    tool_r  = p[I_TOOL]/(2*cos(30));
    tool_l = 0.8*p[I_HL];
    local_tl  = tl<0  ? p[I_TL]   : tl ;
    local_tlp = tlp<0 ? p[I_TL_P] : tlp ;
    difference() {
        screwImpl (
            p[I_TD],
            local_tl,
            p[I_TD],
            0,
            p[I_HD],
            p[I_HL] );
        translate( [0,0,p[I_HL]+0.01] )
            cylinder( r=tool_r, h=tool_l, $fn=6, center=true );
    }
}

//
// This is the useful API to drill screw passages
//
// Draw a screw passage for thread AND head
// p: screw params (M1_6(), M2(), M2_5(), M3(), etc...)
// tl:  screw thread length, <0 means use default from p
// tlp: screw thread passage length, <0 means use default from p
//
// Notes:
//   screw thread starts at [0,0,0] and goes on Z-
//   screw head   starts at [0,0,0] and goes on Z+
//
module screwPassage( p=M2(), tlp=-1 ) {
    local_tl  = p[I_TL] ;
    local_tlp = tlp<0 ? p[I_TL_P] : tlp ;
    difference() {
        screwImpl (
            p[I_TD]-p[I_TP],
            local_tl+GAP,
            p[I_TD_P],
            local_tlp,
            p[I_HD_P],
            p[I_HL_P] );
    }
}

// Screw types
function M1_6(tl=-1,tlp=-1,hlp=-1) = screwParams(0,tl,tlp,hlp);
function M2(tl=-1,tlp=-1,hlp=-1)   = screwParams(1,tl,tlp,hlp);
function M2_5(tl=-1,tlp=-1,hlp=-1) = screwParams(2,tl,tlp,hlp);
function M3(tl=-1,tlp=-1,hlp=-1)   = screwParams(3,tl,tlp,hlp);
function M4(tl=-1,tlp=-1,hlp=-1)   = screwParams(4,tl,tlp,hlp);
function M5(tl=-1,tlp=-1,hlp=-1)   = screwParams(5,tl,tlp,hlp);
function M6(tl=-1,tlp=-1,hlp=-1)   = screwParams(6,tl,tlp,hlp);
function M8(tl=-1,tlp=-1,hlp=-1)   = screwParams(7,tl,tlp,hlp);
function M10(tl=-1,tlp=-1,hlp=-1)  = screwParams(8,tl,tlp,hlp);
function M12(tl=-1,tlp=-1,hlp=-1)  = screwParams(9,tl,tlp,hlp);

// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------
I_IDX    =  0;
I_NAME   =  1;
I_TP     =  2; // Thread Pitch: Distance between threads
I_TD     =  3; // Thread Diameter
I_TD_P   =  4; // Thread Passage Diameter
I_TL     =  5; // Thread Length
I_TL_P   =  6; // Thread Passage Length
I_HD     =  7; // Head Diameter
I_HD_P   =  8; // Head Passage Diameter
I_HL     =  9; // Head Length
I_HL_P   = 10; // Head Passage Length
I_TOOL   = 11; // Tool size to turn the screw
function screwParams( idx, tl=-1, tlp=-1, hlp=-1 ) = let (
    local_tl  = tl<0 ? SCREWS_L[idx] : tl,
    local_tlp = (tlp<0 || tlp>local_tl) ? local_tl*20/100 : tlp,
    local_hlp = hlp<0 ? SCREWS_HLP[idx] : hlp
) [
    idx,
    SCREWS_N[idx],
    SCREWS_P[idx],
    SCREWS_D[idx],
    SCREWS_D[idx]+PRINT_GAP*2,
    local_tl,
    local_tlp,
    SCREWS_HD[idx],
    SCREWS_HDP[idx],
    SCREWS_HL[idx],
    local_hlp,
    SCREWS_TOOL[idx]
];

// GAP between screw and screw hole
PRINT_GAP = 0.2;

//
// Well known screws dimensions
//   https://shop.hpceurope.com/pdf/fr/CHC.pdf
//

// Screw type string
SCREWS_N  = [
    "M1.6",
    "M2",
    "M2.5",
    "M3",
    "M4",
    "M5",
    "M6",
    "M8",
    "M10",
    "M12"
];
// Thread diameter
SCREWS_D  = [
    1.6,
    2,
    2.5,
    3,
    4,
    5,
    6,
    8,
    10,
    12
];
// P: Pitch
SCREWS_P  = [
    0.35,
    0.40,
    0.45,
    0.50,
    0.70,
    0.80,
    1.00,
    1.25,
    1.50,
    1.75
];
// L: Default length = medium length
SCREWS_L  = [
    4,
    6,
    8,
    16,
    20,
    25,
    40,
    50,
    35,
    80
];
// DK: Head diameter
SCREWS_HD = [
    3.0,
    3.8,
    4.5,
    5.5,
    7.22,
    8.72,
    10.22,
    13.27,
    16.27,
    18.27
];
// C1: Head passage diameter
SCREWS_HDP = [
    5.0,
    6.0,
    7.0,
    8.0,
   10.0,
   11.0,
   13.0,
   18.0,
   20.0,
   22.0
];
// K: Head length
SCREWS_HL = [
    1.6,
    2.0,
    2.5,
    3.0,
    4,
    5,
    6,
    8,
    10,
    12
];
// t1a: Head passage length
SCREWS_HLP = [
    1.7,
    2.1,
    2.7,
    3.2,
    4.2,
    5.3,
    6.3,
    8.4,
   10.5,
   12.6
];
// S: Hexagonal tool size
SCREWS_TOOL = [
    1.5,
    1.5,
    2.0,
    2.5,
    3.0,
    4.0,
    5.0,
    6.0,
    8.0,
   10.0
];

module screwImpl( td, tl, tdp, tlp, hd, hl ) {
    translate( [0,0,-(tl+tlp)/2 ] )
        cylinder( r=td/2, h=tl-tlp, center=true );
    translate( [0,0,-tlp/2 ] )
        cylinder( r=tdp/2, h=tlp+VGG, center=true );
    if ( hl>0 ) {
        translate( [0,0,+hl/2 ] )
            cylinder( r=hd/2, h=hl, center=true );
    }
}

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

screw = M3(10);
translate( [10,0,0] )
#screwPassage( screw, 3, $fn=100 );
screwAllen( screw, $fn=100 );


