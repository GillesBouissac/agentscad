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

// ----------------------------------------
//                   API
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
//             Implementation
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
//                Showcase
// ----------------------------------------
PRECISION  = 100;
SEPARATION = 0;

module show_parts( part=0, cut=undef, cut_rotation=undef ) {
    zip   = newZipTie2_5();
    zipu1 = makeZipU( zip, 20 );
    zipu2 = makeZipU( zip, 10, 5 );
    zipo1 = makeZipOblong( zip, 1.5, 3 );
    if ( part==0 ) {
        intersection () {
            union() {
                zipShape ( zipu1 );
                rotate( [0,90,0] )
                    zipShape ( zipo1 );
                translate( [0, 0, 2])
                    difference() {
                        zipConduitShape ( zipu2 );
                        zipConduitHollow( zipu2 );
                    }
                }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    if ( part==1 ) {
        #zipShapePassage ( zipu2, $gap=1 );
        zipShape ( zipu2 );
    }
    if ( part==2 ) {
        #zipShapePassage ( zipo1 );
        zipShape ( zipo1 );
    }
    if ( part==3 ) {
        difference() {
            zipConduitShape( zipu2 );
            zipConduitHollow( zipu2 );
        }
    }
}

// 0: all
// 1: zip U shape
// 2: zip Obblong shape
// 3: zip U shape conduit
show_parts ( 0, 0, -90, $fn=PRECISION );
