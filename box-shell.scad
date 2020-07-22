/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Simple box shell split in 2 parts assembled with lips
 * Author:      Gilles Bouissac
 */

use <scad-utils/lists.scad>
use <scad-utils/mirror.scad>
use <agentscad/printing.scad>
use <agentscad/extensions.scad>
use <agentscad/bevel.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// sx:  internal size on x
// sy:  internal size on y
// tsz: internal top size on z
// bsz: internal bottom size on z
// t:   bottom and top plate thickness
// wt:  wall thickness
// lps: lips height
function newBoxShell (
    sx, sy, tsz, bsz,
    t    = BOX_BOTTOM_T,
    wt   = BOX_WALL_T,
    lps  = undef
) = let(
    sz  = tsz+bsz,
    esz = sz+2*t,
    esx = sx+2*wt,
    esy = sy+2*wt
) [
    sx, sy, sz,
    esx, esy, esz,
    tsz, bsz,
    tsz+t, bsz+t,
    t, wt, is_undef(lps) ? BOX_LIPS_H : lps
];
IB_SX     = 0;
IB_SY     = 1;
IB_SZ     = 2;
IB_ESX    = 3;
IB_ESY    = 4;
IB_ESZ    = 5;
IB_TSZ    = 6;
IB_BSZ    = 7;
IB_ETSZ   = 8;
IB_EBSZ   = 9;
IB_T      = 10;
IB_WT     = 11;
IB_LPS    = 12;

// Accessors to parameters
function getBoxShellIntSx(p)    = p[IB_SX];
function getBoxShellIntSy(p)    = p[IB_SY];
function getBoxShellIntSz(p)    = p[IB_SZ];
function getBoxShellExtSx(p)    = p[IB_ESX];
function getBoxShellExtSy(p)    = p[IB_ESY];
function getBoxShellExtSz(p)    = p[IB_ESZ];
function getBoxShellTopIntSz(p) = p[IB_TSZ];
function getBoxShellBotIntSz(p) = p[IB_BSZ];
function getBoxShellTopExtSz(p) = p[IB_ETSZ];
function getBoxShellBotExtSz(p) = p[IB_EBSZ];
function getBoxShellMainT(p)    = p[IB_T];
function getBoxShellWallT(p)    = p[IB_WT];
function getBoxShellLipsH(p)    = p[IB_LPS];

// Top part of the box
module boxShellTop( box ) {
    difference() {
        boxShellTopShape(box);
        boxShellTopHollow(box);
        boxShellTopBevel(box);
    }
}

// Bottom part of the box
module boxShellBottom( box ) {
    difference() {
        boxShellBottomShape(box);
        boxShellBottomHollow(box);
        boxShellBottomBevel(box);
    }
}

// ----------------------------------------
//             Implementation
// ---------------------------------------
BOX_BOTTOM_T = 1.0;
BOX_WALL_T   = 1.5;
BOX_LIPS_H   = 2.0;

module boxShellHollow ( params ) {
    cube( [params[IB_SX], params[IB_SY], params[IB_SZ]], center=true );
    translate( [0, 0, -params[IB_SZ]/2+params[IB_BSZ]+params[IB_LPS]/2 ] )
        cube( [
            params[IB_ESX],
            params[IB_ESY],
            params[IB_LPS]
        ],
        center=true );
}
module boxShellTopHollow ( params ) {
    translate( [0, 0, +params[IB_SZ]/2-params[IB_TSZ]/2 ] )
        cube( [params[IB_SX], params[IB_SY], params[IB_TSZ]], center=true );
    boxShellLipsHollow( params, inner=false );
}
module boxShellBottomHollow ( params ) {
    translate( [0, 0, -params[IB_SZ]/2+params[IB_BSZ]/2 ] )
        cube( [params[IB_SX], params[IB_SY], params[IB_BSZ]], center=true );
    boxShellLipsHollow( params, inner=true );
}
module boxShellTopBevel( params ) {
    boxShellBevel( params );
}
module boxShellBottomBevel( params ) {
    boxShellBevel( params );
}

module boxShellBevel( params ) {
    mirror_y()
        translate( [params[IB_ESX]/2, params[IB_ESY]/2, 0 ] )
        rotate( [0,0,90] )
        bevelCutLinear( params[IB_ESX], params[IB_ESZ] );
    mirror_x()
        translate( [params[IB_ESX]/2, 0, -params[IB_ESZ]/2 ] )
        rotate( [90,0,0] )
        bevelCutLinear( params[IB_ESZ], params[IB_ESY] );
    mirror_x()
        translate( [params[IB_ESX]/2, -params[IB_ESY]/2, 0 ] )
        bevelCutLinear( params[IB_ESY], params[IB_ESZ] );
}

module boxShellTopShape( params ) {
    h = params[IB_ETSZ] - params[IB_LPS] ;
    translate( [0, 0, +params[IB_ESZ]/2-h/2 ] )
        cube( [params[IB_ESX], params[IB_ESY], h], center=true );
    difference() {
        boxShellLipsShape ( params, false );
        boxShellLipsHollow ( params, false );
    }
}
module boxShellBottomShape( params ) {
    translate( [0, 0, -params[IB_ESZ]/2+params[IB_EBSZ]/2 ] )
        cube( [params[IB_ESX], params[IB_ESY], params[IB_EBSZ]], center=true );
    boxShellLipsShape ( params, true );
}
module boxShellShape( params ) {
    cube( [params[IB_ESX], params[IB_ESY], params[IB_ESZ]], center=true );
}

module boxShellLipsShape( params, inner=true ) {
    wt = params[IB_WT];
    sx = params[IB_ESX] - ( inner ? wt+gap()/2: 0 ) ;
    sy = params[IB_ESY] - ( inner ? wt+gap()/2: 0 ) ;
    h  = params[IB_LPS]-gap();

    translate( [0, 0, -params[IB_SZ]/2+params[IB_BSZ] + h/2 + ( inner ? 0 : gap() ) ] )
        cube( [sx, sy, h], center=true );
}
module boxShellLipsHollow( params, inner=true ) {
    wt = params[IB_WT];
    sx = params[IB_ESX] - ( inner ? wt+gap()/2: 0 ) ;
    sy = params[IB_ESY] - ( inner ? wt+gap()/2: 0 ) ;
    h  = params[IB_LPS]-gap()+2*mfg();

    translate( [0, 0, -params[IB_SZ]/2+params[IB_BSZ] + h/2 + ( inner ? 0 : gap() )-mfg() ] )
        cube( [sx-wt+gap()/2, sy-wt+gap()/2, h], center=true );
}

// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 100;
SEPARATION = 0;
SHOW_SX    = 40;
SHOW_SY    = 20;
SHOW_TSZ   = 8;
SHOW_BSZ   = 4;

module showBoxShell( part=0, cut=undef, cut_rotation=undef ) {
    box = newBoxShell ( SHOW_SX, SHOW_SY, SHOW_TSZ, SHOW_BSZ );

    if ( part==0 ) {
        intersection () {
            union() {
                translate( [0,0,+SEPARATION] )
                    boxShellTop( box );
                translate( [0,0,-SEPARATION] )
                    boxShellBottom( box );
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    if ( part==1 ) {
        boxShellBottom( box );
    }
    if ( part==2 ) {
        rotate( [180,0,0] )
            boxShellTop( box );
    }
}

// 0: all
// 1: bottom
// 2: top
showBoxShell ( 0, 0, 20, $fn=PRECISION );

