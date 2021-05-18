/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - body modules
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/bevel.scad>
use <creeper-polygons.scad>
use <creeper-lib.scad>
include <creeper-const.scad>


SHOULDER_BODY_H = HEAD_H - BODY_HDH - SHADER_T - SPRING_L;
BODY_TO_LED_RING_H = HEAD_H/2 - LED_RING_H/2 - BODY_HDH;

module bevelBody() {
    translate( [0,0,BODY_H/2] )
        bevelCube(BODY_L, width=BODY_W, height=BODY_H, $bevel=BEVEL);
}

module bodyMountHollow() {
    translate( [0,0,SHOULDER_BODY_H] )
        difference() {
            // Spring passage
            cylinder( r=SPRING_PD/2, h=1000);
            // Spring grip
            cylinder( r=SPRING_DINT/2, h=SPRING_GRIP_H );
        }
}

module bodyMountShape() {
    // Link from body to led ring
    cylinder( r1=BODY_W/2, r2=LED_RING_D/2, h=BODY_TO_LED_RING_H );

    // Led RING
    translate([0,0,BODY_TO_LED_RING_H])
        cylinder( r=LED_RING_D/2, h=LED_RING_H );
}

module bodyMount() {
    translate( [0,0,BODY_H] )
        difference() {
            bodyMountShape();
            bodyMountHollow();
        }
}

module bodyGrey() {
    extrude = BODY_W/2-mfg();
    color( CGREY )
    difference() {
        union() {
            translate( [0,0,BODY_W/2] )
                rotate ( [180,0,0] )
                rotate ( [0,0,90] )
                extrudePolygons(getBodyTopGreyRings(), BODY_W/2, extrude, [undef,0,BODY_W/2-BODY_L/2], [0,undef,0]);
            rotate ( [90,0,0] )
                extrudePolygons(getBodyFrontGreyRings(), BODY_W/2, extrude, [undef,BODY_H,BODY_W/2-BODY_H], [0,undef,BODY_W/2-BODY_L/2]);
            rotate ( [0,0,+90] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyRightGreyRings(), BODY_L/2, extrude, [undef,BODY_H,BODY_L/2-BODY_H], [0,undef,BODY_L/2-BODY_W/2]);
            rotate ( [0,0,+180] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyBackGreyRings(), BODY_W/2, extrude, [undef,BODY_H,BODY_W/2-BODY_H], [0,undef,BODY_W/2-BODY_L/2]);
            rotate ( [0,0,-90] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyLeftGreyRings(), BODY_L/2, extrude, [undef,BODY_H,BODY_L/2-BODY_H], [0,undef,BODY_L/2-BODY_W/2]);
        }
        bevelBody();
    }
}
module bodyGreen2() {
    extrude = BODY_W/2-mfg();
    color( CGREEN2 )
    difference() {
        union() {
            translate( [0,0,BODY_W/2] )
                rotate ( [180,0,0] )
                rotate ( [0,0,90] )
                extrudePolygons(getBodyTopGreen2Rings(), BODY_W/2, extrude, [undef,0,BODY_W/2-BODY_L/2], [0,undef,0]);
            rotate ( [90,0,0] )
                extrudePolygons(getBodyFrontGreen2Rings(), BODY_W/2, extrude, [undef,BODY_H,BODY_W/2-BODY_H], [0,undef,BODY_W/2-BODY_L/2]);
            rotate ( [0,0,+90] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyRightGreen2Rings(), BODY_L/2, extrude, [undef,BODY_H,BODY_L/2-BODY_H], [0,undef,BODY_L/2-BODY_W/2]);
            rotate ( [0,0,+180] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyBackGreen2Rings(), BODY_W/2, extrude, [undef,BODY_H,BODY_W/2-BODY_H], [0,undef,BODY_W/2-BODY_L/2]);
            rotate ( [0,0,-90] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyLeftGreen2Rings(), BODY_L/2, extrude, [undef,BODY_H,BODY_L/2-BODY_H], [0,undef,BODY_L/2-BODY_W/2]);
        }
        bevelBody();
    }
}
module bodyGreen3() {
    extrude = BODY_W/2-mfg();
    color( CGREEN3 )
    difference() {
        union() {
            translate( [0,0,BODY_W/2] )
                rotate ( [180,0,0] )
                rotate ( [0,0,90] )
                extrudePolygons(getBodyTopGreen3Rings(), BODY_W/2, extrude, [undef,0,BODY_W/2-BODY_L/2], [0,undef,0]);
            rotate ( [90,0,0] )
                extrudePolygons(getBodyFrontGreen3Rings(), BODY_W/2, extrude, [undef,BODY_H,BODY_W/2-BODY_H], [0,undef,BODY_W/2-BODY_L/2]);
            rotate ( [0,0,+90] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyRightGreen3Rings(), BODY_L/2, extrude, [undef,BODY_H,BODY_L/2-BODY_H], [0,undef,BODY_L/2-BODY_W/2]);
            rotate ( [0,0,+180] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyBackGreen3Rings(), BODY_W/2, extrude, [undef,BODY_H,BODY_W/2-BODY_H], [0,undef,BODY_W/2-BODY_L/2]);
            rotate ( [0,0,-90] )
                rotate ( [90,0,0] )
                extrudePolygons(getBodyLeftGreen3Rings(), BODY_L/2, extrude, [undef,BODY_H,BODY_L/2-BODY_H], [0,undef,BODY_L/2-BODY_W/2]);
        }
        bevelBody();
    }
    color( CGREEN3 )
        bodyMount();
}

