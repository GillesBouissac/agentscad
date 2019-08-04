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

// Draw a screw with hexagonal head
// p: screw params (M1_6(), M2(), M2_5(), M3(), etc...)
// l: screw thread length (0=use default)
//
// Notes:
//   screw thread starts at [0,0,0] and goes on Z+
//   screw head   starts at [0,0,0] and goes on Z-
//
module screwHexa( p=M2(), l=-1 ) {
    tool_r  = p[I_TOOL]/(2*cos(30));
    tool_l = 0.8*p[I_HEADL];
    length = l==-1 ? p[I_LENGTH]: l ;
    difference() {
        screwImpl (
            p[I_DIAM],
            length,
            p[I_HEADD],
            p[I_HEADL] );
        translate( [0,0,-p[I_HEADL]-0.01] )
            cylinder( r=tool_r, h=tool_l, $fn=6 );
    }
}

// Draw a hole for screwing a screw
// p: screw params (M1_6(), M2(), M2_5(), M3(), etc...)
// l: hole depth (0=use default)
module screwHole( p=M2(), l=-1 ) {
    length = l==-1 ? p[I_LENGTH]: l ;
    screwImpl (
        p[I_DIAM]-p[I_PITCH],
        length+PRINT_GAP,
        p[I_DIAM]-p[I_PITCH],
        PRINT_GAP );
}

// Draw a screw passage for thread AND head
// p: screw params (M1_6(), M2(), M2_5(), M3(), etc...)
// l: screw thread length (0=use default)
module screwPassage( p=M2(), l=-1 ) {
    length = l==-1 ? p[I_LENGTH]: l ;
    screwImpl (
        p[I_DIAMP],
        length+PRINT_GAP,
        p[I_HEADDP],
        p[I_HEADLP] );
}

// Screw types
function M1_6(length=-1) = screwParams(0,length);
function M2(length=-1)   = screwParams(1,length);
function M2_5(length=-1) = screwParams(2,length);
function M3(length=-1)   = screwParams(3,length);
function M4(length=-1)   = screwParams(4,length);
function M5(length=-1)   = screwParams(5,length);
function M6(length=-1)   = screwParams(6,length);
function M8(length=-1)   = screwParams(7,length);
function M10(length=-1)  = screwParams(8,length);
function M12(length=-1)  = screwParams(9,length);

// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------
I_IDX    =  0;
I_NAME   =  1;
I_DIAM   =  2;
I_DIAMP  =  3; // Passage
I_PITCH  =  4;
I_LENGTH =  5;
I_HEADD  =  6;
I_HEADDP =  7; // Passage
I_HEADL  =  8;
I_HEADLP =  9; // Passage
I_TOOL   = 10;
function screwParams( idx, length ) = [
    idx,
    SCREWS_N[idx],
    SCREWS_D[idx],
    SCREWS_D[idx]+PRINT_GAP*2,
    SCREWS_P[idx],
    length==-1 ? SCREWS_L[idx] : length,
    SCREWS_HD[idx],
    SCREWS_HDP[idx],
    SCREWS_HL[idx],
    SCREWS_HLP[idx],
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

module screwImpl( d, l, hd, hl ) {
    cylinder( r=d/2, h=l );
    if ( hd>0 ) {
        translate( [0,0,-hl ] )
        cylinder( r=hd/2, h=hl );
    }
}

// ----------------------------------------
//
//    ALL above is for Testing/Demo
//
// ----------------------------------------
function cumulate ( vect, end=-1, nexti=0, current=-1 ) =
let(
    endIdx   = end==-1 ? len(vect)-1 : end,
    curCumul = current==-1 ? 0 : current,
    res = nexti>endIdx ? curCumul : vect[nexti]+cumulate(vect,endIdx,nexti+1,curCumul)
)res;

SCREW_DISTANCE=3;
module screwShowcase ( t ) {
    translate( [ t[I_IDX]*SCREW_DISTANCE + cumulate( SCREWS_HDP, t[I_IDX] )-70,0,0] ) {
        color( "green", 0.3 )
            screwHole ( t, $fn=100 );
        color( "yellow", 0.3 )
            screwHexa ( t, $fn=100 );
        color( "blue", 0.1 )
            screwPassage ( t, $fn=100 );
        color( "gold" )
            translate( [0,-t[I_HEADDP]/2-1.5,-t[I_HEADL]/2] )
            rotate ( [90,0,0] )
            linear_extrude(1)
            text( t[I_NAME], halign="center", valign="center", size=2, $fn=100 );
    }
}

screwShowcase( M1_6() );
screwShowcase( M2() );
screwShowcase( M2_5() );
screwShowcase( M3() );
screwShowcase( M4() );
screwShowcase( M5() );
screwShowcase( M6() );
screwShowcase( M8() );
screwShowcase( M10() );
screwShowcase( M12() );
