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
use <../mx-screw.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

SCREW_DISTANCE=3;
WALL1_H=4;
WALL2_H=120;
WALL_W=170;
WALL_P=20;

function cumulate ( vect, end=-1, nexti=0, current=-1 ) =
let(
    endIdx   = end==-1 ? len(vect)-1 : end,
    curCumul = current==-1 ? 0 : current,
    res = nexti>endIdx ? curCumul : vect[nexti]+cumulate(vect,endIdx,nexti+1,curCumul)
)res;
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
module showcaseScrewPassage ( t, tlp ) {
    translate( [ t[0]*SCREW_DISTANCE + cumulate( SCREWS_HDP, t[0] )-80,0,0] ) {
        mxBoltPassage ( t, tlp=tlp, $fn=100 );
    }
}
module showcaseScrew ( t ) {
    translate( [ t[0]*SCREW_DISTANCE + cumulate( SCREWS_HDP, t[0] )-80,0,0] ) {
        color( "silver", 0.7 )
            mxBoltAllen   ( t, $fn=100 );
        color( "gold" )
            translate( [0,-t[8]/2-1.5,-t[9]/2] )
            rotate ( [90,0,0] )
            linear_extrude(1)
            text( t[1], halign="center", valign="center", size=2, $fn=100 );
    }
}

module showcaseWalls( wh1, wh2, ww=WALL_W, wp=WALL_P ) {
    translate ( [0,wp/2,0] )  {
        color( "LightSkyBlue" )
        translate ( [0,0,-(wh2+wh1)/2] )
            cube( [ww,wp,wh2], center=true );
        color( "DodgerBlue" )
        translate ( [0,0,0] )
            cube( [ww,wp,wh1], center=true );
    }
}

module showcaseBigWall() {
    HLP = WALL1_H+10;
    allScrews= [
        M1_6(hlp=HLP),M2(hlp=HLP),M2_5(hlp=HLP),M3(hlp=HLP),
        M4(hlp=HLP),M5(hlp=HLP),M6(hlp=HLP),M8(hlp=HLP),
        M10(hlp=HLP),M12(hlp=HLP)
    ];
    difference() {
        showcaseWalls (WALL1_H,WALL2_H,WALL_W);
        for ( screw=allScrews ) {
            showcaseScrewPassage( screw, 3 );
        }
    }
    for ( screw=allScrews ) {
        showcaseScrew( screw );
    }
}

module showcaseSmallWall() {
    screw = M3(10);
    translate ( [-60,0,40] ) {
        showcaseWalls (3,10,15);
    }
    translate ( [-40,0,40] ) {
        difference() {
            showcaseWalls (3,10,15);
            mxBoltPassage( screw, 3 );
        }
    }
    translate ( [-20,0,40] ) {
        difference() {
            showcaseWalls (3,10,15);
            mxBoltPassage( screw, 3 );
        }
        color( "silver", 0.7 )
        mxBoltAllen( screw );
    }
    translate ( [+0,0,40] ) {
        difference() {
            showcaseWalls (3,10,15);
            mxBoltAllenPassage( screw, 3 );
        }
        color( "silver", 0.7 )
        mxBoltAllen( screw );
    }
    translate ( [+20,0,40] ) {
        difference() {
            showcaseWalls (3,10,15);
            mxBoltPassage( screw, 3 );
        }
        color( "silver", 0.7 )
        mxBoltHexagonal( screw );
    }
    translate ( [+40,0,40] ) {
        difference() {
            showcaseWalls (3,10,15);
            mxBoltHexagonalPassage( screw, 3 );
        }
        color( "silver", 0.7 )
        mxBoltHexagonal( screw );
    }
}


// Modulo
function mod(a,m) = a - m*floor(a/m);
module showcaseAnimated() {

    allScrews= [
        M1_6(),M2(),M2_5(),M3(),
        M4(),M5(),M6(),M8(),
        M10(),M12()
    ];
    idx=floor($t*len(allScrews));
    screw = allScrews[idx];
    color( "blue" )
    translate( [-2*mxHeadDP(screw),0,140] )
        rotate( $vpr )
        linear_extrude(1)
        text( mxName(screw), halign="center", valign="center", size=5, $fn=100 );
    translate( [0,mxHeadDP(screw)/1.5,140] ) {
        translate( [3*mxHeadDP(screw),0,0] )
        #mxBoltPassage( screw, 3, $fn=100 );
        translate( [1.5*mxHeadDP(screw),0,0] )
        #mxBoltAllenPassage( screw, 3, $fn=100 );
        mxBoltAllen( screw, $fn=100 );
    }
    translate( [0,-mxHeadDP(screw)/1.5,140] ) {
        translate( [3*mxHeadDP(screw),0,0] )
        #mxBoltPassage( screw, 3, $fn=100 );
        translate( [1.5*mxHeadDP(screw),0,0] )
        #mxBoltHexagonalPassage( screw, 3, $fn=100 );
        mxBoltHexagonal( screw, $fn=100 );
    }
}

showcaseBigWall ($fn=100);
showcaseSmallWall ($fn=100);
showcaseAnimated ($fn=100);
