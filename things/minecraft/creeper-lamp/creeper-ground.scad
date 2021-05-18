/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - ground modules
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/bevel.scad>
use <agentscad/printing.scad>
use <agentscad/mx-screw.scad>
use <agentscad/screw-stand.scad>
use <creeper-polygons.scad>
use <creeper-lib.scad>
use <creeper-foot.scad>
include <creeper-const.scad>


LOCK_SCREW = M3(tl=17);
LOCK_SCREW_HL = mxGetHeadLP(LOCK_SCREW);
STAND_DX = GROUND_L/2 - 3*WALL_THICK;
STAND_DY = GROUND_W/2 - 3*WALL_THICK;
STAND_H = GROUND_H - WALL_THICK;
STAND_DRILL_H = STAND_H - WALL_THICK - LOCK_SCREW_HL - 2;
SCREW_STANDS = [
    newScrewStand ( x=+STAND_DX, y=-STAND_DY, s=LOCK_SCREW, l=STAND_H, d=STAND_DRILL_H, i=LOCK_SCREW_HL, t=WALL_THICK, o=standOrientationDownTop() ),
    newScrewStand ( x=+STAND_DX, y=+STAND_DY, s=LOCK_SCREW, l=STAND_H, d=STAND_DRILL_H, i=LOCK_SCREW_HL, t=WALL_THICK, o=standOrientationDownTop() ),
    newScrewStand ( x=-STAND_DX, y=-STAND_DY, s=LOCK_SCREW, l=STAND_H, d=STAND_DRILL_H, i=LOCK_SCREW_HL, t=WALL_THICK, o=standOrientationDownTop() ),
    newScrewStand ( x=-STAND_DX, y=+STAND_DY, s=LOCK_SCREW, l=STAND_H, d=STAND_DRILL_H, i=LOCK_SCREW_HL, t=WALL_THICK, o=standOrientationDownTop() ),
];

module bevelGround() {
    translate( [0,0,GROUND_H/2] )
        bevelCube(GROUND_L, width=GROUND_W, height=GROUND_H, $bevel=BEVEL);
    groundPlugPassage();
    groundDoorPassage();
    translate( [0,0,FOOT_BH] )
        cutFootScrews();
}

module groundPlugPassage() {
    translate( [0, GROUND_W/2, GROUND_H/2 ] )
        rotate( [90,0,0] )
        cylinder( r=PLUG_D/2+gap(), h=10*WALL_THICK, center=true );
}

module groundDoorPassage() {
    translate( [0,0,(WALL_THICK+gap())/2] )
        cube( [ GROUND_L-WALL_THICK+2*gap(), GROUND_W-WALL_THICK+2*gap(), WALL_THICK+gap() ] , center=true );
}

module groundDoor() {
    color( CBROWN2 ) {
        difference() {
            translate( [0,0,WALL_THICK/2] )
                cube( [ GROUND_L-WALL_THICK, GROUND_W-WALL_THICK, WALL_THICK ] , center=true );
            screwStandBoltHollow ( SCREW_STANDS );
        }
        screwStandHead ( SCREW_STANDS );
    }
}

module groundGreen3() {
    extrude = WALL_THICK;

    color( CGREEN3 ) {
        difference() {
            union() {
                rotate( [90,0,0] )
                    extrudePolygons(getGroundFrontGreen3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
                rotate( [0,0,+90] )
                    rotate( [90,0,0] )
                    extrudePolygons(getGroundRightGreen3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
                rotate( [0,0,180] )
                    rotate( [90,0,0] )
                    extrudePolygons(getGroundBackGreen3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
                rotate( [0,0,-90] )
                    rotate( [90,0,0] )
                    extrudePolygons(getGroundLeftGreen3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);

                extrudePolygons(getGroundTopGreen3Rings(), GROUND_H, extrude, [undef,0,GROUND_H-GROUND_W/2], [0,undef,GROUND_H-GROUND_L/2]);
            }
            bevelGround();
        }
        screwStandDrill ( SCREW_STANDS );
    }
}
module groundGrey() {
    extrude = WALL_THICK;

    color( CGREY )
    difference() {
        union() {
            rotate( [90,0,0] )
                extrudePolygons(getGroundFrontGreyRings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,+90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundRightGreyRings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,180] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundBackGreyRings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,-90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundLeftGreyRings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
        }
        bevelGround();
    }
}
module groundBrown1() {
    extrude = WALL_THICK;

    color( CBROWN1 )
    difference() {
        union() {
            rotate( [90,0,0] )
                extrudePolygons(getGroundFrontBrown1Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,+90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundRightBrown1Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,180] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundBackBrown1Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,-90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundLeftBrown1Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
        }
        bevelGround();
    }
}
module groundBrown2() {
    extrude = WALL_THICK;

    color( CBROWN2 )
    difference() {
        union() {
            rotate( [90,0,0] )
                extrudePolygons(getGroundFrontBrown2Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,+90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundRightBrown2Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,180] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundBackBrown2Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,-90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundLeftBrown2Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
        }
        bevelGround();
    }
}
module groundBrown3() {
    extrude = WALL_THICK;

    color( CBROWN3 )
    difference() {
        union() {
            rotate( [90,0,0] )
                extrudePolygons(getGroundFrontBrown3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,+90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundRightBrown3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,180] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundBackBrown3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            rotate( [0,0,-90] )
                rotate( [90,0,0] )
                extrudePolygons(getGroundLeftBrown3Rings(), GROUND_W/2, extrude, [undef,0,GROUND_W/2-GROUND_H], [0,undef,0]);
            extrudePolygons(getGroundTopBrown3Rings(), GROUND_H, extrude, [undef,0,GROUND_H-GROUND_W/2], [0,undef,GROUND_H-GROUND_L/2]);
        }
        bevelGround();
    }
}


