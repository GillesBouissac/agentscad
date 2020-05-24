/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSW screw modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/bsw-screw.scad>

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
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltPassage (screw);
        }
    }

    translate ( [+60,0,0] ) {
        // 3: Allen bolt
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltPassage (screw);
        }
        %bswBoltAllen (screw);
    }

    translate ( [40,0,0] ) {
        // 4: Hexagonal bolt
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltPassage (screw);
        }
        %bswBoltHexagonal (screw);
    }

    translate ( [+20,0,0] ) {
        // 5: Tight passage allen
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltAllenPassage (screw);
        }
        %bswBoltAllen (screw);
    }

    translate ( [-0,0,0] ) {
        // 6: Tight passage hexagonal
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltHexagonalPassage (screw);
        }
        %bswBoltHexagonal (screw);
    }

    translate ( [-20,0,0] ) {
        // 7: Nut passage
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bswNutPassage (screw);
        }
        %bswBoltHexagonal (bswClone(screw,12));
    }

    translate ( [-40,0,0] ) {
        // 8: Hexagonal nut
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bswNutPassage (screw);
        }
        %bswBoltHexagonal (bswClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %bswNutHexagonal (screw);
    }

    translate ( [-60,0,0] ) {
        // 9: Square nut
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bswNutPassage (screw);
        }
        %bswBoltHexagonal (bswClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %bswNutSquare (screw);
    }

    translate ( [-80,0,0] ) {
        // 10: Hexagonal nut passage
        screw = BSW5_32(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bswBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bswNutHexagonalPassage (screw);
        }
        %bswBoltHexagonal (bswClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %bswNutHexagonal (screw);
    }

    translate ( [-100,0,0] ) {
        // 11: Square nut passage
        screw = BSW5_32(10,3);
        difference() {
            translate ( [0,-screwGetSquareToolSize(screw)/2,0] )
                showcaseWalls (3,10,15);
            bswBoltPassage (screw);
            translate( [0,0,screwGetThreadL(screw)-4] )
                bswNutSquarePassage (screw);
        }
        %bswBoltHexagonal (bswClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)-3.8] )
            %bswNutSquare (screw);
    }
}
rotate( [0,180,0] )
    showCase( $fn=100 );
