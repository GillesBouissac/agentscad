/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSF screw modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/bsf-screw.scad>

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
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltPassage (screw);
        }
    }

    translate ( [+60,0,0] ) {
        // 3: Allen bolt
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltPassage (screw);
        }
        %bsfBoltAllen (screw);
    }

    translate ( [40,0,0] ) {
        // 4: Hexagonal bolt
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltPassage (screw);
        }
        %bsfBoltHexagonal (screw);
    }

    translate ( [+20,0,0] ) {
        // 5: Tight passage allen
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltAllenPassage (screw);
        }
        %bsfBoltAllen (screw);
    }

    translate ( [-0,0,0] ) {
        // 6: Tight passage hexagonal
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltHexagonalPassage (screw);
        }
        %bsfBoltHexagonal (screw);
    }

    translate ( [-20,0,0] ) {
        // 7: Nut passage
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bsfNutPassage (screw);
        }
        %bsfBoltHexagonal (bsfClone(screw,12));
    }

    translate ( [-40,0,0] ) {
        // 8: Hexagonal nut
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bsfNutPassage (screw);
        }
        %bsfBoltHexagonal (bsfClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %bsfNutHexagonal (screw);
    }

    translate ( [-60,0,0] ) {
        // 9: Square nut
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bsfNutPassage (screw);
        }
        %bsfBoltHexagonal (bsfClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %bsfNutSquare (screw);
    }

    translate ( [-80,0,0] ) {
        // 10: Hexagonal nut passage
        screw = BSF3_16(10,3);
        difference() {
            showcaseWalls (3,10,15);
            bsfBoltHexagonalPassage (screw);
            translate( [0,0,screwGetThreadL(screw)] )
                bsfNutHexagonalPassage (screw);
        }
        %bsfBoltHexagonal (bsfClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)] )
            %bsfNutHexagonal (screw);
    }

    translate ( [-100,0,0] ) {
        // 11: Square nut passage
        screw = BSF3_16(10,3);
        difference() {
            translate ( [0,-screwGetSquareToolSize(screw)/2,0] )
                showcaseWalls (3,10,15);
            bsfBoltPassage (screw);
            translate( [0,0,screwGetThreadL(screw)-4] )
                bsfNutSquarePassage (screw);
        }
        %bsfBoltHexagonal (bsfClone(screw,12));
        translate( [0,0,screwGetThreadL(screw)-3.8] )
            %bsfNutSquare (screw);
    }
}
rotate( [0,180,0] )
    showCase( $fn=100 );
