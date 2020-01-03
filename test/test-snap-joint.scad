/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Snap Joint tests
 * Author:      Gilles Bouissac
 */

use <../snap-joint.scad>

// ----------------------------------------
//    API
// ----------------------------------------

// part=0: mutiple parts at the same time in position
// part=1: same joints in printable position
// part=2: Just 4 circular joints for fast test print
//   cut/cut_rotation: cut position/rotation (ex:0) to see inside (undef for no cut)
// $fn:    Rendering precision
SMOOTH  = 100;
FAST    = 50;
LOWPOLY = 6;
showSnapJointParts ( part=1, cut=0, cut_rotation=undef, $fn=FAST );


// ----------------------------------------
//    Showcase
// ----------------------------------------

SHOW_ROTATE  = 0;
SHOW_ITV_V   = 10;
SHOW_ITV_H   = 30;
SHOW_TUBE_H  = 10;

module showSnapJointTube (joint) {
    width = getSnapJointRadialT(joint);
    difference() {
        cylinder ( r=getSnapJointR(joint)+width, h=SHOW_TUBE_H-getSnapJointVGap(joint));
        cylinder ( r=getSnapJointR(joint)-0.1, h=SHOW_TUBE_H-getSnapJointVGap(joint));
    }
}
module showSnapJoint (joint) {
    fn = getSnapJointIsPolygon(joint) ? getSnapJointLeaves(joint) : $fn ;
    rotate( [0,0,SHOW_ROTATE] ) {
        translate( [0,0,-getSnapJointH(joint)] )
            snapJoint( joint );
        translate( [0,0,getSnapJointIsInt(joint)?0:-SHOW_TUBE_H+getSnapJointHGap()] )
            rotate( [0,0,180/fn] )
            showSnapJointTube(joint, $fn=fn);
    }
}

module showSnapJointParts (part=0, sub_part=0, cut=undef, cut_rotation=undef) {

    // One time snap joint, cannot be removed after insertion
    joint_circ_ext_spring_i = newSnapCircleInt ( height=7, spring_w=5 );
    joint_circ_ext_spring_e = newSnapCircleExt ( source=joint_circ_ext_spring_i, springs=true );

    // Removables snap joint
    joint_circ_int_spring_i = newSnapCircleInt ( springs=true );
    joint_circ_int_spring_e = newSnapCircleExt ( source=joint_circ_int_spring_i );

    joint_tri_i = newSnapPolygonInt (
        radius=10, leaves=3, springs=true, spring_w=2.5 );
    joint_tri_e = newSnapPolygonExt ( source=joint_tri_i );

    joint_quad_i = newSnapPolygonInt (
        radius=10, leaves=4, springs=true );
    joint_quad_e = newSnapPolygonExt ( source=joint_quad_i );

    joint_pent_i = newSnapPolygonInt (
        radius=10, leaves=5, springs=true );
    joint_pent_e = newSnapPolygonExt ( source=joint_pent_i );

    joint_hex_i = newSnapPolygonInt (
        radius=10, leaves=6, springs=true );
    joint_hex_e = newSnapPolygonExt ( source=joint_hex_i );

    if ( part==0 ) {
        intersection () {
            union() {
                color( "#2ecc71" )
                translate( [-SHOW_ITV_H,0,0] ) {
                    translate( [0,0,SHOW_ITV_V] )
                    showSnapJoint ( joint_hex_i );
                    showSnapJoint ( joint_hex_e );
                }
                color( "#f9e79f" )
                translate( [0,0,0] ) {
                    translate( [0,0,SHOW_ITV_V] )
                    showSnapJoint ( joint_circ_int_spring_i );
                    showSnapJoint ( joint_circ_int_spring_e );
                }
                color( "#f8c471" )
                translate( [SHOW_ITV_H,0,0] ) {
                    translate( [0,0,SHOW_ITV_V] )
                    showSnapJoint ( joint_circ_ext_spring_i );
                    showSnapJoint ( joint_circ_ext_spring_e );
                }
                color( "#ec7063" )
                translate( [-SHOW_ITV_H,SHOW_ITV_H,0] ) {
                    translate( [0,0,SHOW_ITV_V] )
                    showSnapJoint ( joint_tri_i );
                    showSnapJoint ( joint_tri_e );
                }
                color( "#5dade2" )
                translate( [0,SHOW_ITV_H,0] ) {
                    translate( [0,0,SHOW_ITV_V] )
                    showSnapJoint ( joint_pent_i );
                    showSnapJoint ( joint_pent_e );
                }
                color( "#af7ac5" )
                translate( [SHOW_ITV_H,SHOW_ITV_H,0] ) {
                    translate( [0,0,SHOW_ITV_V] )
                    showSnapJoint ( joint_quad_i );
                    showSnapJoint ( joint_quad_e );
                }
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }

    ext_h = 0;
    int_h = -SHOW_TUBE_H;
    if ( part==1 ) {
        rotate( [180,0,0] ) {
            translate( [-2*SHOW_ITV_H,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_circ_ext_spring_e );
            translate( [-SHOW_ITV_H,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_circ_int_spring_e );
            translate( [0,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_tri_e );
            translate( [SHOW_ITV_H,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_quad_e );
            translate( [2*SHOW_ITV_H,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_pent_e );
            translate( [3*SHOW_ITV_H,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_hex_e );
            translate( [-2*SHOW_ITV_H,SHOW_ITV_H/2,int_h] )
                showSnapJoint ( joint_circ_ext_spring_i );
            translate( [-SHOW_ITV_H,SHOW_ITV_H/2,int_h] )
                showSnapJoint( joint_circ_int_spring_i );
            translate( [0,SHOW_ITV_H/2,int_h] )
                showSnapJoint( joint_tri_i );
            translate( [SHOW_ITV_H,SHOW_ITV_H/2,int_h] )
                showSnapJoint( joint_quad_i );
            translate( [2*SHOW_ITV_H,SHOW_ITV_H/2,int_h] )
                showSnapJoint( joint_pent_i );
            translate( [3*SHOW_ITV_H,SHOW_ITV_H/2,int_h] )
                showSnapJoint( joint_hex_i );
        }
    }
    if ( part==2 ) {
        rotate( [180,0,0] ) {
            translate( [-SHOW_ITV_H/2,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_circ_ext_spring_e );
            translate( [+SHOW_ITV_H/2,-SHOW_ITV_H/2,ext_h] )
                showSnapJoint( joint_circ_int_spring_e );
            translate( [-SHOW_ITV_H/2,SHOW_ITV_H/2,int_h] )
                showSnapJoint ( joint_circ_ext_spring_i );
            translate( [+SHOW_ITV_H/2,SHOW_ITV_H/2,int_h] )
                showSnapJoint ( joint_circ_int_spring_i );
        }
    }
}
