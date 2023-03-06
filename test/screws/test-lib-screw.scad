/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: lib-screw testing
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/unc-screw.scad>

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------

BLUE_1="#01579b";
BLUE_2="#29b6f6";
BLUE_3="#b3e5fc";

GREEN_1="#1b5e20";
GREEN_2="#4caf50";
GREEN_3="#a5d6a7";

ORANGE_1="#ffa000";
ORANGE_2="#ffc107";
ORANGE_3="#ffe082";

RED_1="#b71c1c";
RED_2="#e74c3c";
RED_3="#f5b7b1";

BOLT_X = 0;
NUT_X = 30;

SQUARE_X = 0;
HEX_X = 10;
ALLEN_X = 20;

GENERIC_PASSAGE_Y  = 70;
SHAPE_PASSAGE_Y = 60;
BEVEL2_Y  = 50;
BEVEL1_Y  = 40;
SHAPE_Y  = 30;
THREADED_BEVEL2_Y  = 20;
THREADED_BEVEL1_Y  = 10;
THREADED_Y  = 0;

GENERIC_PASSAGE_COLOR  = BLUE_1;
SHAPE_PASSAGE_COLOR = BLUE_2;
SHAPE_COLOR  = ORANGE_1;
BEVEL1_COLOR  = ORANGE_2;
BEVEL2_COLOR  = ORANGE_3;
THREADED_COLOR  = GREEN_1;
THREADED_BEVEL1_COLOR  = GREEN_2;
THREADED_BEVEL2_COLOR  = GREEN_3;

module showBoltHex(screw) {
    x = BOLT_X+HEX_X;
    color( GENERIC_PASSAGE_COLOR )
        translate ( [x,GENERIC_PASSAGE_Y,0] )
        libBoltPassage (screw);
    color( SHAPE_PASSAGE_COLOR )
        translate ( [x,SHAPE_PASSAGE_Y,0] )
        libBoltHexagonalPassage (screw);

    color( SHAPE_COLOR )
        translate ( [x,SHAPE_Y,0] )
        libBoltHexagonal (screw);
    color( BEVEL1_COLOR )
        translate ( [x,BEVEL1_Y,0] )
        libBoltHexagonal (screw,false);
    color( BEVEL2_COLOR )
        translate ( [x,BEVEL2_Y,0] )
        libBoltHexagonal (screw,false,false);

    color( THREADED_COLOR )
        translate ( [x,THREADED_Y,0] )
        libBoltHexagonalThreaded (screw);
    color( THREADED_BEVEL1_COLOR )
        translate ( [x,THREADED_BEVEL1_Y,0] )
        libBoltHexagonalThreaded (screw,false);
    color( THREADED_BEVEL2_COLOR )
        translate ( [x,THREADED_BEVEL2_Y,0] )
        libBoltHexagonalThreaded (screw,false,false);
}
module showBoltAllen(screw) {
    x = BOLT_X+ALLEN_X;
    color( GENERIC_PASSAGE_COLOR )
        translate ( [x,GENERIC_PASSAGE_Y,0] )
        libBoltPassage (screw);
    color( SHAPE_PASSAGE_COLOR )
        translate ( [x,SHAPE_PASSAGE_Y,0] )
        libBoltAllenPassage (screw);

    color( SHAPE_COLOR )
        translate ( [x,SHAPE_Y,0] )
        libBoltAllen (screw);
    color( BEVEL1_COLOR )
        translate ( [x,BEVEL1_Y,0] )
        libBoltAllen (screw, false);
    color( BEVEL2_COLOR )
        translate ( [x,BEVEL2_Y,0] )
        libBoltAllen (screw,true,true);

    color( THREADED_COLOR )
        translate ( [x,THREADED_Y,0] )
        libBoltAllenThreaded (screw);
    color( THREADED_BEVEL1_COLOR )
        translate ( [x,THREADED_BEVEL1_Y,0] )
        libBoltAllenThreaded (screw, false);
    color( THREADED_BEVEL2_COLOR )
        translate ( [x,THREADED_BEVEL2_Y,0] )
        libBoltAllenThreaded (screw,true,true);

}

module showNutSquare(screw) {
    x = NUT_X+SQUARE_X;
    color( GENERIC_PASSAGE_COLOR )
        translate ( [x,GENERIC_PASSAGE_Y,0] )
        libNutPassage (screw);
    color( SHAPE_PASSAGE_COLOR )
        translate ( [x,SHAPE_PASSAGE_Y,0] )
        libNutSquarePassage (screw);
    color( SHAPE_COLOR )
        translate ( [x,SHAPE_Y,0] )
        libNutSquare (screw);
    color( BEVEL1_COLOR )
        translate ( [x,BEVEL1_Y,0] )
        libNutSquare (screw, false);
    color( BEVEL2_COLOR )
        translate ( [x,BEVEL2_Y,0] )
        libNutSquare (screw, false, false);

    color( THREADED_COLOR )
        translate ( [x,THREADED_Y,0] )
        libNutSquareThreaded (screw);
    color( THREADED_BEVEL1_COLOR )
        translate ( [x,THREADED_BEVEL1_Y,0] )
        libNutSquareThreaded (screw, false);
    color( THREADED_BEVEL2_COLOR )
        translate ( [x,THREADED_BEVEL2_Y,0] )
        libNutSquareThreaded (screw, false, false);


}
module showNutHex(screw) {
    x = NUT_X+HEX_X;
    color( GENERIC_PASSAGE_COLOR )
        translate ( [x,GENERIC_PASSAGE_Y,0] )
        libNutPassage (screw);
    color( SHAPE_PASSAGE_COLOR )
        translate ( [x,SHAPE_PASSAGE_Y,0] )
        libNutHexagonalPassage (screw);
    color( SHAPE_COLOR )
        translate ( [x,SHAPE_Y,0] )
        libNutHexagonal (screw);
    color( BEVEL1_COLOR )
        translate ( [x,BEVEL1_Y,0] )
        libNutHexagonal (screw, false);
    color( BEVEL2_COLOR )
        translate ( [x,BEVEL2_Y,0] )
        libNutHexagonal (screw, false, false);
    color( THREADED_COLOR )
        translate ( [x,THREADED_Y,0] )
        libNutHexagonalThreaded (screw);
    color( THREADED_BEVEL1_COLOR )
        translate ( [x,THREADED_BEVEL1_Y,0] )
        libNutHexagonalThreaded (screw, false);
    color( THREADED_BEVEL2_COLOR )
        translate ( [x,THREADED_BEVEL2_Y,0] )
        libNutHexagonalThreaded (screw, false, false);
}

module showCase() {
    screw = UNC_N5(10,3);

    showBoltHex(screw);
    showBoltAllen(screw);

    showNutSquare(screw);
    showNutHex(screw);
}

showCase( $fn=20 );
