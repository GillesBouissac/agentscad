/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable metric screws taking into account printer precision
 * Author:      Gilles Bouissac
 */
use <extensions.scad>
use <printing.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Bolt orientation is:
//      Head bottom at [0,0,0]
//      Head goes Z-
//      Thread goes Z+
// Nut orientation is opposite:
//      Head top at [0,0,0]
//      Head goes Z+

// Bolt passage loose on head to fit any type of head
//  p   :  bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  Note : This passage will NOT block the bolt
module mxBoltPassage( p=M2() ) {
    local_tl  = p[I_TL] ;
    local_tlp = p[I_TLP] ;
    local_hlp = p[I_HLP] ;
    local_hdp = p[I_HDP] ;
    mxBoltImpl (
        p[I_TD]-p[I_TP],  local_tl,
        p[I_TDP],         local_tlp,
        local_hdp,        local_hlp
    );
}

// Nut passage loose on head to fit any type of nut
//  p    : nut params (M1_6(), M2(), M2_5(), M3(), etc...)
//  Note : This passage will NOT block the nut
module mxNutPassage( p=M2() ) {
    local_hdp = p[I_HDP] ;
    local_hlp = p[I_HLP] ;
    translate( [0,0,+local_hlp ] )
        mxBoltImpl (
            0,         0,
            0,         0,
            local_hdp, local_hlp
        );
}

// Hexagonal nut passage
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  Note : his passage will block the nut
module mxNutHexagonalPassage( p=M2() ) {
    local_hhd = p[I_HHD] ;
    local_hlp = p[I_HHL]+2*gap() ;
    translate( [0,0,+local_hlp/2 ] )
        cylinder( r=local_hhd/2+gap(), h=local_hlp, center=true, $fn=6 );
}

// Hexagonal nut passage
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  Note : This passage will block the nut
module mxNutSquarePassage( p=M2() ) {
    local_shw = p[I_HTS] ;
    local_slp = p[I_HHL]+2*gap() ;
    translate( [0,0,+local_slp/2 ] )
        cube( [local_shw+gap(),local_shw+gap(),local_slp], center=true );
}

// Bolt passage Tight on head for Allen head
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
module mxBoltAllenPassage( p=M2() ) {
    local_tl  = p[I_TL] ;
    local_tlp = p[I_TLP] ;
    union() {
        mxBoltImpl (
            p[I_TD]-p[I_TP],   local_tl+gap(),
            p[I_TDP],          local_tlp,
            p[I_AHD]+2*gap(),  p[I_HLP]
        );
    }
}

// Bolt passage Tight on head for Hexagonal head
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  Note : This passage will block the bolt
module mxBoltHexagonalPassage( p=M2() ) {
    local_tl  = p[I_TL] ;
    local_tlp = p[I_TLP] ;
    union() {
        mxBoltImpl (
            p[I_TD]-p[I_TP],   local_tl+gap(),
            p[I_TDP],          local_tlp,
            0,       0
        );
        translate( [0,0,-p[I_HLP]/2 ] )
            cylinder( r=p[I_HHD]/2+gap(), h=p[I_HLP], center=true, $fn=6 );
    }
}

// Bolt with Allen head
//  p    : Bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  bt   : Bevel top of head
module mxBoltAllen( p=M2(), bt=true ) {
    // +gap() for easier fitting with the tool
    tool_r   = p[I_ATS]/(2*cos(30))+gap();
    cone_h   = tool_r/2*tan(30);
    tool_l   = p[I_AHL]*2/3;
    local_tl = p[I_TL] ;
    difference() {
        union() {
            mxBoltImpl (
                p[I_TD],   local_tl,
                0,         0,
                0,         0
            );
            translate( [0,0,-p[I_AHL]/2] )
            intersection() {
                cylinder( r=p[I_AHD]/2, h=p[I_AHL], center=true );
                mxBevelShape(
                    p[I_AHL],
                    p[I_AHD]-2*(p[I_TD]/10)/tan(BEVEL_ALLEN_A),
                    a=BEVEL_ALLEN_A,
                    t=false,
                    b=bt);
            }
        }
        translate( [0,0,-p[I_AHL]-VGG] ) {
            cylinder( r=tool_r, h=tool_l, $fn=6 );
            translate( [0,0,tool_l] )
            cylinder( r1=tool_r, r2=0, h=cone_h, $fn=6 );

        }
    }
}

// Bolt with Hexagonal head
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  bt   : Bevel top of head
//  bb   : Bevel bottom of head
module mxBoltHexagonal( p=M2(), bt=true, bb=true ) {
    local_tl  = p[I_TL] ;
    local_hhd = p[I_HHD] ;
    local_hhl = p[I_HHL] ;
    union() {
        mxBoltImpl (
            p[I_TD], local_tl,
            0,       0,
            0,       0
        );
        translate( [0,0,-local_hhl/2 ] )
        intersection() {
            // -gap() for easier fitting with the tool
            cylinder( r=(local_hhd-gap())/2, h=local_hhl, center=true, $fn=6 );
            mxBevelShape( local_hhl, p[I_HTS]-2*gap()*cos(30), b=bt, t=bb );
        }
    }
}

// Hexagonal nut
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  Note : This passage will prevent nut from turning
module mxNutHexagonal( p=M2(), bt=true, bb=true ) {
    local_hhd = p[I_HHD] ;
    local_hhl = p[I_HHL] ;
    translate( [0,0,+local_hhl/2 ] )
        intersection() {
            difference() {
                // -gap() for easier fitting with the tool
                cylinder( r=(local_hhd-gap())/2, h=local_hhl, center=true, $fn=6 );
                cylinder( r=p[I_TAP]/2,  h=local_hhl+VGG, center=true );
            }
            mxBevelShape( local_hhl, p[I_HTS]-2*gap()*cos(30), b=bt, t=bb );
        }
}

// Square nut
//  p    : bolt params (M1_6(), M2(), M2_5(), M3(), etc...)
//  shl  : square head length, <0 means use default hexagonal head length from p
//  Note : This passage will prevent nut from turning
module mxNutSquare( p=M2(), bt=true, bb=true ) {
    local_shd = p[I_HTS] ;
    local_shl = p[I_HHL] ;
    translate( [0,0,+local_shl/2 ] )
        intersection() {
            difference() {
                // -gap() for easier fitting with the tool
                cube( [local_shd-gap(),local_shd-gap(),local_shl], center=true );
                cylinder( r=p[I_TAP]/2,  h=local_shl, center=true );
            }
            //mxBevelShape( local_shl, local_shd-gap(), a=BEVEL_SQUARE_A, b=false );
            mxBevelShape( local_shl, (local_shd-gap())/cos(45)-5*p[I_TD]/10, a=BEVEL_SQUARE_A, b=bt, t=bb );
            cylinder( r=(local_shd-gap())/2/cos(45)-p[I_TD]/10,  h=local_shl, center=true );
        }
}

// l    : head length
// d    : diameter or tangent circle on top of head
// a    : beveling angle
// t    : true to get the top bevel
// b    : true to get the bottom bevel
module mxBevelShape( l, d, a=BEVEL_HEXA_A, b=true, t=true ) {
    h  = (d/2)*tan(a);
    r  = (l+h)/tan(a);
    intersection() {
        if ( t ) {
            translate([0,0,-l/2])
            cylinder( r1=r, r2=0, h=(l+h) );
        }
        if ( b ) {
            translate([0,0,-h-l/2])
            cylinder( r1=0, r2=r, h=(l+h) );
        }
    }
}

// Mx constructors
//   tl:  Thread length,                    -1 = use common value
//   tlp: Thread length passage,            -1 = tl
//   hl:  Head length for all type of head, -1 = use standard values
//   hlp: Head length passage,              -1 = use common value
//   tdp: Thread diameter passage,          -1 = computed from td and gap()
//   hd:  Head external diameter,           -1 = use standard value
//   hdp: Head external diameter,           -1 = use common value
function M1_6 (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(0,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M2   (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(1,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M2_5 (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(2,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M3   (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(3,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M4   (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(4,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M5   (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(5,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M6   (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(6,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M8   (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(7,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M10  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(8,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M12  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(9,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M14  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(10,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M16  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(11,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M18  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(12,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M20  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(13,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M22  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(14,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M24  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(15,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M27  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(16,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M30  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(17,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M33  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(18,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M36  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(19,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M39  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(20,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M42  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(21,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M45  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(22,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M48  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(23,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M52  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(24,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M56  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(25,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M60  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(26,tl,tlp,hl,hl,hlp,tdp,hd,hdp);
function M64  (tl=-1,tlp=-1,hl=-1,hlp=-1,tdp=-1,hd=-1,hdp=-1) = mxData(27,tl,tlp,hl,hl,hlp,tdp,hd,hdp);

// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
function mxGuess ( td, tl=-1,tlp=-1, hl=-1, hlp=-1,tdp=-1,hd=-1,hdp=-1) =
let (
    dists    = [ for( i=[0:len(MXDATA)-1] ) let ( diff=MXDATA[i][CTD]-abs(td) )
        ( diff==0 || sign(td)==0 || sign(td)==sign(diff) ) ? abs(diff) : 1e100 ],
    sorted   = sortIndexed(dists),
    filtered = [ for (a=sorted) if (a[0]!=1e100) a ],
    idx      = len(filtered)==0 ? undef : filtered[0][1]
)
mxData(
    idx = idx,
    tl  = tl,
    tlp = tlp,
    ahl = hl,
    hhl = hl,
    hlp = hlp,
    tdp = tdp,
    hd  = hd,
    hdp = hdp
);

// Clones a screw allowing to overrides some characteristics
function mxClone (p,tl=-1,tlp=-1, ahl=-1, hhl=-1, hlp=-1,tdp=-1,hd=-1,hdp=-1) =
mxData(
    idx = p[I_IDX],
    tl  = tl<0  ? p[I_TL]  : tl,
    tlp = tlp<0 ? p[I_TLP] : tlp,
    ahl = ahl<0 ? p[I_AHL] : ahl,
    hhl = hhl<0 ? p[I_HHL] : hhl,
    hlp = hlp<0 ? p[I_HLP] : hlp,
    tdp = tdp<0 ? p[I_TDP] : tdp,
    hd  = hd<0  ? p[I_HHD] : hd,
    hdp = hdp<0 ? p[I_HDP] : hdp
);

// Data accessors on data
function mxGetIdx(s)                 = s[I_IDX];
function mxGetName(s)                = s[I_NAME];
function mxGetTapD(s)                = s[I_TAP];
function mxGetPitch(s)               = s[I_TP];
function mxGetThreadD(s)             = s[I_TD];
function mxGetThreadDP(s)            = s[I_TDP];
function mxGetThreadL(s)             = s[I_TL];
function mxGetThreadLP(s)            = s[I_TLP];
function mxGetHeadDP(s)              = s[I_HDP];
function mxGetHeadLP(s)              = s[I_HLP];

function mxGetAllenHeadD(s)          = s[I_AHD];
function mxGetAllenHeadL(s)          = s[I_AHL];
function mxGetAllenToolSize(s)       = s[I_ATS];

function mxGetHexagonalHeadD(s)      = s[I_HHD];
function mxGetHexagonalHeadL(s)      = s[I_HHL];
function mxGetHexagonalToolSize(s)   = s[I_HTS];

function mxGetSquareHeadD(s)         = s[I_HTS];
function mxGetSquareHeadL(s)         = s[I_HHL];
function mxGetSquareToolSize(s)      = s[I_HTS];

// Values helpfull to draw threads
function mxGetFunctionalRadiuses(s)  = s[I_RADF];
function mxGetGlobalRadiuses(s)      = s[I_RADG];
function mxGetSmoothRadiuses(s)      = s[I_RADS];
function mxGetSmoothCenters(s)       = s[I_CENTR];
function mxGetFlatHalfLenght(s)      = s[I_FLAT];
function mxGetFlankAngle(s)          = s[I_ANGLE];


// ----------------------------------------
//
//    Implementation
//
// ----------------------------------------

// Renders a bolt with given parameters for Thread, Thread passage and Head
module mxBoltImpl( td, tl, tdp, tlp, hd, hl ) {
    translate( [0,0,+(tl+tlp)/2 ] )
        cylinder( r=td/2, h=tl-tlp, center=true );
    translate( [0,0,+tlp/2 ] )
        cylinder( r=tdp/2, h=tlp+VGG, center=true );
    if ( hl>0 ) {
        translate( [0,0,-hl/2 ] )
            cylinder( r=hd/2, h=hl, center=true );
    }
}

VGG            = 0.01;  // Visual Glich Guard
MFG            = 0.001; // Manifold Guard
MXANGLE        = 60;    // Metric thread flanks V angle
BEVEL_HEXA_A   = 30;    // Hexagonal head bevel angle
BEVEL_SQUARE_A = 30;    // Square head bevel angle
BEVEL_ALLEN_A  = 30;    // Allen head bevel angle

I_IDX   =  0;
I_NAME  =  1;
I_TP    =  2; // Thread Pitch: Distance between threads
I_TAP   =  3; // Tap diameter
I_TD    =  4; // Thread Diameter
I_TDP   =  5; // Thread Passage Diameter
I_TL    =  6; // Thread Length
I_TLP   =  7; // Thread Passage Length
I_HDP   =  8; // Head Passage Diameter
I_HLP   =  9; // Head Passage Length
I_AHD   = 10; // Head Diameter for Allen head
I_AHL   = 11; // Head Length for Allen head
I_ATS   = 12; // Allen Tool Size
I_HHD   = 13; // Head Diameter for Hexagonal head
I_HHL   = 14; // Head Length for Hexagonal head
I_HTS   = 15; // Hexagonal Tool Size
I_RADF  = 16; // Functional thread enclosing radiuses (between flat parts)
I_RADG  = 17; // Global thread enclosing radiuses (with round parts)
I_FLAT  = 18; // Flat parts HALF length
I_RADS  = 19; // Smoothing parts Radiuses (circular parts)
I_CENTR = 20; // Centers of round parts
I_ANGLE = 21; // Thread flanks V angle

function mxGetDataLength() = len(MXDATA);
function mxData( idx, tl=-1, tlp=-1, ahl=-1, hhl=-1, hlp=-1, tdp=-1, hd=-1, hdp=-1 ) = let (
    local_tl  = tl<0 ? MXDATA[idx][CTL] : tl,
    local_tlp = (tlp<0 || tlp>local_tl) ? local_tl : tlp,
    local_hhl = hhl<0  ? MXDATA[idx][CHHL] : hhl,
    local_ahl = ahl<0  ? MXDATA[idx][CAHL] : ahl,
    local_hlp = hlp<0  ? MXDATA[idx][CHLP] : hlp,
    local_ahd = hd<0   ? MXDATA[idx][CAHD] : hd,
    local_hhd = hd<0   ? MXDATA[idx][CHTS]/cos(30) : hd,
    local_hts = hd<0   ? MXDATA[idx][CHTS] : hd*cos(30),
    local_hdp = hdp<0  ? MXDATA[idx][CHDP] : hdp,

    // Metric screw profile is well defined by wikipedia:
    //   https://en.wikipedia.org/wiki/ISO_metric_screw_thread
    p         = MXDATA[idx][CPITCH],
    Theta     = MXANGLE/2,
    H         = p/(2*tan(Theta)),
    Rmaj      = MXDATA[idx][CTD]/2,
    Rmin      = Rmaj - 5*H/8,
    Fmin      = p/8, // Flat part half length on Dmin
    Fmaj      = p/16,
    RRmin     = Fmin/cos(Theta),
    RRmaj     = Fmaj/cos(Theta),
    Cmin      = [ Fmin+MFG, Rmin+RRmin*sin(Theta) ],
    Cmaj      = [ Fmin+p/2, Rmaj-RRmaj*sin(Theta) ],
    RTop      = Cmaj.y+RRmaj,
    RBot      = Cmin.y-RRmin,

    // gap(): see mx-thread
    local_tdp = tdp<0 ? 2*(RTop+gap()) : tdp
) [
    idx,
    MXDATA[idx][CNAME],
    p,                         // TP
    MXDATA[idx][CTD]-p,        // TAP
    MXDATA[idx][CTD],          // TD
    local_tdp,                 // TDP
    local_tl,                  // TL
    local_tlp,                 // TLP
    local_hdp,                 // HDP
    local_hlp,                 // HLP
    local_ahd,                 // AHD 
    local_ahl,                 // AHL
    MXDATA[idx][CATS],         // ATS
    local_hhd,                 // HHD
    local_hhl,                 // HHL
    local_hts,                 // HTS
    [ Rmin,  Rmaj  ],          // RADF
    [ RBot,  RTop  ],          // RADE
    [ Fmin,  Fmaj  ],          // FLAT
    [ RRmin, RRmaj ],          // RADR
    [ Cmin,  Cmaj  ],          // CENTR
    MXANGLE                    // ANGLE
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
translate([0,0,+mxGetThreadL(M64())] )
    color( "silver", 0.5 )
    mxNutHexagonal( M64(), $fn=100 );
translate([60,0]) {
    color( "gold" )
        mxBoltAllen( M1_6(), $fn=100 );
    color( "silver", 0.5 )
        mxNutSquare( M1_6(), $fn=100 );
}

echo( "mxGuess(   2):    expected M2: ",   mxGetName(mxGuess(2)) ) ;
echo( "mxGuess(  -2):    expected M2: ",   mxGetName(mxGuess(-2)) ) ;
echo( "mxGuess(  -1.99): expected M1.6: ", mxGetName(mxGuess(-1.99)) ) ;
echo( "mxGuess(   2.1):  expected M2.5: ", mxGetName(mxGuess(2.1)) ) ;
echo( "mxGuess(   0):    expected M1.6: ", mxGetName(mxGuess(0)) ) ;
echo( "mxGuess( 100):    expected undef:", mxGetName(mxGuess(100)) ) ;
echo( "mxGuess(-100):    expected M64:",   mxGetName(mxGuess(-100)) ) ;

