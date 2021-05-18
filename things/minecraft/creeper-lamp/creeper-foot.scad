/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - foot modules
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/bevel.scad>
use <agentscad/mx-screw.scad>
use <creeper-polygons.scad>
use <creeper-lib.scad>
include <creeper-const.scad>

SCREW_TO_GROUND = M3(tl=21, tlp=WALL_THICK+mfg());
SCREW_ROTATED_X = FOOT_L*3/4;
SCREW_ROTATED_Y = BODY_W/2 + 5.5;
SCREW_X = FOOT_L*1/2;
SCREW_Y = BODY_W/2 + FOOT_W*1/2;

module bevelFoot() {
    translate( [0,0,FOOT_H/2] )
        bevelCube(FOOT_L, width=FOOT_W, height=FOOT_H, $bevel=BEVEL);
}

module cutFootScrews() {
    translate( [+SCREW_ROTATED_X, +SCREW_ROTATED_Y, -WALL_THICK] )
        mxBoltPassage( SCREW_TO_GROUND );
    translate( [-SCREW_ROTATED_X, -SCREW_ROTATED_Y, -WALL_THICK] )
        mxBoltPassage( SCREW_TO_GROUND );
    translate( [+SCREW_X, -SCREW_Y, -WALL_THICK] )
        mxBoltPassage( SCREW_TO_GROUND );
    translate( [-SCREW_X, +SCREW_Y, -WALL_THICK] )
        mxBoltPassage( SCREW_TO_GROUND );
}

module cutFoot() {
    translate( [0,0,-500] )
        cube( 1000, center=true );
    cutFootScrews();
}

// Front right foot placement
module transformFootFR() {
    translate( [-(BODY_L/4+WALL_THIN/2),-(BODY_W/2+FOOT_W/2+mfg())-2, 2] )
        rotate( [-20,0,0] )
        children();
}

// Front left foot placement
module transformFootFL() {
    translate( [+(BODY_L/4+WALL_THIN/2),-(BODY_W/2+FOOT_W/2+mfg()),0] )
        children();
}

// Back right foot placement
module transformFootBR() {
    translate( [-(BODY_L/4+WALL_THIN/2),+(BODY_W/2+FOOT_W/2+mfg()),0] )
        rotate( [0,0,180] )
        children();
}

// Back left foot placement - cable passage
module transformFootBL() {
    translate( [+(BODY_L/4+WALL_THIN/2),+(BODY_W/2+FOOT_W/2+mfg())+1, 1] )
        rotate( [20,0,0] )
        rotate( [0,0,180] )
        children();
}

module renderFootShell () {
    render()
    difference() {
        cube([FOOT_L,FOOT_W,FOOT_H], center=true);
    }
}

module footBlack() {
    extrude = FOOT_W/2-mfg();
    color( CBLACK )
    difference() {
        union() {
            transformFootFR()
                difference() {
                    rotate( [90,0,0] )
                    extrudePolygons(getFootFRFrontBlackRings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                bevelFoot();
            }
            transformFootFL()
                difference() {
                    rotate( [90,0,0] )
                    extrudePolygons(getFootFLFrontBlackRings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                bevelFoot();
            }
            transformFootBR()
                difference() {
                    rotate( [90,0,0] )
                    extrudePolygons(getFootBRFrontBlackRings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                bevelFoot();
            }
            transformFootBL()
                difference() {
                    rotate( [90,0,0] )
                    extrudePolygons(getFootBLFrontBlackRings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                bevelFoot();
            }
        }
        cutFoot();
    }
}
module footGreen1() {
    extrude = FOOT_W/2-mfg();
    color( CGREEN1 )
    difference() {
        union() {
            transformFootFR()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootFRFrontGreen1Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRRightGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRLeftGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                }
                bevelFoot();
            }
            transformFootFL()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootFLFrontGreen1Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLRightGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLLeftGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                }
                bevelFoot();
            }
            transformFootBR()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootBRFrontGreen1Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRRightGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRLeftGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                }
                bevelFoot();
            }
            transformFootBL()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootBLFrontGreen1Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLRightGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLLeftGreen1Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                }
                bevelFoot();
            }
        }
        cutFoot();
    }
}
module footGreen2() {
    extrude = FOOT_W/2-mfg();
    color( CGREEN2 )
    difference() {
        union() {
            transformFootFR()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootFRFrontGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRBackGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRRightGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRLeftGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootFRTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootFRTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
            transformFootFL()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootFLFrontGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLBackGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLRightGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLLeftGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootFLTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootFLTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
            transformFootBR()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootBRFrontGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRBackGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRRightGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRLeftGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootBRTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootBRTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
            transformFootBL()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootBLFrontGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLBackGreen2Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLRightGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLLeftGreen2Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootBLTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootBLTopGreen2Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
        }
        cutFoot();
    }
}
module footGreen3() {
    extrude = FOOT_W/2-mfg();
    color( CGREEN3 )
    difference() {
        union() {
            transformFootFR()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootFRFrontGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRBackGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRRightGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFRLeftGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootFRTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootFRTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
            transformFootFL()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootFLFrontGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLBackGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLRightGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootFLLeftGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootFLTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootFLTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
            transformFootBR()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootBRFrontGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRBackGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRRightGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBRLeftGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootBRTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootBRTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
            transformFootBL()
                difference() {
                union() {
                    rotate( [90,0,0] )
                        extrudePolygons(getFootBLFrontGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,180] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLBackGreen3Rings(), FOOT_W/2, extrude, [undef,FOOT_H/2,0], [0,undef,FOOT_W/2-FOOT_L/2]);
                    rotate( [0,0,+90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLRightGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    rotate( [0,0,-90] )
                        rotate( [90,0,0] )
                        extrudePolygons(getFootBLLeftGreen3Rings(), FOOT_L/2, extrude, [0,FOOT_H/2,FOOT_L/2-FOOT_W/2]);
                    extrudePolygons(getFootBLTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                    translate( [0,0,FOOT_H] )
                        rotate( [0,180,0] )
                        extrudePolygons(getFootBLTopGreen3Rings(), FOOT_H, extrude, [0,0,FOOT_H-FOOT_W/2], [0,0,FOOT_H-FOOT_L/2]);
                }
                bevelFoot();
            }
        }
        cutFoot();
    }
}


