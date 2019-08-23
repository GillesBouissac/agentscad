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

SCREWS_HDP = [ for ( idx=[0:mxGetDataLength()-1] ) mxGetHeadDP ( mxData( idx ) ) ];
ALL_SCREW  = [for ( idx=[0:mxGetDataLength()-1] ) mxData( idx ) ];
SCREW_DISTANCE=3;

WALL1_H=4;
WALL2_H=136;
WALL_W=100+cumulate( SCREWS_HDP, mxGetDataLength()-1 )+(mxGetDataLength()-1)*SCREW_DISTANCE;
WALL_P=100;

function cumulate ( vect, end=-1, nexti=0, current=-1 ) =
let(
    endIdx   = end==-1 ? len(vect)-1 : end,
    curCumul = current==-1 ? 0 : current,
    res = nexti>endIdx ? curCumul : vect[nexti]+cumulate(vect,endIdx,nexti+1,curCumul)
)res;

module showcaseScrewPassage ( t, tlp ) {
    translate( [ t[0]*SCREW_DISTANCE + cumulate( SCREWS_HDP, t[0] )-WALL_W/2,0,0] ) {
        mxBoltPassage ( t, tlp=tlp, $fn=100 );
    }
}
module showcaseScrew ( t ) {
    translate( [ t[0]*SCREW_DISTANCE + cumulate( SCREWS_HDP, t[0] )-WALL_W/2,0,0] ) {
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
        translate ( [0,0,+(wh2+wh1)/2] )
            cube( [ww,wp,wh2], center=true );
        color( "DodgerBlue" )
        translate ( [0,0,0] )
            cube( [ww,wp,wh1], center=true );
    }
}

module showcaseBigWall() {
    HLP = WALL1_H+10;
    difference() {
        showcaseWalls (WALL1_H,WALL2_H,WALL_W);
        for ( screw=ALL_SCREW ) {
            showcaseScrewPassage( screw, 3 );
        }
    }
    for ( screw=ALL_SCREW ) {
        showcaseScrew( screw );
    }
}

showcaseBigWall ($fn=100);
