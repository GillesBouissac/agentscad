/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - head modules
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/extensions.scad>
use <agentscad/bevel.scad>
use <creeper-polygons.scad>
use <creeper-lib.scad>
include <creeper-const.scad>

HEAD_HOLLOW_W = HEAD_W-2*SHADER_T;
HEAD_HOLLOW_B = 2.6;

JOINT_W = 1.6;
JOINT_H = JOINT_W*4/8;
JOINT_L = HEAD_W-10;
JOINT_PROFILE = [
    [+JOINT_L/2, +JOINT_W/2],
    [-JOINT_L/2, +JOINT_W/2],
    [-JOINT_L/2, -JOINT_W/2],
    [+JOINT_L/2, -JOINT_W/2],
];
JOINT_OFFSET = HEAD_W/2-1.4;
GLUE_GAP = 0.1;

module bevelHeadHollow() {
    bevelCube(HEAD_HOLLOW_W, nobot=true, $bevel=HEAD_HOLLOW_B);
}

module headShellHollow () {
    difference() {
        translate([0,0,-SHADER_T])
            cube([HEAD_HOLLOW_W,HEAD_HOLLOW_W,HEAD_W], center=true);
        bevelHeadHollow();
    }
}

module bevelHead() {
    bevelCube(HEAD_W, HEAD_W, $bevel=BEVEL);
}

module headHollow () {
    headShellHollow();
    bevelHead();
}

/**
 * face: FACE_ALL | FACE_FRONT | FACE_RIGHT | FACE_BACK | FACE_LEFT | FACE_TOP
 */

module headGuideShape ( male=true ) {
    if ( male ) {
        rotate( [male ? 45 : -135,0,0] )
            extrudePolygons( [ JOINT_PROFILE ], 0.03, JOINT_H, [undef,0,-JOINT_W], [0,undef,-JOINT_L/2] );
    }
    else {
        rotate( [male ? 45 : -135,0,0] )
            extrudePolygons( [ wrinkle(JOINT_PROFILE, -GLUE_GAP, true) ], 0.03, JOINT_H+GLUE_GAP, [undef,0,-JOINT_W-GLUE_GAP], [0,undef,-JOINT_L/2-GLUE_GAP] );
    }
}

module headGuideMale ( xm, xp, ym, yp ) {
    if ( xm ) {
        translate ( [-JOINT_OFFSET,0,+JOINT_OFFSET] )
            rotate( [0,0,+90] )
            headGuideShape();
    }
    if ( xp ) {
        translate ( [+JOINT_OFFSET,0,+JOINT_OFFSET] )
            rotate( [0,0,-90] )
            headGuideShape();
    }
    if ( ym ) {
        translate ( [0,-JOINT_OFFSET,+JOINT_OFFSET] )
            rotate( [0,0,+180] )
            headGuideShape();
    }
    if ( yp ) {
        translate ( [0,+JOINT_OFFSET,+JOINT_OFFSET] )
            rotate( [0,0,+0] )
            headGuideShape();
    }
}

module headGuideFemale ( xm, xp, ym, yp ) {
    if ( xm ) {
        translate ( [-JOINT_OFFSET,0,+JOINT_OFFSET] )
            rotate( [0,0,+90] )
            headGuideShape(false);
    }
    if ( xp ) {
        translate ( [+JOINT_OFFSET,0,+JOINT_OFFSET] )
            rotate( [0,0,-90] )
            headGuideShape(false);
    }
    if ( ym ) {
        translate ( [0,-JOINT_OFFSET,+JOINT_OFFSET] )
            rotate( [0,0,+180] )
            headGuideShape(false);
    }
    if ( yp ) {
        translate ( [0,+JOINT_OFFSET,+JOINT_OFFSET] )
            rotate( [0,0,+0] )
            headGuideShape(false);
    }
}

module headBlack( face=FACE_ALL ) {
    extrude = 3*SHADER_T; // Lithophane effect

    if ( face==FACE_FRONT || face==FACE_ALL ) {
        color( CBLACK )
        translate([0,0,HEAD_W/2])
        difference() {
            union() {
                rotate([90,0,0])
                    extrudePolygons(getFrontHeadBlackRings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
            }
        }
    }
}

module headGreen1( face=FACE_ALL ) {
    extrude = 1.5*SHADER_T; // Lithophane effect

    color( CGREEN1 )
    translate([0,0,HEAD_W/2])
    difference() {
        union() {
            if ( face==FACE_FRONT || face==FACE_ALL ) {
                rotate([90,0,0])
                    extrudePolygons(getFrontHeadGreen1Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
            }
        }
    }
}

module headGrey( face=FACE_ALL ) {
    extrude = 2*SHADER_T; // 2* to allow interior beveling

    color( CGREY )
    translate([0,0,HEAD_W/2])
    difference() {
        union() {
            if ( face==FACE_FRONT || face==FACE_ALL ) {
                rotate([90,0,0]) {
                    difference() {
                        extrudePolygons(getFrontHeadGreyRings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                        headGuideFemale(true,true,false,false);
                    }
                    headGuideMale(false,false,false,true);
                }
            }
            if ( face==FACE_RIGHT || face==FACE_ALL ) {
                rotate([0,0,+90])
                rotate([90,0,0]) {
                    extrudePolygons(getRightHeadGreyRings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                    headGuideMale(true,true,false,true);
                }
            }
            if ( face==FACE_BACK || face==FACE_ALL ) {
                rotate([0,0,180])
                rotate([90,0,0]) {
                    difference() {
                        extrudePolygons(getBackHeadGreyRings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                        headGuideFemale(true,true,false,false);
                    }
                    headGuideMale(false,false,false,true);
                }
            }
            if ( face==FACE_LEFT || face==FACE_ALL ) {
                rotate([0,0,-90])
                rotate([90,0,0]) {
                    extrudePolygons(getLeftHeadGreyRings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                    headGuideMale(true,true,false,true);
                }
            }
            if ( face==FACE_TOP || face==FACE_ALL ) {
                rotate([0,0,0]) {
                    difference() {
                        extrudePolygons(getTopHeadGreyRings(), HEAD_W/2, extrude, [0,0,0]);
                        headGuideFemale(true,true,true,true);
                    }
                }
            }
        }
        headHollow();
    }
}

module headGreen2( face=FACE_ALL ) {
    extrude = 2*SHADER_T; // 2* to allow interior beveling

    color( CGREEN2 )
    translate([0,0,HEAD_W/2])
    difference() {
        union() {
            if ( face==FACE_FRONT || face==FACE_ALL ) {
                rotate([90,0,0]) {
                    difference() {
                        extrudePolygons(getFrontHeadGreen2Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                        headGuideFemale(true,true,false,false);
                    }
                }
            }
            if ( face==FACE_RIGHT || face==FACE_ALL ) {
                rotate([0,0,+90])
                rotate([90,0,0]) {
                    extrudePolygons(getRightHeadGreen2Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                }
            }
            if ( face==FACE_BACK || face==FACE_ALL ) {
                rotate([0,0,180])
                rotate([90,0,0]) {
                    difference() {
                        extrudePolygons(getBackHeadGreen2Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                        headGuideFemale(true,true,false,false);
                    }
                }
            }
            if ( face==FACE_LEFT || face==FACE_ALL ) {
                rotate([0,0,-90])
                rotate([90,0,0]) {
                    extrudePolygons(getLeftHeadGreen2Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                }
            }
            if ( face==FACE_TOP || face==FACE_ALL ) {
                rotate([0,0,0]) {
                    difference() {
                        extrudePolygons(getTopHeadGreen2Rings(), HEAD_W/2, extrude, [0,0,0]);
                        headGuideFemale(true,true,true,true);
                    }
                }
            }
        }
        headHollow();
    }
}

module headGreen3( face=FACE_ALL ) {
    extrude = 2*SHADER_T; // 2* to allow interior beveling

    color( CGREEN3 )
    translate([0,0,HEAD_W/2])
    difference() {
        union() {
            if ( face==FACE_FRONT || face==FACE_ALL ) {
                rotate([90,0,0]) {
                    difference() {
                        extrudePolygons(getFrontHeadGreen3Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                        headGuideFemale(true,true,false,false);
                    }
                }
            }
            if ( face==FACE_RIGHT || face==FACE_ALL ) {
                rotate([0,0,+90])
                rotate([90,0,0]) {
                    extrudePolygons(getRightHeadGreen3Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                }
            }
            if ( face==FACE_BACK || face==FACE_ALL ) {
                rotate([0,0,180])
                rotate([90,0,0]) {
                    difference() {
                        extrudePolygons(getBackHeadGreen3Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                        headGuideFemale(true,true,false,false);
                    }
                }
            }
            if ( face==FACE_LEFT || face==FACE_ALL ) {
                rotate([0,0,-90])
                rotate([90,0,0]) {
                    extrudePolygons(getLeftHeadGreen3Rings(), HEAD_W/2, extrude, [undef,-HEAD_W/2,-HEAD_W/2], [0,undef,0]);
                }
            }
            if ( face==FACE_TOP || face==FACE_ALL ) {
                rotate([0,0,0]) {
                    difference() {
                        extrudePolygons(getTopHeadGreen3Rings(), HEAD_W/2, extrude, [0,0,0]);
                        headGuideFemale(true,true,true,true);
                    }
                }
            }
        }
        headHollow();
    }
    if ( face==FACE_TOP || face==FACE_ALL ) {
        color( CGREEN3 )
            headMount();
    }
}

module headMount() {
    translate( [0,0,HEAD_W-SHADER_T-SPRING_GRIP_H] )
        cylinder( r=SPRING_DINT/2, h=SPRING_GRIP_H );
}
