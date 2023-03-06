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
use <agentscad/lib-screw.scad>
use <agentscad/mx-screw.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

module showcaseWalls( wh1, wh2, ww=200, wp=20 ) {
    translate ( [0,wp/2,0] )  {
        color( "LightSkyBlue" )
        translate ( [0,0,+(wh2+wh1)/2] )
            cube( [ww,wp,wh2], center=true );
        color( "DodgerBlue" )
        translate ( [0,0,0] )
            cube( [ww,wp,wh1], center=true );
    }
}

module showCase() {
    translate ( [+100,0,0] ) {
        // 1: Some walls
        showcaseWalls (3,10,15);
    }

    translate ( [+80,0,0] ) {
        // 2: Bolt passage
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltPassage (screw);
        }
    }

    translate ( [+60,0,0] ) {
        // 3: Allen bolt
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltPassage (screw);
        }
        %mxBoltAllen (screw);
    }

    translate ( [40,0,0] ) {
        // 4: Hexagonal bolt
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltPassage (screw);
        }
        %mxBoltHexagonal (screw);
    }

    translate ( [+20,0,0] ) {
        // 5: Tight passage allen
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltAllenPassage (screw);
        }
        %mxBoltAllen (screw);
    }

    translate ( [-0,0,0] ) {
        // 6: Tight passage hexagonal
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltHexagonalPassage (screw);
        }
        %mxBoltHexagonal (screw);
    }

    translate ( [-20,0,0] ) {
        // 7: Nut passage
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                mxNutPassage (screw);
        }
        %mxBoltHexagonal (mxClone(screw,12));
    }

    translate ( [-40,0,0] ) {
        // 8: Hexagonal nut
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                mxNutPassage (screw);
        }
        %mxBoltHexagonal (mxClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %mxNutHexagonal (screw);
    }

    translate ( [-60,0,0] ) {
        // 9: Square nut
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                mxNutPassage (screw);
        }
        %mxBoltHexagonal (mxClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %mxNutSquare (screw);
    }

    translate ( [-80,0,0] ) {
        // 10: Hexagonal nut passage
        screw = M3(10,3);
        difference() {
            showcaseWalls (3,10,15);
            mxBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                mxNutHexagonalPassage (screw);
        }
        %mxBoltHexagonal (mxClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %mxNutHexagonal (screw);
    }

    translate ( [-100,0,0] ) {
        // 11: Square nut passage
        screw = M3(10,3);
        difference() {
            translate ( [0,-screwGetSquareToolSize(screw)/2,0] )
                showcaseWalls (3,10,15);
            mxBoltPassage (screw);
            translate( [0,0,screwGetThreadL(screw)-4] )
                mxNutSquarePassage (screw);
        }
        %mxBoltHexagonal (mxClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)-3.8] )
            %mxNutSquare (screw);
    }
}
rotate( [0,180,0] )
    showCase( $fn=100 );
