/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Wrenches
 * Author:      Gilles Bouissac
 * 
 */

use <scad-utils/shapes.scad>
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/extensions.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

//
// Tubular Angled Socket Wrench (TASW)
//
function newTasWrench( a, b=undef, d=undef, d1=undef,
    h=undef, l=undef, l1=undef, de1=undef, de2=undef ) =
let (
    found   = search(a,TASWDATA,num_returns_per_match=0, index_col_num=1),
    check   = assert ( len(found)>0, str("bad wrench ",a," requested to newTubularWrench") ),
    idx     = found[0],
    loc_b   = forceValueInRange(b,minv=0,defv=TASWDATA[idx][TASWB]),
    loc_d   = forceValueInRange(d,minv=0,defv=TASWDATA[idx][TASWD]),
    loc_d1  = forceValueInRange(d1,minv=0,defv=TASWDATA[idx][TASWD1]),
    loc_h   = forceValueInRange(h,minv=0,defv=TASWDATA[idx][TASWH]),
    loc_l   = forceValueInRange(l,minv=0,defv=TASWDATA[idx][TASWL]),
    loc_l1  = forceValueInRange(l1,minv=0,defv=TASWDATA[idx][TASWL1]),
    loc_de1 = forceValueInRange(de1,minv=0,defv=TASWDATA[idx][TASWDE1]),
    loc_de2 = forceValueInRange(de2,minv=0,defv=TASWDATA[idx][TASWDE2]),
    b2      = loc_de2/2-loc_de1/2,
    elb_r    = loc_h-loc_l1/2+loc_d/2,
    strait_l = loc_l1+b2,
    angle_l  = 3*loc_b/2+b2,
    axis_l   = loc_l-strait_l-angle_l,
    elb_cz   = loc_l-angle_l+loc_b-elb_r,
    elb_cx   = elb_r

) [ tasWrenchClass(), idx,
    TASWDATA[idx][TASWN], a, loc_b, loc_d, loc_d1, loc_h, loc_l, loc_l1,
    loc_de1, loc_de2, a/(2*cos(30)), (loc_b-a)/2, elb_r, strait_l, angle_l, axis_l,
    elb_cz, elb_cx
];
TASW_N   = 2;
TASW_A   = 3;
TASW_B   = 4;
TASW_D   = 5;
TASW_D1  = 6;
TASW_H   = 7;
TASW_L   = 8;
TASW_L1  = 9;
TASW_DE1 = 10;
TASW_DE2 = 11;
TASW_AR   = 12; // Radius of circle enclosing A
TASW_T    = 13; // Thickness
TASW_ELR  = 14; // ELbow Radius
TASW_LSTR = 15; // Length of STRaight part including bevel
TASW_LANG = 16; // Length of ANGled part including bevel
TASW_LAXI = 17; // Length of AXIs part without bevel
TASW_ELCZ = 18; // ELbow Center Z position
TASW_ELCX = 19; // ELbow Center X position

function getTasWrenchN(w)    = w[TASW_N];
function getTasWrenchA(w)    = w[TASW_A];
function getTasWrenchB(w)    = w[TASW_B];
function getTasWrenchD(w)    = w[TASW_D];
function getTasWrenchD1(w)   = w[TASW_D1];
function getTasWrenchH(w)    = w[TASW_H];
function getTasWrenchL(w)    = w[TASW_L];
function getTasWrenchL1(w)   = w[TASW_L1];
function getTasWrenchDE1(w)  = w[TASW_DE1];
function getTasWrenchDE2(w)  = w[TASW_DE2];
function getTasWrenchList()  = [ for ( w=TASWDATA ) w[TASWA] ];
function getTasWrenchElbowR(w)  = w[TASW_ELR];
function getTasWrenchStraitL(w) = w[TASW_LSTR];
function getTasWrenchAngleL(w)  = w[TASW_LANG];
function getTasWrenchAxisL(w)   = w[TASW_LAXI];
function getTasWrenchElbowCZ(w) = w[TASW_ELCZ];
function getTasWrenchElbowCX(w) = w[TASW_ELCX];

// ----------------------------------------
//             Implementation
// ----------------------------------------
function tasWrenchClass() = "tubularAngleSocketWrench";

//
// tubular angled wrench
// 
function __angleTrf (i,dx,dz) =
    translation([dx,0,dz])*
    rotation([0,i*(90-5),0])*
    translation([-dx,0,0])
;
function __hollow ( wrench, passage, b1, b ) = let(
    ct1 = circle ( wrench[TASW_AR], $fn=6 ),
    ct2 = circle ( wrench[TASW_AR]-b1, $fn=6 ),
    ct3 = circle ( wrench[TASW_AR]-b1 ),
    ct4 = circle ( (wrench[TASW_AR]-b1)/2 )
) [
    transform ( translation([0,0,-(wrench[TASW_L1]/2)-mfg()]), ct1 ),
    transform ( translation([0,0,-b1]), ct1 ),
    transform ( translation([0,0,0]),   ct3 ),
    transform ( translation([0,0,passage]), ct3 ),
    transform ( translation([0,0,passage+b]), ct4 ),
];

module tasWrenchHollow( wrench ) {
    class = assertClass( wrench, tasWrenchClass() );

    c1r   = wrench[TASW_B]/2;
    c2r   = wrench[TASW_DE2]/2;
    c3r   = wrench[TASW_DE1]/2;
    b1    = c1r-c2r;
    b2    = c2r-c3r;
    b     = b1+b2;
    elb_cz   = wrench[TASW_ELCZ];
    elb_cx   = wrench[TASW_ELCX];

    translate( [-elb_cx,0,-elb_cz] ) {
        skin([ for (t=__hollow(wrench,wrench[TASW_L1]/2,b1,b))
            transform ( translation([0,0,wrench[TASW_L1]/2]), t )
        ]);
        skin([ for (t=__hollow(wrench,wrench[TASW_L1],b1,b))
            transform ( __angleTrf(1,elb_cx,elb_cz)*
                translation([0,0,b1])*
                scaling([1,-1,-1]), t )
        ]);
    }
}

module tasWrenchShape ( wrench ) {
    class = assertClass( wrench, tasWrenchClass() );
    c1r   = wrench[TASW_B]/2;
    c2r   = wrench[TASW_DE2]/2;
    c3r   = wrench[TASW_DE1]/2;
    b1    = c1r-c2r;
    b2    = c2r-c3r;
    b     = b1+b2;
    elb_cz   = wrench[TASW_ELCZ];
    elb_cx   = wrench[TASW_ELCX];
    strait_l = wrench[TASW_LSTR];
    angle_l  = wrench[TASW_LANG];
    axis_l   = wrench[TASW_LAXI];

    c1  = circle ( c1r );
    c2  = circle ( c2r );
    c3  = circle ( c3r );

    translate( [-elb_cx,0,-elb_cz] )
        skin([
            c1,
            transform ( translation([0,0,wrench[TASW_L1]/2]),     c1 ),
            transform ( translation([0,0,wrench[TASW_L1]/2+b1]),  c2 ),
            transform ( translation([0,0,wrench[TASW_L1]+b1]),    c2 ),
            transform ( translation([0,0,wrench[TASW_L1]+b]),     c3 ),
            transform ( translation([0,0,strait_l+axis_l-b2]), c3 ),
            transform ( translation([0,0,strait_l+axis_l]),    c2 ),
            for ( i=[0:2*getStep():1] )
                transform (__angleTrf(i,elb_cx,elb_cz),c2 ),
            transform ( __angleTrf(1,elb_cx,elb_cz)*
                translation([0,0,b1]), c1 ),
            transform ( __angleTrf(1,elb_cx,elb_cz)*
                translation([0,0,wrench[TASW_L1]/2+b1]), c1 ),
        ]);
}
module tasWrench ( wrench ) {
    difference() {
        tasWrenchShape( wrench );
        tasWrenchHollow( wrench );
    }
}

//
// Tubular Angled Socket Wrench data
//
// Sources:
//   https://catalogue.facom.com/ch-fr/categorie/cles-a-ouverture-fixe-et-variable/cles-a-pipe/
//       serie-standard/produit/75-cles-a-pipe-debouchees-forgees-6-pans-x-6-pans-metriques
//   https://catalogue.facom.com/thumb/dessintech/567x567/75.6_DTCL01.png
//
TASWDATA = [
//| Name   |   A  |   B  |   d  |  d1  |   H  |   L  |  L1  |  de1 |  de2 |
  [  "M6"  ,    6 , 10.0 ,  4.5 ,  4.5 ,   15 ,  102 ,  21  ,    7 ,    9 ],
  [  "M7"  ,    7 , 11.0 ,  4.5 ,  4.5 ,   17 ,  106 ,  22  ,    7 ,   10 ],
  [  "M8"  ,    8 , 12.5 ,  7.0 ,  6.0 ,   19 ,  114 ,  25  ,    9 ,   11 ],
  [  "M9"  ,    9 , 13.5 ,  7.0 ,  6.0 ,   20 ,  122 ,  26  ,    9 ,   12 ],
  [ "M10"  ,   10 , 15.0 ,  8.0 ,  7.0 ,   24 ,  129 ,  28  ,   10 ,   13 ],
  [ "M11"  ,   11 , 16.5 ,  8.0 ,  7.0 ,   25 ,  136 ,  30  ,   11 ,   14 ],
  [ "M12"  ,   12 , 18.0 ,  9.0 ,  8.0 ,   28 ,  144 ,  36  ,   12 ,   16 ],
  [ "M13"  ,   13 , 19.5 ,  9.0 ,  8.0 ,   30 ,  152 ,  38  ,   12 ,   17 ],
  [ "M14"  ,   14 , 21.0 , 10.5 ,  9.0 ,   32 ,  160 ,  40  ,   12 ,   18 ],
  [ "M15"  ,   15 , 22.5 , 10.5 , 10.0 ,   34 ,  169 ,  42  ,   12.5 ,   18 ],
  [ "M16"  ,   16 , 24.0 , 13.0 , 12.0 ,   37 ,  178 ,  46  ,   14.5 ,   21 ],
  [ "M17"  ,   17 , 25.5 , 13.0 , 12.0 ,   39 ,  187 ,  48  ,   14.5 ,   21 ],
  [ "M18"  ,   18 , 26.5 , 13.0 , 12.0 ,   40 ,  195 ,  50  ,   15 ,   22 ],
  [ "M19"  ,   19 , 28.5 , 15.0 , 12.0 ,   41 ,  204 ,  51  ,   16 ,   22 ],
  [ "M20"  ,   20 , 29.5 , 15.0 , 13.0 ,   43 ,  212 ,  53  ,   16 ,   23 ],
  [ "M21"  ,   21 , 30.5 , 15.0 , 14.0 ,   46 ,  221 ,  55  ,   16 ,   23 ],
  [ "M22"  ,   22 , 30.0 , 15.0 , 14.0 ,   48 ,  230 ,  57  ,   16 ,   24 ],
  [ "M23"  ,   23 , 33.5 , 18.0 , 15.0 ,   51 ,  240 ,  64  ,   20 ,   26 ],
  [ "M24"  ,   24 , 34.5 , 18.0 , 16.0 ,   54 ,  250 ,  67  ,   20 ,   27 ],
  [ "M25"  ,   25 , 36.0 , 20.0 , 17.0 ,   56 ,  260 ,  69  ,   22 ,   29 ],
  [ "M26"  ,   26 , 37.0 , 20.0 , 17.0 ,   57 ,  270 ,  70  ,   22 ,   30 ],
  [ "M27"  ,   27 , 38.0 , 22.0 , 19.0 ,   58 ,  280 ,  73  ,   24 ,   31 ],
  [ "M28"  ,   28 , 39.5 , 22.0 , 19.0 ,   60 ,  290 ,  75  ,   24 ,   32 ],
  [ "M29"  ,   29 , 41.0 , 22.0 , 19.0 ,   62 ,  300 ,  76  ,   24 ,   33 ],
  [ "M30"  ,   30 , 42.0 , 24.0 , 21.0 ,   64 ,  310 ,  83  ,   27 ,   34 ],
  [ "M31"  ,   31 , 43.5 , 24.0 , 22.6 ,   70 ,  320 ,  86  ,   27 ,   35 ],
  [ "M32"  ,   32 , 44.5 , 24.0 , 22.6 ,   74 ,  330 ,  88  ,   27 ,   36 ],
  [ "M33"  ,   33 , 46.0 , 27.0 , 24.0 ,   79 ,  340 ,  92  ,   30 ,   38 ],
  [ "M34"  ,   34 , 47.0 , 27.0 , 24.0 ,   80 ,  350 ,  95  ,   30 ,   39 ],
  [ "M35"  ,   35 , 48.5 , 27.0 , 24.0 ,   81 ,  360 ,  96  ,   30 ,   39 ],
  [ "M36"  ,   36 , 49.5 , 27.0 , 24.0 ,   82 ,  370 ,  97  ,   30 ,   40 ],
  [ "M38"  ,   38 , 52.0 , 28.0 , 25.0 ,   85 ,  390 ,  99  ,   32 ,   42 ]
];
TASWN   = 0;
TASWA   = 1;
TASWB   = 2;
TASWD   = 3;
TASWD1  = 4;
TASWH   = 5;
TASWL   = 6;
TASWL1  = 7;
TASWDE1 = 8;
TASWDE2 = 9;

// ----------------------------------------
//                Showcase
// ----------------------------------------

module showWrenchParts (part=0, sub_part=0, cut=undef, cut_rotation=undef) {

    if ( part==0 ) {
        intersection () {
            union() {
                translate( [0,-15,0] )
                tasWrench(newTasWrench(11));
                translate( [0,+15,0] )
                tasWrench(newTasWrench(17));
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }
    else if ( part==1 ) {
    }
}

// part=0: mutiple parts at the same time
//   sub_part=0: all
//   cut/cut_rotation: cut position/rotation (ex:0) to see inside (undef for no cut)
// part=1: printable: star core
// $fn:    Rendering precision
SMOOTH  = 100;
FAST    = 20;
LOWPOLY = 6;
showWrenchParts ( part=0, sub_part=0, cut=undef, cut_rotation=0, $fn=SMOOTH );
