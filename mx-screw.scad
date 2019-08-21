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

// Bolt passage loose on head to fit any type of head
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  tlp:  bolt thread passage length, <0 means use default from p
module mxBoltPassage( p=M2(), tlp=-1 ) {
    local_tl  = p[I_TL] ;
    local_tlp = tlp<0 ? p[I_TLP] : tlp ;
    boltImpl (
        p[I_TD]-p[I_TP],  local_tl+GAP,
        p[I_TDP],         local_tlp,
        p[I_HDP],         p[I_HLP]
    );
}

// Nut passage loose on head to fit any type of nut
//  p   :  nut params (M1_6(), M2(), M2_5(), M3(), etc...)
//  hdp :  hexagonal diameter passage, <0 means use default from p
//  hlp :  head length passage, <0 means use default from p
// Note :  This passage will not prevent the nut from turning
module mxNutPassage( p=M2(), hdp=-1, hlp=-1 ) {
    local_hdp = hdp<0 ? p[I_HDP] : hdp ;
    local_hlp = hlp<0 ? p[I_HLP] : hlp ;
    boltImpl (
        0,         0,
        0,         0,
        local_hdp, local_hlp
    );
}

// Hexagonal nut passage
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  hhd:  hexagonal head diameter, <0 means use default from p
//  hlp:  head length passage, <0 means use default from p
// Note: This passage will prevent nut from turning
module mxNutHexagonalPassage( p=M2(), hhd=-1, hlp=-1 ) {
    local_hhd = hhd<0 ? p[I_HHD] : hhd ;
    local_hlp = hlp<0 ? p[I_HLP] : hlp ;
    translate( [0,0,+local_hlp/2 ] )
        cylinder( r=local_hhd/2+GAP, h=local_hlp, center=true, $fn=6 );
}

// Hexagonal nut passage
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  shw:  square head width, <0 means use default hexagonal tool from p
//  slp:  head length passage, <0 means use default from p
// Note: This passage will prevent nut from turning
module mxNutSquarePassage( p=M2(), shw=-1, slp=-1 ) {
    local_shw = shw<0 ? p[I_HHD] : shw ;
    local_slp = slp<0 ? p[I_HLP] : slp ;
    translate( [0,0,+local_slp/2 ] )
        cube( [local_shw+GAP,local_shw+GAP,local_slp], center=true );
}

// Bolt passage Tight on head for Allen head
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  tlp:  bolt thread passage length, <0 means use default from p
module mxBoltAllenPassage( p=M2(), tlp=-1 ) {
    local_tl  = p[I_TL] ;
    local_tlp = tlp<0 ? p[I_TLP] : tlp ;
    union() {
        boltImpl (
            p[I_TD]-p[I_TP],   local_tl+GAP,
            p[I_TDP],          local_tlp,
            p[I_AHD]+2*GAP,    p[I_HLP]
        );
    }
}

// Bolt passage Tight on head for Hexagonal head
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  tlp:  bolt thread passage length, <0 means use default from p
module mxBoltHexagonalPassage( p=M2(), tlp=-1 ) {
    local_tl  = p[I_TL] ;
    local_tlp = tlp<0 ? p[I_TLP] : tlp ;
    union() {
        boltImpl (
            p[I_TD]-p[I_TP],   local_tl+GAP,
            p[I_TDP],          local_tlp,
            0,       0
        );
        translate( [0,0,+p[I_HLP]/2 ] )
            cylinder( r=p[I_HHD]/2+GAP, h=p[I_HLP], center=true, $fn=6 );
    }
}

// Bolt with Allen head
//   p:   bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  tl:   bolt thread length, <0 means use default from p
module mxBoltAllen( p=M2(), tl=-1 ) {
    tool_r  = p[I_ATS]/(2*cos(30));
    tool_l = 0.8*p[I_AHL];
    local_tl  = tl<0  ? p[I_TL]   : tl ;
    difference() {
        boltImpl (
            p[I_TD],   local_tl,
            0,         0,
            p[I_AHD], p[I_AHL]
        );
        translate( [0,0,p[I_AHL]+0.01] )
            cylinder( r=tool_r, h=tool_l, $fn=6, center=true );
    }
}

// Bolt with Hexagonal head
//   p:   bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  tl:   bolt thread length, <0 means use default from p
module mxBoltHexagonal( p=M2(), tl=-1 ) {
    local_tl  = tl<0  ? p[I_TL]   : tl ;
    union() {
        boltImpl (
            p[I_TD], local_tl,
            0,       0,
            0,       0
        );
        translate( [0,0,+p[I_HHL]/2 ] )
            cylinder( r=p[I_HHD]/2, h=p[I_HHL], center=true, $fn=6 );
    }
}

// Hexagonal nut
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
// Note: This passage will prevent nut from turning
module mxNutHexagonal( p=M2() ) {
    local_hhd = p[I_HHD] ;
    local_hhl = p[I_HHL] ;
    translate( [0,0,+local_hhl/2 ] )
    difference() {
        cylinder( r=local_hhd/2, h=local_hhl, center=true, $fn=6 );
        cylinder( r=p[I_TAP]/2,  h=local_hhl, center=true );
    }
}

// Square nut
//    p:  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  shl:  square head length, <0 means use default hexagonal head length from p
// Note: This passage will prevent nut from turning
module mxNutSquare( p=M2(), shl=-1 ) {
    local_shd = p[I_HTS];
    local_shl = shl<0 ? p[I_HHL] : shl ;
    translate( [0,0,+local_shl/2 ] )
    difference() {
        cube( [local_shd,local_shd,local_shl], center=true );
        cylinder( r=p[I_TAP]/2,  h=local_shl, center=true );
    }
}

// Bold data accessors
function M1_6(tl=-1,tlp=-1,hlp=-1) = mxData(0,tl,tlp,hlp);
function M2(tl=-1,tlp=-1,hlp=-1)   = mxData(1,tl,tlp,hlp);
function M2_5(tl=-1,tlp=-1,hlp=-1) = mxData(2,tl,tlp,hlp);
function M3(tl=-1,tlp=-1,hlp=-1)   = mxData(3,tl,tlp,hlp);
function M4(tl=-1,tlp=-1,hlp=-1)   = mxData(4,tl,tlp,hlp);
function M5(tl=-1,tlp=-1,hlp=-1)   = mxData(5,tl,tlp,hlp);
function M6(tl=-1,tlp=-1,hlp=-1)   = mxData(6,tl,tlp,hlp);
function M8(tl=-1,tlp=-1,hlp=-1)   = mxData(7,tl,tlp,hlp);
function M10(tl=-1,tlp=-1,hlp=-1)  = mxData(8,tl,tlp,hlp);
function M12(tl=-1,tlp=-1,hlp=-1)  = mxData(9,tl,tlp,hlp);
function M14(tl=-1,tlp=-1,hlp=-1)  = mxData(10,tl,tlp,hlp);
function M16(tl=-1,tlp=-1,hlp=-1)  = mxData(11,tl,tlp,hlp);
function M18(tl=-1,tlp=-1,hlp=-1)  = mxData(12,tl,tlp,hlp);
function M20(tl=-1,tlp=-1,hlp=-1)  = mxData(13,tl,tlp,hlp);
function M22(tl=-1,tlp=-1,hlp=-1)  = mxData(14,tl,tlp,hlp);
function M24(tl=-1,tlp=-1,hlp=-1)  = mxData(15,tl,tlp,hlp);
function M27(tl=-1,tlp=-1,hlp=-1)  = mxData(16,tl,tlp,hlp);
function M30(tl=-1,tlp=-1,hlp=-1)  = mxData(17,tl,tlp,hlp);
function M33(tl=-1,tlp=-1,hlp=-1)  = mxData(18,tl,tlp,hlp);
function M36(tl=-1,tlp=-1,hlp=-1)  = mxData(19,tl,tlp,hlp);
function M39(tl=-1,tlp=-1,hlp=-1)  = mxData(20,tl,tlp,hlp);
function M42(tl=-1,tlp=-1,hlp=-1)  = mxData(21,tl,tlp,hlp);
function M45(tl=-1,tlp=-1,hlp=-1)  = mxData(22,tl,tlp,hlp);
function M48(tl=-1,tlp=-1,hlp=-1)  = mxData(23,tl,tlp,hlp);
function M52(tl=-1,tlp=-1,hlp=-1)  = mxData(24,tl,tlp,hlp);
function M56(tl=-1,tlp=-1,hlp=-1)  = mxData(25,tl,tlp,hlp);
function M60(tl=-1,tlp=-1,hlp=-1)  = mxData(26,tl,tlp,hlp);
function M64(tl=-1,tlp=-1,hlp=-1)  = mxData(27,tl,tlp,hlp);

// Data accessors on data
function mxName(s)              = s[I_NAME];
function mxTapD(s)              = s[I_TAP];
function mxPitch(s)             = s[I_TP];
function mxThreadD(s)           = s[I_TD];
function mxThreadDP(s)          = s[I_TDP];
function mxThreadL(s)           = s[I_TL];
function mxThreadLP(s)          = s[I_TLP];
function mxHeadDP(s)            = s[I_HDP];
function mxHeadLP(s)            = s[I_HLP];
function mxAllenHeadD(s)        = s[I_AHD];
function mxAllenHeadL(s)        = s[I_AHL];
function mxAllenToolSize(s)     = s[I_ATS];
function mxHexagonalHeadD(s)    = s[I_HHD];
function mxHexagonalHeadL(s)    = s[I_HHL];
function mxHexagonalToolSize(s) = s[I_HTS];

// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------

// Renders a bolt with given parameters for Thread, Thread passage and Head
module boltImpl( td, tl, tdp, tlp, hd, hl ) {
    translate( [0,0,-(tl+tlp)/2 ] )
        cylinder( r=td/2, h=tl-tlp, center=true );
    translate( [0,0,-tlp/2 ] )
        cylinder( r=tdp/2, h=tlp+VGG, center=true );
    if ( hl>0 ) {
        translate( [0,0,+hl/2 ] )
            cylinder( r=hd/2, h=hl, center=true );
    }
}

VGG = 0.01; // Visual Glich Guard
MFG = 0.01; // Manifold Guard
GAP = 0.2;  // Bolt passage is deeper than bolt by this amount


I_IDX    =  0;
I_NAME   =  1;
I_TP     =  2; // Thread Pitch: Distance between threads
I_TAP    =  3; // Tap diameter
I_TD     =  4; // Thread Diameter
I_TDP   =  5; // Thread Passage Diameter
I_TL     =  6; // Thread Length
I_TLP   =  7; // Thread Passage Length
I_HDP   =  8; // Head Passage Diameter
I_HLP   =  9; // Head Passage Length
I_AHD   = 10; // Head Diameter for Allen head
I_AHL   = 11; // Head Length for Allen head
I_ATS   = 12; // Allen Tool Size
I_HHD   = 13; // Head Diameter for Hexagonal head
I_HHL   = 14; // Head Length for Hexagonal head
I_HTS   = 15; // Hexagonal Tool Size

function mxDataLength() = len(DATA);
function mxData( idx, tl=-1, tlp=-1, hlp=-1 ) = let (
    local_tl  = tl<0 ? MXDATA[idx][CTL] : tl,
    local_tlp = (tlp<0 || tlp>local_tl) ? local_tl*20/100 : tlp,
    local_hlp = hlp<0 ? MXDATA[idx][CHLP] : hlp
) [
    idx,
    MXDATA[idx][CNAME],
    MXDATA[idx][CPITCH],
    MXDATA[idx][CTD]-MXDATA[idx][CPITCH],
    MXDATA[idx][CTD],
    MXDATA[idx][CTD]+2*GAP,
    local_tl,
    local_tlp,
    MXDATA[idx][CHDP],
    local_hlp,
    MXDATA[idx][CAHD],
    MXDATA[idx][CAHL],
    MXDATA[idx][CATS],
    MXDATA[idx][CHTS]/cos(30),
    MXDATA[idx][CHHL],
    MXDATA[idx][CHTS]
];

//
// Raw data
//
// Sources:
//   https://shop.hpceurope.com/pdf/fr/CHC.pdf
//   http://www.fasnetdirect.com/refguide/Methexblt810.pdf
//   https://i.pinimg.com/originals/fd/df/69/fddf693160da9ad999c388e9ae1e4667.jpg
//   https://en.wikipedia.org/wiki/ISO_metric_screw_thread
//   http://ballsgrinding.com/ebay/SOCKET-SCREW-CAP-HEAD-ALLEN-BOLTS-DIMENSIONS-FASTENERS-METRIC-4.jpg
//   https://www.newfastener.com/wp-content/uploads/2013/03/DIN-912.pdf
//   https://www.fastenerdata.co.uk/fasteners/nuts/square.html
//
// PITCH is Standard coarse pitch
//
MXDATA = [
//| Name   | PITCH  |  TD  |  TL  | HDP  | HLP  |  AHD  | AHL  | ATS  |  HHL | HTS |
// idx=0
  [ "M1.6" ,   0.35 ,  1.6 ,    4 ,    5 ,  2.0 ,   3.0 ,  1.6 ,  1.5 ,  1.1 , 3.2 ],
  [ "M2"   ,   0.4  ,    2 ,    6 ,    6 ,  2.5 ,   3.8 ,  2   ,  1.5 ,  1.4 ,   4 ],
  [ "M2.5" ,   0.45 ,  2.5 ,    8 ,    7 ,  3.0 ,   4.5 ,  2.5 ,  2.0 ,  1.7 ,   5 ],
  [ "M3"   ,   0.5  ,    3 ,   16 ,    8 ,  3.5 ,   5.5 ,  3   ,  2.5 ,  2.0 , 5.5 ],
  [ "M4"   ,   0.7  ,    4 ,   20 ,   10 ,  4.5 ,   7.0 ,  4   ,  3.0 ,  2.8 ,   7 ],
  [ "M5"   ,   0.8  ,    5 ,   22 ,   11 ,  5.5 ,   8.5 ,  5   ,  4.0 ,  3.5 ,   8 ],
  [ "M6"   ,   1.0  ,    6 ,   24 ,   13 ,  6.5 ,  10.0 ,  6   ,  5.0 ,  4.0 ,  10 ],
  [ "M8"   ,   1.25 ,    8 ,   28 ,   17 ,  8.5 ,  13.0 ,  8   ,  6.0 ,  5.3 ,  13 ],
  [ "M10"  ,   1.5  ,   10 ,   32 ,   20 , 10.5 ,  16.0 , 10   ,  8.0 ,  6.4 ,  16 ],
  [ "M12"  ,   1.75 ,   12 ,   36 ,   22 , 12.5 ,  18.0 , 12   , 10.0 ,  7.5 ,  18 ],
// idx=10
  [ "M14"  ,   2.0  ,   14 ,   40 ,   26 , 14.5 ,  21.0 , 14   , 10.0 ,  8.8 ,  21 ],
  [ "M16"  ,   2.0  ,   16 ,   44 ,   29 , 16.5 ,  24.0 , 16   , 14.0 , 10.0 ,  24 ],
  [ "M18"  ,   2.5  ,   18 ,   48 ,   32 , 18.5 ,  27.0 , 18   , 14.0 , 11.5 ,  27 ],
  [ "M20"  ,   2.5  ,   20 ,   52 ,   36 , 21.0 ,  30.0 , 20   , 17.0 , 12.5 ,  30 ],
  [ "M22"  ,   2.5  ,   22 ,   56 ,   40 , 23.0 ,  33.0 , 22   , 17.0 , 14.0 ,  34 ],
  [ "M24"  ,   3.0  ,   24 ,   60 ,   42 , 25.0 ,  36.0 , 24   , 19.0 , 15.0 ,  36 ],
  [ "M27"  ,   3.0  ,   27 ,   66 ,   48 , 28.0 ,  40.0 , 27   , 19.0 , 17.0 ,  41 ],
  [ "M30"  ,   3.5  ,   30 ,   72 ,   53 , 32.0 ,  45.0 , 30   , 22.0 , 18.7 ,  46 ],
  [ "M33"  ,   3.5  ,   33 ,   78 ,   57 , 35.0 ,  50.0 , 33   , 24.0 , 21.0 ,  50 ],
  [ "M36"  ,   4.0  ,   36 ,   84 ,   63 , 38.0 ,  54.0 , 36   , 27.0 , 22.5 ,  55 ],
// idx=20
  [ "M39"  ,   4.0  ,   39 ,   90 ,   68 , 41.0 ,  58.0 , 39   , 27.0 , 25.0 ,  60 ],
  [ "M42"  ,   4.5  ,   42 ,   96 ,   73 , 45.0 ,  63.0 , 42   , 32.0 , 26.0 ,  65 ],
  [ "M45"  ,   4.5  ,   45 ,  102 ,   79 , 48.0 ,  67.0 , 45   , 32.0 , 28.0 ,  70 ],
  [ "M48"  ,   5.0  ,   48 ,  108 ,   84 , 51.0 ,  72.0 , 48   , 36.0 , 30.0 ,  75 ],
  [ "M52"  ,   5.0  ,   52 ,  116 ,   89 , 56.0 ,  78.0 , 52   , 36.0 , 33.0 ,  80 ],
  [ "M56"  ,   5.5  ,   56 ,  122 ,   95 , 60.0 ,  84.0 , 56   , 41.0 , 35.0 ,  85 ],
  [ "M60"  ,   5.5  ,   60 ,  130 ,  100 , 64.0 ,  90.0 , 60   , 41.0 , 38.0 ,  90 ],
  [ "M64"  ,   6.0  ,   64 ,  138 ,  105 , 68.0 ,  96.0 , 64   , 46.0 , 40.0 ,  95 ]
];
CNAME    =  0;
CPITCH   =  1;
CTD      =  2;
CTL      =  3;
CHDP     =  4;
CHLP     =  5;
CAHD     =  6;
CAHL     =  7;
CATS     =  8;
// CHHD  = Computed from CHTS: CHTS/cos(30)
CHHL     =  9;
CHTS     = 10;

// HDP extrapolation from HTS
// According to C1 (HDP) from https://shop.hpceurope.com/pdf/fr/CHC.pdf:
// And ISO Hex nut tool sizes from https://en.wikipedia.org/wiki/ISO_metric_screw_thread
// 
//  Screw:    | 1.6 | 2 | 2.5 |  3  |  4 |  5 |  6 |  8 | 10 | 12 |
//            o-----o---o-----o-----o----o----o----o----o----o----o
//  C1/HDP:   |   5 | 6 |   7 | 8   | 10 | 11 | 13 | 17 | 20 | 22 |
//  HTS(ISO): | 3.2 | 4 |   5 | 5.5 |  7 |  8 | 10 | 13 | 16 | 18 |
//  diff:     | 1.8 | 2 |   2 | 2.5 |  3 |  3 |  3 |  4 |  4 |  4 |
// 
// Extrapolation: +1 every 3 screw
// 
//  Screw:    | 14 | 16 | 18 | 20 | 22 | 24 | 27 | 30 | 33 | 36 | 39 |
//            o----o----o----o----o----o----o----o----o----o----o----o
//  diff:     |  5 |  5 |  5 |  6 |  6 |  6 |  7 |  7 |  7 |  8 |  8 |
//  HTS(ISO): | 21 | 24 | 27 | 30 | 34 | 36 | 41 | 46 | 50 | 55 | 60 |
//  C1/HDP:   | 26 | 29 | 32 | 36 | 40 | 42 | 48 | 53 | 57 | 63 | 68 |
// 
//  Screw:    | 42 | 45 | 48 | 52 | 56 |  60 |  64 |
//            o----o----o----o----o----o-----o-----o
//  diff:     |  8 |  9 |  9 |  9 | 10 |  10 |  10 |
//  HTS(ISO): | 65 | 70 | 75 | 80 | 85 |  90 |  95 |
//  C1/HDP:   | 73 | 79 | 84 | 89 | 95 | 100 | 105 |

// TL extrapolation of common thread length, just for a default value
// Just get b value from https://shop.hpceurope.com/pdf/fr/CHC.pdf:

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
mxBoltHexagonal( M64(), $fn=100 );
%translate([0,0,-150])
    mxNutSquarePassage( M64(), $fn=100 );
translate([60,0])
    color( "red" )
    mxBoltAllen( M1_6(), $fn=100 );
%translate([60,0,-mxHexagonalHeadL(M1_6()) ])
    mxNutSquare( M1_6(), $fn=100 );
