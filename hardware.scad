/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Various hardwares
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <agentscad/bevel.scad>
use <scad-utils/shapes.scad>
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>

// ----------------------------------------
//              API - ZIP TIE
// ----------------------------------------

// tw:  Tie width
// tl:  Tie length
// th:  Tie height (thickness)
// hw:  Head width
// hl:  Head length
// hh:  Head height (thickness)
function newZipTie (
    tw, tl, th,
    hw, hl, hh
) = [ CZIP_S, tw, tl, th, hw, hl, hh ];

// Standard 2.5mm zip tie
function newZipTie2_5( tw=2.5, tl=120, th=1.2, hw=5, hl=5, hh=3.5 ) =
    newZipTie ( tw, tl, th, hw, hl, hh );

function makeZipStraight ( zip, l=undef ) = concat ( [
    CZIP_S,
    zip[1], is_undef(l)?zip[2]:l, zip[3],
    zip[4], zip[5], zip[6]
]);
function makeZipU ( zip, radius, sep=0, l=undef ) = concat ( [
    CZIP_U,
    zip[1], is_undef(l)?zip[2]:l, zip[3],
    zip[4], zip[5], zip[6],
    radius, sep
]);
function makeZipOblong ( zip, radius, sep=0, l=undef ) = concat ( [
    CZIP_O,
    zip[1], is_undef(l)?zip[2]:l, zip[3],
    zip[4], zip[5], zip[6],
    radius, sep
]);

function getZipTieTw(p) = is_undef(p) ? 0 : p[IZ_TW];
function getZipTieTl(p) = is_undef(p) ? 0 : p[IZ_TL];
function getZipTieTh(p) = is_undef(p) ? 0 : p[IZ_TH];
function getZipTieHw(p) = is_undef(p) ? 0 : p[IZ_HW];
function getZipTieHl(p) = is_undef(p) ? 0 : p[IZ_HL];
function getZipTieHh(p) = is_undef(p) ? 0 : p[IZ_HH];


// Render the zip bent in U shape with given radius
module zipShape ( zip, head=true ) {
    if ( class(zip)==CZIP_U )
        zipUShape ( zip, head=head );
    else if ( class(zip)==CZIP_O )
        zipOblongShape ( zip, head=head );
    else
        zipUShape ( zip, head=head);
}
module zipShapePassage ( zip, head=true ) {
    if ( class(zip)==CZIP_U )
        zipUShape ( zip, gap(), head=head );
    else if ( class(zip)==CZIP_O )
        zipOblongShape ( zip, gap(), head=head );
    else
        zipUShape ( zip, gap(), head=head );
}
module zipConduitShape ( zip, t=WALL_T ) {
    if ( class(zip)==CZIP_U )
        zipUShape ( zip, t+gap(), head=false );
    else if ( class(zip)==CZIP_O )
        zipOblongShape ( zip, t+gap(), head=false );
    else
        zipUShape ( zip, t+gap(), head=false );
}
module zipConduitHollow ( zip ) {
    zipShapePassage ( zip, head=false );
}

// ----------------------------------------
//            API - ER Collets
// ----------------------------------------
// https://sc01.alicdn.com/kf/HTB1E20DLVXXXXXdXVXXq6xXFXXXv/222369115/HTB1E20DLVXXXXXdXVXXq6xXFXXXv.jpg

// Creates a new collet object
//
// D: Collet external diameter / Reference
// d: Grip/internal diameter
function newERCollet ( D=11, d=7 ) = ERColletData(D, d);
function newER8  ( d= 5 ) = newERCollet( 8, d);
function newER11 ( d= 7 ) = newERCollet(11, d);
function newER16 ( d=10 ) = newERCollet(16, d);
function newER20 ( d=13 ) = newERCollet(20, d);
function newER25 ( d=16 ) = newERCollet(25, d);
function newER32 ( d=20 ) = newERCollet(32, d);
function newER40 ( d=26 ) = newERCollet(40, d);
function newER50 ( d=34 ) = newERCollet(50, d);


// Render the collet
//
// collet:  Collet created with newERxxxx functions
// wings:   Number of wings, auto computed if undef
// slot:    Slots width, auto computed if undef
// gap:     Gap around the shape, no gap if undef
module ERCollet ( collet, wings=undef, slot=undef ) {
    difference() {
        ERColletShape  ( collet );
        ERColletHollow ( collet, wings, slot );
    }
}

// Render the collet shape
//
// collet:  Collet created with newERxxxx functions
module ERColletShape ( collet ) {
    class = assertClass(collet,classERCollet());
    rl1   = collet[IER_D]/2;
    rl2   = collet[IER_D2]/2;
    overguard = (rl1-rl2)/tan(overhang());
    rbase = collet[IER_DB]/2;
    rtop  = collet[IER_DT]/2;
    rmidbot  = rl1;
    rmidtop  = rl1;
    skin ([
        transform( translation([0,0,0]), circle(rbase)),
        transform( translation([0,0,collet[IER_L1]]), circle(rmidbot)),
        transform( translation([0,0,collet[IER_L1]+overguard]), circle(rl2)),
        transform( translation([0,0,collet[IER_L]-collet[IER_L3]]), circle(rl2)),
        transform( translation([0,0,collet[IER_L]-collet[IER_L3]]), circle(rmidtop)),
        transform( translation([0,0,collet[IER_L]]), circle(rtop))
    ]);
}

// Render the collet hollow part
//
// collet:  Collet created with newERxxxx functions
// wings:   Number of wings, auto computed if undef
// slot:    Slots width, auto computed if undef
ER_WINGS_MAX = 8;
module ERColletHollow ( collet, wings=undef, slot=undef ) {
    class = assertClass(collet,classERCollet());
    // rg: radius of tool (grip)
    rg = collet[IER_DG]/2;

    // sl: slot width linear
    slmin = (PI*rg/90)*asin(collet[IER_SMIN]/(2*rg));

    // nl: nozzle linear
    nl = (PI*rg/90)*asin(nozzle()/(2*rg));

    // wl: wing width linear
    wlmin = 2*slmin + 2*nl;

    // wn: number of wings
    wn = is_undef(wings) ? min(ER_WINGS_MAX, floor(2*PI*rg/wlmin) ) : wings;
    wl = 2*PI*rg/wn;
    sl = (wl-2*nl)/2;

    // s: slot width straight
    scomputed = 2*rg*sin(sl/(PI*rg/90));
    s = is_undef(slot)  ? min(collet[IER_SMAX],max(collet[IER_SMIN],scomputed)) : slot;

    wall = collet[IER_L3]/2;
    sx = 1000;
    sz = collet[IER_L];
    angle = 360/wn;

    cylinder(r=rg, h=collet[IER_L]);
    for ( i=[0:wn] ) {
        rotate([0,0,i*angle])
            translate([sx/2,0,sz/2+wall])
            cube([sx,s,sz], center=true);
        rotate([0,0,angle/2+i*angle])
            translate([sx/2,0,sz/2-wall])
            cube([sx,s,sz], center=true);
    }
}

// Render the collet passage
//
// collet:  Collet created with newERxxxx functions
// e:       Additional extrusion on top and bottom of the shape
module ERColletPassage ( collet, e=undef ) {
    class = assertClass(collet,classERCollet());
    g = gap();
    extrude = is_undef(e) ? 0 : e;
    rbase = collet[IER_DB]/2 + g*(1-tan(collet[IER_AS]));
    rtop  = collet[IER_DT]/2 + g*(1-tan(collet[IER_AG]));
    rmid  = collet[IER_D]/2  + g;
    skin (concat(
        extrude>0 ? [ transform( translation([0,0,-extrude-g]), circle(rbase)) ] : [],
        [
            transform( translation([0,0,-g]), circle(rbase)),
            transform( translation([0,0,collet[IER_L1]]), circle(rmid)),
            transform( translation([0,0,collet[IER_L]-collet[IER_L3]]), circle(rmid)),
            transform( translation([0,0,collet[IER_L]+g]), circle(rtop))
        ],
        extrude>0 ? [ transform( translation([0,0,collet[IER_L]+extrude+g]), circle(rtop)) ] : []
    ));
}

// Render collet extractor ring
//
// collet: Collet created with newERxxxx functions
// d:      Extra diameter, auto computed if undef
// t:      Ring thickness, auto computed if undef
module ERColletExtractorRing ( collet, d=undef, t=undef ) {
    class = assertClass(collet,classERCollet());
    groovew = collet[IER_L]-collet[IER_L1]-collet[IER_L3];
    local_t = is_undef(t) ? collet[IER_RT] : t;
    r2 = is_undef(d) ? collet[IER_D]/2+2*gap() : d ;

    translate([0,0,collet[IER_L]-collet[IER_L3]-local_t])
    difference() {
        cylinder(r=r2, h=local_t);
        skin([
            transform(translation(collet[IER_RTR])*translation([0,0,-mfg()]),
                circle(r=collet[IER_RD]/2+gap())),
            transform(translation(collet[IER_RTR])*translation([0,0,local_t+mfg()]),
                circle(r=collet[IER_RD]/2+gap()))
        ]);
    }
}

// ----------------------------------------
//         ZIP TIE - Implementation
// ----------------------------------------
WALL_T     = 1.2;

CUNKNOWN = undef;
CZIP_S   = 100; // Class: Straight zip tie
CZIP_U   = 101; // Class: U shape zip tie
CZIP_O   = 102; // Class: Oblong shape zip tie

I_CLASS    = 0;
function class( o ) = is_undef(o) ? CUNKNOWN : is_list(o) ? o[I_CLASS] : CUNKNOWN;

// Base params
IZ_TW      = 1;
IZ_TL      = 2;
IZ_TH      = 3;
IZ_HW      = 4;
IZ_HL      = 5;
IZ_HH      = 6;
IZ_RAD     = 7;
IZ_SEP     = 8;

// zip:      zip tie object
// gap:      gap around shape
// head:     render zip head or not
module zipUShape ( zip, gap=0, head=true ) {
    radius = zip[IZ_RAD];
    sep    = zip[IZ_SEP];
    lu     = PI*radius;
    hl     = (zip[IZ_TL]-lu)/2+zip[IZ_HL];

    translate ( [0,0,-hl/2] ) {
        // Vertical parts
        translate ( [0,+(radius+sep/2),zip[IZ_HL]/2] )
            cube ( [ zip[IZ_TW]+2*gap, zip[IZ_TH]+2*gap, hl-zip[IZ_HL]+2*mfg() ], center=true );
        translate ( [0,-(radius+sep/2),0] )
            cube ( [ zip[IZ_TW]+2*gap, zip[IZ_TH]+2*gap, hl+2*mfg() ], center=true );
        // Separator
        translate ( [0,0,hl/2+radius] )
            cube ( [ zip[IZ_TW]+2*gap, sep, zip[IZ_TH]+2*gap ], center=true );
        // U part
        cloneMirror([0,1,0])
        translate ( [0,sep/2,hl/2] )
            rotate( [0,-90,0] )
                rotate_extrude ( angle=90 )
                    translate ( [radius,0,0] )
                        square( [zip[IZ_TH]+2*gap,zip[IZ_TW]+2*gap], center=true );
        // Head
        if ( head ) {
            translate ( [0,radius+zip[IZ_HH]/2-zip[IZ_TH]/2+sep/2,zip[IZ_HL]/2-hl/2] )
                cube ( [ zip[IZ_HW]+2*gap, zip[IZ_HH]+2*gap, zip[IZ_HL]+2*gap ], center=true );
        }
    }
}

// zip:      zip tie object
// gap:      gap around shape
// head:     render zip head or not
module zipOblongShape ( zip, gap=0, head=true ) {
    radius = zip[IZ_RAD];
    sep    = zip[IZ_SEP];
    rint   = radius+gap();
    rext   = radius+zip[IZ_TH]+gap();

    // Tie
    difference() {
        oblong ( rext+gap, zip[IZ_TW], sep, center=true );
        oblong ( rint-gap, zip[IZ_TW], sep, center=true );
    }
    // Head
    if ( head ) {
        translate ( [rint*3/4+zip[IZ_HH]/2-gap,sep/2,0] )
            rotate ( [0,0,10] )
            translate ( [gap,0,0] )
            cube ( [ zip[IZ_HH]+2*gap, zip[IZ_HW]+2*gap, zip[IZ_HL]+2*gap ], center=true );
    }
}

// ----------------------------------------
//       ER Collets - Implementation
// ----------------------------------------
function classERCollet()  = "ERCollet";
ER_COLLET_DATA = [
//| Class          |  Name   |  d1  |  D  |  d2  |   L  |  L1  |  L2  |  L3  |  A1  |  A2  | SMIN | SMAX |
  [ classERCollet(),  "ER8"  ,     8,  8.5,   6.5,  13.5,  10.8,  2.98,   1.5,  30.0,   8.0,   0.1,  0.2 ],
  [ classERCollet(),  "ER11" ,    11, 11.5,   9.5,  18.0,  13.5,  3.80,   2.5,  30.0,   8.0,   0.1,  0.3 ],
  [ classERCollet(),  "ER16" ,    16, 17.0,  13.8,  27.5,  20.8,  6.26,   4.0,  30.0,   8.0,   0.1,  0.4 ],
  [ classERCollet(),  "ER20" ,    20, 21.0,  17.4,  31.5,  23.9,  6.36,   4.8,  30.0,   8.0,   0.2,  0.5 ],
  [ classERCollet(),  "ER25" ,    25, 26.0,  22.0,  34.0,  25.9,  6.66,   5.0,  30.0,   8.0,   0.2,  0.6 ],
  [ classERCollet(),  "ER32" ,    32, 33.0,  29.2,  40.0,  30.9,  7.16,   5.5,  30.0,   8.0,   0.3,  0.7 ],
  [ classERCollet(),  "ER40" ,    40, 41.0,  36.2,  46.0,  34.9,  7.66,   7.0,  30.0,   8.0,   0.3,  0.8 ],
  [ classERCollet(),  "ER50" ,    50, 52.0,  46.0,  60.0,  46.0,  13.4,   8.5,  30.0,   8.0,   0.3,  0.8 ],
];

// Input
IER_NAME      =  1; // Collet type name
IER_D1        =  2; // Advertized diameter at L-L3-L2
IER_D         =  3; // External diameter
IER_D2        =  4; // Inner diameter of groove
IER_L         =  5; // Whole length
IER_L1        =  6; // Length from bottom to groove
IER_L2        =  7; // Length from bottom to advertized diameter
IER_L3        =  8; // Length of grip
IER_AG        =  9; // Grip angle
IER_AS        = 10; // Slide angle
IER_SMIN      = 11; // Slot min width
IER_SMAX      = 12; // Slot max width
// Computed
IER_DG        = 13; // Collet grip diameter
IER_RT        = 14; // Extractor ring thickness
IER_RD        = 15; // Extractor ring diameter
IER_RTR       = 16; // Extractor ring translation vector
IER_DB        = 17; // Base diameter
IER_DT        = 18; // Top diameter

ER_RINGT_RATIO = 0.5;
ER_RINGT_MAX   = 2;
ER_RINGG_RATIO = 0.5;
function ERColletData(D, d) = let (
    dists    = [ for( i=[0:len(ER_COLLET_DATA)-1] )
        abs ( diff=ER_COLLET_DATA[i][IER_D1]-abs(D) )
    ],
    sorted  = sortIndexed(dists),
    rawdata = ER_COLLET_DATA[sorted[0][1]],
    groovew = rawdata[IER_L]-rawdata[IER_L1]-rawdata[IER_L3],
    eringt  = min(ER_RINGT_MAX, floor(10*groovew*ER_RINGT_RATIO)/10),

    dr = rawdata[IER_D]/2-rawdata[IER_D2]/2,
    grip = ER_RINGG_RATIO*dr,
    ungrip = dr-grip,
    eringd = rawdata[IER_D2] + dr + ungrip,
    eringtr = [-grip/2,0,0],
    dbase = rawdata[IER_D] - 2 * rawdata[IER_L1] * tan(rawdata[IER_AS]),
    dtop  = rawdata[IER_D] - 2 * rawdata[IER_L3] * tan(rawdata[IER_AG])
) sorted[0][0]!=0 ? undef : concat(rawdata,[d,eringt,eringd,eringtr,dbase,dtop]);

function ERColletGetName(c)  = c[IER_NAME];
function ERColletGetD(c)     = c[IER_D];
function ERColletGetD1(c)    = c[IER_D1];
function ERColletGetD2(c)    = c[IER_D2];
function ERColletGetDG(c)    = c[IER_DG];
function ERColletGetL(c)     = c[IER_L];
function ERColletGetL1(c)    = c[IER_L1];
function ERColletGetL2(c)    = c[IER_L2];
function ERColletGetL3(c)    = c[IER_L3];
function ERColletGetRT(c)    = c[IER_RT];
function ERColletGetRD(c)    = c[IER_RD];
function ERColletGetRTr(c)   = c[IER_RTR];
function ERColletGetBaseD(c) = c[IER_DB];
function ERColletGetTopD(c)  = c[IER_DT];


// ----------------------------------------
//                Showcase
// ----------------------------------------

// See test/test-hardware.scad
