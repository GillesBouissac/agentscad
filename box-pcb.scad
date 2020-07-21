/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Customizable box for pcb module
 * Author:      Gilles Bouissac
 */

use <scad-utils/lists.scad>
use <scad-utils/mirror.scad>
use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <agentscad/electronic.scad>
use <agentscad/hardware.scad>
use <agentscad/box-shell.scad>
use <agentscad/mx-screw.scad>
use <agentscad/screw-stand.scad>
use <agentscad/cable-gland.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// pcb:       pcb object (see newPcb)
// shell:    [Optional] box draft: sx, sy, tsz will be adapted to enclose the PCB
// cables:   [Optional] cables definitions: will generate cable gland, can be a single cable or a list
// cablezip: [Optional] Internal zip tie to hold cable in cable gland
// boxzip:   [Optional] External zip tie to hold the box
// i:        [Optional] screws head incrustation
function newPcbBox (
    pcb,
    shell        = undef,
    cables       = undef,
    cablezip     = undef,
    boxzip       = undef,
    margin       = undef,
    incrustation = undef,
) = let(
    margins  = is_list(margin) ? margin : [margin,margin,margin],
    l_i      = is_undef(incrustation) ? 0 : incrustation,
    sx       = getPcbSx(pcb)+2*gap()+2*margins[0],
    sy       = getPcbSy(pcb)+2*gap()+2*margins[1],
    sz       = getPcbSz(pcb)+2*gap()+2*margins[2],
    d_bsz    = getPcbBelow(pcb)+getPcbT(pcb)+gap()+margins[2],
    bsz      = is_undef(shell) ? d_bsz : (is_undef(getBoxShellBotIntSz(shell))?d_bsz:getBoxShellBotIntSz(shell)),
    tsz      = sz-bsz,
    t        = is_undef(shell) ? BOX_BOTTOM_T : getBoxShellMainT(shell),
    wt       = is_undef(shell) ? BOX_WALL_T : getBoxShellWallT(shell),
    lps      = is_undef(shell) ? undef : getBoxShellLipsH(shell),
    glands   = newPcbBoxCableGlands(cables,cablezip,pcb,t,wt,margins),
    pcbh     = getPcbBelow(pcb)+getPcbT(pcb)+gap()+margins[2]+t,
    pcb_tr   = sum ( concat([ for (gland=glands) gland[2] ], [[0,0,0]] ) ),
    augment  = sum ( concat([ for (gland=glands) gland[3] ], [[0,0,0]] ) ),
    l_shell  = newBoxShell (sx+augment[0], sy+augment[1], tsz+augment[2]/2, bsz+augment[2]/2, t, wt, lps ),
    stands   = newPcbBoxStands(pcb,l_shell,pcb_tr,l_i,o=standOrientationDownTop()),
    zip_cw   = getZipTieTw(boxzip)+2*gap()+2*wt,
    zip_tr   = [getBoxShellExtSx(l_shell)/2-zip_cw/2-t,0,0]
) [ pcb, pcb_tr, l_shell, stands, glands, boxzip, zip_tr ];
function getPcbBoxPcb(p)            = p[IB_PCB];
function getPcbBoxPcbTranslation(p) = p[IB_PCBTR];
function getPcbBoxShell(p)          = p[IB_BOX];
function getPcbBoxStands(p)         = p[IB_STANDS];
function getPcbBoxCables(p)         = p[IB_GLANDS];
function getPcbBoxZip(p)            = p[IB_ZIP];
function getPcbBoxZipTranslation(p) = p[IB_ZIPTR];

module pcbBoxTop ( pcbBox ) {
    difference() {
        pcbBoxTopShape ( pcbBox ) ;
        pcbBoxTopHollow ( pcbBox ) ;
        pcbBoxTopBevel ( pcbBox ) ;
    }
}
module pcbBoxBottom ( pcbBox ) {
    difference() {
        pcbBoxBottomShape ( pcbBox ) ;
        pcbBoxBottomHollow ( pcbBox ) ;
        pcbBoxBottomBevel ( pcbBox ) ;
    }
}

// ----------------------------------------
//             Implementation
// ----------------------------------------
BOX_BEVEL           = 2.0;
BOX_BOTTOM_T        = 1.0;
BOX_WALL_T          = 1.5;

IB_PCB    = 0;
IB_PCBTR  = 1;
IB_BOX    = 2;
IB_STANDS = 3;
IB_GLANDS = 4;
IB_ZIP    = 5;
IB_ZIPTR  = 6;

function makeObjectList(o) = is_undef(o) ? [] :
    !is_list( o ) ? [o] :
    len(o)==0 ? [] :
    is_list( o[0] ) ? o : [o];

function newPcbBoxStands(pcb,shell,pcb_tr,i,o) =
let(
    l = getBoxShellExtSz(shell),
    d = pcb_tr[2]+l/2+getPcbDz(pcb)-gap(),
    h = getPcbT(pcb)+2*gap()
)[
    for ( hole=getPcbHoles(pcb) )
        newScrewStand(x=hole[0],y=hole[1],s=hole[2],l=l,d=d,h=h,i=i,o=o)
];

function newPcbBoxCableGlands( cables, zip, pcb, t, wt, margins ) = let(
    l_cables = makeObjectList(cables)
) [ for(cable=l_cables) newPcbBoxCableGland(cable, zip, pcb, t, wt, margins) ];

function newPcbBoxCableGland( cable, zip, pcb, t, wt, margins ) = let(
    l_v     = getCableV(cable),
    l_max   = max( [ for(e=l_v) abs(e) ] )
)   l_v[0]==+l_max ? newPcbBoxCableGlandX(cable, zip, pcb, t, wt, margins, [+1,0,0]) :
    l_v[0]==-l_max ? newPcbBoxCableGlandX(cable, zip, pcb, t, wt, margins, [-1,0,0]) :
    l_v[1]==+l_max ? newPcbBoxCableGlandY(cable, zip, pcb, t, wt, margins, [0,+1,0]) :
    l_v[1]==-l_max ? newPcbBoxCableGlandY(cable, zip, pcb, t, wt, margins, [0,-1,0]) :
    l_v[2]==+l_max ? newPcbBoxCableGlandZ(cable, zip, pcb, t, wt, margins, [0,0,+1]) :
                     newPcbBoxCableGlandZ(cable, zip, pcb, t, wt, margins, [0,0,-1]) ;
function newPcbBoxCableGlandX(cable, zip, pcb, t, wt, margins, v) = let (
    o = getPcbSx(pcb)/2+margins[0]+gap(),
    l = getZipTieHw(zip) + 2*gap(),
    w = getPcbSy(pcb)+2*margins[1]+2*gap()+2*wt,
    h = getPcbSz(pcb)+2*margins[2]+2*gap()+2*t
) [
    newCableGland(newCable(r=getCableR(cable),i=getCableI(cable),c=getCableC(cable),v=v),zip,undef,w,h,wt=wt),
    [ v[0]*o, 0, 0 ],
    [ -v[0]*l/2, 0, 0 ],
    [ l, 0, 0 ]
];
function newPcbBoxCableGlandY(cable, zip, pcb, t, wt, margins, v) = let (
    o = getPcbSy(pcb)/2+margins[1]+gap(),
    l = getZipTieHw(zip) + 2*gap(),
    w = getPcbSx(pcb)+2*margins[0]+2*gap()+2*wt,
    h = getPcbSz(pcb)+2*margins[2]+2*gap()+2*t
) [
    newCableGland(newCable(r=getCableR(cable),i=getCableI(cable),c=getCableC(cable),v=v),zip,undef,w,h,wt=wt),
    [ 0, v[1]*o, 0 ],
    [ 0, -v[1]*l/2, 0 ],
    [ 0, l, 0 ]
];
function newPcbBoxCableGlandZ(cable, zip, pcb, t, wt, margins, v) = let (
    o = getPcbSz(pcb)/2+margins[2]+gap(),
    l = getZipTieHw(zip) + 2*gap(),
    w = getPcbSy(pcb)+2*margins[1]+2*gap()+2*wt,
    h = getPcbSx(pcb)+2*margins[0]+2*gap()+2*wt
) [
    newCableGland(newCable(r=getCableR(cable),i=getCableI(cable),c=getCableC(cable),v=v),zip,undef,w,h,wt=wt),
    [ 0, 0, v[2]*o ],
    [ 0, 0, -v[2]*l/2 ],
    [ 0, 0, l ]
];

module pcbBoxTopShape ( pcbBox ) {
    shell  = pcbBox[IB_BOX];
    boxzip = pcbBox[IB_ZIP];
    boxShellTopShape ( shell ) ;
    translate( [0,0,-getBoxShellExtSz(shell)/2] )
        translate( [ pcbBox[IB_PCBTR].x, pcbBox[IB_PCBTR].y, 0 ] )
            screwStandDrillShape ( pcbBox[IB_STANDS] );
    intersection() {
        boxShellTopShape ( shell ) ;
        for ( gland=pcbBox[IB_GLANDS] ) {
           translate( pcbBox[IB_PCBTR]+gland[1] )
                cableGlandCubeShape(gland[0]);
        }
    }
    if ( !is_undef(boxzip) )
        intersection() {
            boxShellTopShape ( shell ) ;
            mirror_x()
                translate( pcbBox[IB_ZIPTR] )
                    zipConduitShape ( boxzip, t=getBoxShellMainT(shell) ) ;
        }
}
module pcbBoxTopHollow ( pcbBox ) {
    shell  = pcbBox[IB_BOX];
    boxzip = pcbBox[IB_ZIP];
    difference() {
        boxShellTopHollow ( shell ) ;
        translate( [0,0,-getBoxShellExtSz(shell)/2] )
            translate( [ pcbBox[IB_PCBTR].x, pcbBox[IB_PCBTR].y, 0 ] )
                screwStandDrillShape ( pcbBox[IB_STANDS] );
        for ( gland=pcbBox[IB_GLANDS] ) {
            translate( pcbBox[IB_PCBTR]+gland[1] )
                cableGlandCubeShape(gland[0]);
        }
        if ( !is_undef(boxzip) )
            mirror_x()
                translate( pcbBox[IB_ZIPTR] )
                    zipConduitShape ( pcbBox[IB_ZIP], t=getBoxShellMainT(shell) ) ;
    }
    translate( [0,0,-getBoxShellExtSz(shell)/2] )
        translate( [ pcbBox[IB_PCBTR].x, pcbBox[IB_PCBTR].y, 0 ] )
            screwStandDrillHollow ( pcbBox[IB_STANDS] );
    for ( gland=pcbBox[IB_GLANDS] ) {
        translate( pcbBox[IB_PCBTR]+gland[1] )
            cableGlandCubeHollow(gland[0]);
    }
    if ( !is_undef(boxzip) )
        mirror_x()
            translate( pcbBox[IB_ZIPTR] )
                zipConduitHollow ( pcbBox[IB_ZIP] ) ;
}
module pcbBoxTopBevel ( pcbBox ) {
    boxShellTopBevel ( pcbBox[IB_BOX] ) ;
}
module pcbBoxBottomShape ( pcbBox ) {
    shell  = pcbBox[IB_BOX];
    boxzip = pcbBox[IB_ZIP];
    boxShellBottomShape ( shell ) ;
    translate( [0,0,-getBoxShellExtSz(shell)/2] )
        translate( [ pcbBox[IB_PCBTR].x, pcbBox[IB_PCBTR].y, 0 ] )
            screwStandHeadShape ( pcbBox[IB_STANDS] );
    intersection() {
        boxShellBottomShape ( shell ) ;
        for ( gland=pcbBox[IB_GLANDS] ) {
            translate( pcbBox[IB_PCBTR]+gland[1] )
                cableGlandCubeShape(gland[0]);
        }
    }
    if ( !is_undef(boxzip) )
        intersection() {
            boxShellBottomShape ( shell ) ;
            mirror_x()
                translate( pcbBox[IB_ZIPTR] )
                    zipConduitShape ( pcbBox[IB_ZIP], t=getBoxShellMainT(shell) ) ;
        }
}
module pcbBoxBottomHollow ( pcbBox ) {
    shell  = pcbBox[IB_BOX];
    boxzip = pcbBox[IB_ZIP];
    difference() {
        boxShellBottomHollow ( shell ) ;
        translate( [0,0,-getBoxShellExtSz(shell)/2] )
            translate( [ pcbBox[IB_PCBTR].x, pcbBox[IB_PCBTR].y, 0 ] )
                screwStandHeadShape ( pcbBox[IB_STANDS] );
        for ( gland=pcbBox[IB_GLANDS] ) {
            translate( pcbBox[IB_PCBTR]+gland[1] )
                cableGlandCubeShape(gland[0]);
        }
        if ( !is_undef(boxzip) )
            mirror_x()
                translate( pcbBox[IB_ZIPTR] )
                    zipConduitShape ( pcbBox[IB_ZIP], t=getBoxShellMainT(shell) ) ;
    }
    translate( [0,0,-getBoxShellExtSz(shell)/2] )
        translate( [ pcbBox[IB_PCBTR].x, pcbBox[IB_PCBTR].y, 0 ] )
            screwStandHeadHollow ( pcbBox[IB_STANDS] );
    for ( gland=pcbBox[IB_GLANDS] ) {
        translate( pcbBox[IB_PCBTR]+gland[1] )
            cableGlandCubeHollow(gland[0]);
    }
    if ( !is_undef(boxzip) )
        mirror_x()
            translate( pcbBox[IB_ZIPTR] )
                zipConduitHollow ( pcbBox[IB_ZIP] ) ;
}
module pcbBoxBottomBevel ( pcbBox ) {
    boxShellBottomBevel ( pcbBox[IB_BOX] ) ;
}

// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 50;
SEPARATION = 0;
CABLE_D    = 3;

module show_parts( part=0, cut=undef, cut_rotation=undef ) {
    screw = M2_5(tl=10, ahd=5) ;
    draft = newBoxShell (bsz=8);
    cables = [
         newCable ( CABLE_D/2, CABLE_D, c=[0,-4,-2],  v=[+1,0,0] )
        ,newCable ( CABLE_D/2, CABLE_D, c=[0,-4,1],  v=[-1,0,0] )
//        ,newCable ( CABLE_D/2, CABLE_D, c=[0,10,-3],  v=[0,+1,0] )
//        ,newCable ( CABLE_D/2, CABLE_D, c=[0,15,4],  v=[0,-1,0] )
//        ,newCable ( CABLE_D/2, CABLE_D, c=[0,5,-5], v=[0,0,+1] )
//        ,newCable ( CABLE_D/2, CABLE_D, c=[0,0,0],  v=[0,0,-1] )
    ];
    pcb   = newPcb(44, 22, holes=[
                    [-15, +5.0, screw ],
                    [+15, -5.0, screw ]
                ]);
    zipbase = newZipTie2_5();
    boxzip = makeZipU(zipbase,10,5);
    box = newPcbBox (
        pcb,
        draft,
        cables=cables,
        cablezip=zipbase,
        boxzip=boxzip,
        margin=0.4,
        incrustation=3 );

    if ( part==0 ) {
        intersection () {
            union() {
                translate( [0,0,+SEPARATION] )
                    pcbBoxTop( box );
                translate( [0,0,-SEPARATION] )
                    pcbBoxBottom( box );
                %
                translate ( getPcbBoxPcbTranslation(box) )
                    pcbShape ( getPcbBoxPcb(box) );
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    if ( part==1 ) {
        pcbBoxBottom( box );
    }
    if ( part==2 ) {
        rotate( [180,0,0] ) {
            pcbBoxTop( box );
        }
    }
}

// 0: all
// 1: bottom
// 2: top
show_parts ( 0, 0, -15, $fn=PRECISION );

