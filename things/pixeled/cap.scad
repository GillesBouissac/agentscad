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

include <agentscad/things/pixeled/const.scad>

MIN_WIDTH = (nozzle()+0.1);
CAP_W = CELL_W-2*MIN_WIDTH-2*getRadiusBevel();
CAP_INSERT = 2*layer();
CAP_T = 1;

SNAP_R = CAP_W/(2*sin(45));
SNAP_H = CELL_H/2 - CAP_INSERT;
SNAP_A = 50;

joint_quad_i = newSnapPolygonInt ( height=SNAP_H, radius=SNAP_R, spring_w=CELL_W/5, cutdistance=CELL_W/3, spring_a=SNAP_A, leaves=4, springs=true );
joint_quad_e = newSnapPolygonExt ( source=joint_quad_i );
joint_elevation = getSnapJointVGap(joint_quad_e)+mfg();

drad = getSnapJointSpringW(joint_quad_e)-getSnapJointHGap(joint_quad_i);
function getCapGripWidth() = CAP_W - 2*drad;

module cap() {
    gap = 2*gap();
    translate( [0,0,joint_elevation] ) {
        intersection() {
            snapJoint( joint_quad_i );
            translate( [0,0,-500+SNAP_H] )
                cube ( [CAP_W-gap,CAP_W-gap,1000], center=true );
        }
    }
    intersection() {
        translate( [0,0,joint_elevation] )
            snapJointShape ( joint_quad_i );
        translate( [0,0,CELL_H/2-CAP_T/2+joint_elevation/2] )
            cube ( [ CAP_W-gap, CAP_W-gap, CAP_T-joint_elevation], center=true );
    }
}

module capPassage() {
    translate( [0,0,+joint_elevation] )
        snapJointHollow( joint_quad_e );
    translate( [0,0,CELL_H/2-CAP_INSERT/2] )
        cube ( [ CAP_W, CAP_W, CAP_INSERT+mfg()], center=true );
}

module partCaps( part_layout, colors=[[],[]] ) {
    hy = floor(len(part_layout)/2);
    hx = floor(len(part_layout[0])/2);
    for ( i = [0:len(part_layout)-1] ) {
        for ( j = [0:len(part_layout[i])-1] ) {
            let ( val = part_layout[i][j] )
            if ( val>=0 ) {
                translate( [ (j-hx)*CELL_W, (hy-i)*CELL_W, 0 ] )
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
