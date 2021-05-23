/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Pickaxe - cell caps for minecraft tool
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/snap-joint.scad>
use <agentscad/printing.scad>
use <agentscad/extensions.scad>
use <agentscad/mesh.scad>
use <agentscad/bevel.scad>
use <agentscad/things/pixeled/const.scad>

function getMinWidth() = (nozzle()+0.1);
function getCapW() = getPixelW()-2*getMinWidth()-2*getRadiusBevel();
function getCapInsert() = 2*layer();
function getCapT() = 1;

function getSnapR() = getCapW()/(2*sin(45));
function getSnapH() = getPixelH()/2 - getCapInsert();
function getSnapA() = 50;

function getJointQuadI() = newSnapPolygonInt ( height=getSnapH(), radius=getSnapR(), spring_w=getPixelW()/5, cutdistance=getPixelW()/3, spring_a=getSnapA(), leaves=4, springs=true );
function getJointQuadE() = newSnapPolygonExt ( source=getJointQuadI() );
function getJointElevation() = getSnapJointVGap(getJointQuadE())+mfg();

function drad() = getSnapJointSpringW(getJointQuadE())-getSnapJointHGap(getJointQuadI());
function getCapGripWidth() = getCapW() - 2*drad();

module cap() {
    elevation = getJointElevation();
    jointI = getJointQuadI();
    gap = 2*gap();
    translate( [0,0,elevation] ) {
        intersection() {
            snapJoint( jointI );
            translate( [0,0,-500+getSnapH()] )
                cube ( [getCapW()-gap,getCapW()-gap,1000], center=true );
        }
    }
    intersection() {
        translate( [0,0,elevation] )
            snapJointShape ( jointI );
        translate( [0,0,getPixelH()/2-getCapT()/2+elevation/2] )
            cube ( [ getCapW()-gap, getCapW()-gap, getCapT()-elevation], center=true );
    }
}

module capPassage() {
    elevation = getJointElevation();
    jointE = getJointQuadE();
    translate( [0,0,+elevation] )
        snapJointHollow( jointE );
    translate( [0,0,getPixelH()/2-getCapInsert()/2] )
        cube ( [ getCapW(), getCapW(), getCapInsert()+mfg()], center=true );
}

module partCaps( part_layout, colors=[[],[]] ) {
    hy = floor(len(part_layout)/2);
    hx = floor(len(part_layout[0])/2);
    for ( i = [0:len(part_layout)-1] ) {
        for ( j = [0:len(part_layout[i])-1] ) {
            let ( val = part_layout[i][j] )
            if ( val>=0 ) {
                translate( [ (j-hx)*getPixelW(), (hy-i)*getPixelW(), 0 ] )
                    color( getCapColor(colors, val) )
                    if ( isCellBicolor(val) ) {
                        cap();
                        rotate( [180,0,0] )
                            cap();
                    }
            }
        }
    }
}
