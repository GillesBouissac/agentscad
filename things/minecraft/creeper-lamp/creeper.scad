/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - main file
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <creeper-head.scad>
use <creeper-body.scad>
use <creeper-foot.scad>
use <creeper-ground.scad>
use <creeper-cable.scad>

include <creeper-const.scad>

/**
 * Part selection to prepare STL export by part / color
 *
 * part selectors:
 */
PART_ALL = 0;
PART_HEAD_FRONT = FACE_FRONT;
PART_HEAD_RIGHT = FACE_RIGHT;
PART_HEAD_BACK = FACE_BACK;
PART_HEAD_LEFT = FACE_LEFT;
PART_HEAD_TOP = FACE_TOP;
PART_BODY_FOOT = 7;
PART_GROUND = 8;
PART_DOOR = 9;

PART_HEAD = 6;
PART_BODY = 10;
PART_FOOT = 11;

/**
 * color:
 *     0: All
 *
 *     1: Black
 *     2: Grey
 *
 *     3: Green1
 *     4: Green2
 *     5: Green3
 *
 *     6: Brown1
 *     7: Brown2
 *     8: Brown3
 *
 * cut:
 *     0: none
 *     1: half cut
 *     2: cable cut
 *
 */
showCase( part=PART_HEAD_FRONT, color=3, 0 );

//
// This parameter has no incidence on final rendering
//
// when true:
// - Slow to show result after modifications
// - Fast to move the view
// - Colorless
// when false:
// - Fast to show result after modifications
// - Slow to move the view
// - Colors are preserved
//
RENDER = false;
$fn=100;

module showCase( part=PART_ALL, color=0, cut=0 ) {
    difference() {
        showParts ( part, color );
        if ( cut==1 ) {
            translate( [0, 500, 0] )
                cube([1000,1000,1000], center=true);
        }
        if ( cut==2 ) {
            cableCut();
        }
    }
}

module showParts ( part=PART_ALL, color=0 ) {

    if ( (part>=PART_HEAD_FRONT && part<=PART_HEAD) || part==PART_ALL ) {
        conditionalRender()
            creeperHead ( part, color );
    }

    if ( part==PART_BODY_FOOT || part==PART_BODY || part==PART_ALL ) {
        conditionalRender()
            creeperBody ( color );
    }

    if ( part==PART_BODY_FOOT || part==PART_FOOT || part==PART_ALL ) {
        conditionalRender()
            creeperFoot ( color );
    }

    if ( part==PART_GROUND || part==PART_ALL ) {
        conditionalRender()
            creeperGround ( color );
    }

    if ( part==PART_DOOR || part==PART_ALL ) {
        conditionalRender()
            creeperGroundDoor ( color );
    }

    if ( part==PART_ALL ) {
        spring();
    }
}

module conditionalRender() {
    if ( RENDER ) {
        render(20)
            children();
    }
    else {
        children();
    }
}

module creeperHead ( part, color ) {
    // Head
    if ( part==PART_HEAD_FRONT )
        translate( [0,HEAD_W/2,HEAD_W/2] )
        rotate( [90,0,0] )
        translate( [0,0,-HEAD_BH] )
        creeperHeadPlaced( part, color );
    else if ( part==PART_HEAD_RIGHT )
        translate( [-HEAD_W/2,0,HEAD_W/2] )
        rotate( [0,90,0] )
        translate( [0,0,-HEAD_BH] )
        creeperHeadPlaced( part, color );
    else if ( part==PART_HEAD_BACK )
        translate( [0,-HEAD_W/2,HEAD_W/2] )
        rotate( [-90,0,0] )
        translate( [0,0,-HEAD_BH] )
        creeperHeadPlaced( part, color );
    else if ( part==PART_HEAD_LEFT )
        translate( [HEAD_W/2,0,HEAD_W/2] )
        rotate( [0,-90,0] )
        translate( [0,0,-HEAD_BH] )
        creeperHeadPlaced( part, color );
    else if ( part==PART_HEAD_TOP )
        translate( [0,0,HEAD_W] )
        rotate( [180,0,0] )
        translate( [0,0,-HEAD_BH] )
        creeperHeadPlaced( part, color );
    else
        creeperHeadPlaced( FACE_ALL, color );
}

module creeperHeadPlaced ( part, color ) {
    if ( color==1 || color==0 ) {
        translate( [0,0,HEAD_BH] ) headBlack(part);
    }
    if ( color==2 || color==0 ) {
        translate( [0,0,HEAD_BH] ) headGrey(part);
    }
    if ( color==3 || color==0 ) {
        translate( [0,0,HEAD_BH] ) headGreen1(part);
    }
    if ( color==4 || color==0 ) {
        translate( [0,0,HEAD_BH] ) headGreen2(part);
    }
    if ( color==5 || color==0 ) {
        translate( [0,0,HEAD_BH] ) headGreen3(part);
    }
}

module creeperBody ( color ) {
    // Body
    if ( color==2 || color==0 ) {
        difference() {
            translate( [0,0,BODY_BH] ) bodyGrey();
            cablePassage();
        }
    }
    if ( color==4 || color==0 ) {
        difference() {
            translate( [0,0,BODY_BH] ) bodyGreen2();
            cablePassage();
        }
    }
    if ( color==5 || color==0 ) {
        difference() {
            translate( [0,0,BODY_BH] ) bodyGreen3();
            cablePassage();
        }
    }
}

module creeperFoot ( color ) {
    // Foot
    if ( color==1 || color==0 ) {
        difference() {
            translate( [0,0,FOOT_BH] ) footBlack();
            cablePassage();
        }
    }
    if ( color==3 || color==0 ) {
        difference() {
            translate( [0,0,FOOT_BH] ) footGreen1();
            cablePassage();
        }
    }
    if ( color==4 || color==0 ) {
        difference() {
            translate( [0,0,FOOT_BH] ) footGreen2();
            cablePassage();
        }
    }
    if ( color==5 || color==0 ) {
        difference() {
            translate( [0,0,FOOT_BH] ) footGreen3();
            cablePassage();
        }
    }
}

module creeperGround ( color ) {
    // Ground
    if ( color==2 || color==0 ) {
        difference() {
            translate( [0,0,0] ) groundGrey();
            cablePassage();
        }
    }
    if ( color==5 || color==0 ) {
        difference() {
            translate( [0,0,0] ) groundGreen3();
            cablePassage();
        }
    }
    if ( color==6 || color==0 ) {
        difference() {
            translate( [0,0,0] ) groundBrown1();
            cablePassage();
        }
    }
    if ( color==7 || color==0 ) {
        difference() {
            translate( [0,0,0] ) groundBrown2();
            cablePassage();
        }
    }
    if ( color==8 || color==0 ) {
        difference() {
            translate( [0,0,0] ) groundBrown3();
            cablePassage();
        }
    }
}

module creeperGroundDoor ( color ) {
    // Ground door
    if ( color==5 || color==0 ) {
        groundDoor();
    }
}

module spring() {
    %
    translate( [0,0,HEAD_W-SHADER_T-SPRING_L+HEAD_BH] )
    difference() {
        cylinder( r=SPRING_DEXT/2, h=SPRING_L );
        cylinder( r=SPRING_DINT/2, h=1000, center=true );
    }
}
