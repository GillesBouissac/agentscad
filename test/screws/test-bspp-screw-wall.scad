/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSPP (British Standard Pipe) screw modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/extensions.scad>
use <agentscad/lib-screw.scad>
use <agentscad/bspp-screw.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

SCREWS_HDP = [ for ( idx=[0:bsppGetDataLength()-1] ) screwGetHeadDP ( bsppData( idx ) ) ];
ALL_SCREW  = [for ( idx=[0:bsppGetDataLength()-1] ) bsppData( idx ) ];
SCREW_DISTANCE=7;

WALL1_H=4;
WALL2_H=160;
WALL_W=100+columnSum( SCREWS_HDP, end=bsppGetDataLength()-1 )+(bsppGetDataLength()-1)*SCREW_DISTANCE;
WALL_P=100;

module showcaseScrewPassage ( t, tlp ) {
    translate( [ t[0]*SCREW_DISTANCE + columnSum( SCREWS_HDP, end=t[0] )-WALL_W/2,0,0] ) {
        bsppBoltPassage ( bsppClone(t, tlp=tlp) );
    }
}
module showcaseScrew ( t ) {
    translate( [ t[0]*SCREW_DISTANCE + columnSum( SCREWS_HDP, end=t[0] )-WALL_W/2,0,0] ) {
        color( "silver", 0.7 ) {
            difference() {
                bsppBoltHexagonal ( t );
                cylinder(r=bsppGetPipeD(t)/2, h=1000, center=true);
            }
        }
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
            showcaseScrewPassage( screw, 2+screwGetThreadL(screw)*0.3 );
        }
    }
    for ( screw=ALL_SCREW ) {
        showcaseScrew( screw );
    }
}

dumpScrewsData(ALL_SCREW);
showcaseBigWall ($fn=50);
