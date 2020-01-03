/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Snap joint
 * Author:      Gilles Bouissac
 * 
 */

use <scad-utils/lists.scad>
use <scad-utils/transformations.scad>
use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <list-comprehension-demos/sweep.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// height:      Total height
// radius:      External radius of snap joint
// leaves:      Number of clip leaves
// thickness:   Wall thickness
// hook_w:      Hook width
// hook_h:      Hook height
// springs:     True to make springs, default false
// spring_w:    Spring width
// spring_a:    Spring angle
// cutwidth:    Spring cut width
// cutdistance: Spring cut distance from external radius
// source:      Every unset parameter will be cloned from this joint

// Cylindric Joint, internal part
function newSnapCircleInt (
  height=undef, radius=undef, leaves=undef, thickness=undef,
  hook_w=undef, hook_h=undef, springs=undef, spring_w=undef, spring_a=undef,
  cutwidth=undef, cutdistance=undef, source=undef
) = newSnapJoint(true,false,height,radius,thickness,leaves,hook_w,hook_h,
    springs, spring_w,spring_a,cutwidth,cutdistance,source);

// Cylindric Joint, external part
function newSnapCircleExt (
  height=undef, radius=undef, leaves=undef, thickness=undef,
  hook_w=undef, hook_h=undef, springs=undef, spring_w=undef, spring_a=undef,
  cutwidth=undef, cutdistance=undef, source=undef
) = newSnapJoint(false,false,height,radius,thickness,leaves,hook_w,hook_h,
    springs, spring_w,spring_a,cutwidth,cutdistance,source);

// Polygonal Joint, internal part
function newSnapPolygonInt (
  height=undef, radius=undef, leaves=undef, thickness=undef,
  hook_w=undef, hook_h=undef, springs=undef, spring_w=undef, spring_a=undef,
  cutwidth=undef, cutdistance=undef, source=undef
) = newSnapJoint(true,true,height,radius,thickness,leaves,hook_w,hook_h,
    springs, spring_w,spring_a,cutwidth,cutdistance,source);

// Polygonal Joint, external part
function newSnapPolygonExt (
  height=undef, radius=undef, leaves=undef, thickness=undef,
  hook_w=undef, hook_h=undef, springs=undef, spring_w=undef, spring_a=undef,
  cutwidth=undef, cutdistance=undef, source=undef
) = newSnapJoint(false,true,height,radius,thickness,leaves,hook_w,hook_h,
    springs, spring_w,spring_a,cutwidth,cutdistance,source);

function getSnapJointIsInt(joint)        = joint[I_INT];
function getSnapJointIsPolygon(joint)    = joint[I_IP];
function getSnapJointHasSpring(joint)    = joint[I_SON];
function getSnapJointH(joint)            = joint[I_H];
function getSnapJointDH(joint)           = joint[I_DZ];
function getSnapJointW(joint)            = joint[I_W];
function getSnapJointR(joint)            = joint[I_RE];
function getSnapJointT(joint)            = joint[I_T];
function getSnapJointLeaves(joint)       = joint[I_L];
function getSnapJointHookW(joint)        = joint[I_HW];
function getSnapJointHookH(joint)        = joint[I_HH];
function getSnapJointSpringW(joint)      = joint[I_SW];
function getSnapJointSpringA(joint)      = joint[I_SA];
function getSnapJointCutterW(joint)      = joint[I_CW];
function getSnapJointCutterD(joint)      = joint[I_CD];
function getSnapJointHGap(joint=[])      = gap();
function getSnapJointVGap(joint)         = joint[I_INT]?0:getSnapJointHGap()*tan(joint[I_SA]);
function getSnapJointRadialT(joint)      = let(
    angle     = 180/joint[I_L],
    thickness = joint[I_IP] ? joint[I_T]/cos(angle) : joint[I_T]
) thickness;

module snapJointShape ( joint ) {
    if ( joint[I_INT] )
        snapJointGrip(joint, 0, joint[I_DZ] );
    else
        snapJointGrip(joint, -getSnapJointHGap()-joint[I_T], joint[I_DZ] );
}
module snapJointHollow ( joint ) {
    if ( joint[I_INT] )
        snapJointGrip(joint, joint[I_T] );
    else
        snapJointGrip(joint, -getSnapJointHGap() );
    if ( joint[I_SON] )
        snapJointCuts(joint);
}
module snapJoint ( joint ) {
    difference() {
        snapJointShape(joint);
        snapJointHollow(joint);
    }
}

// ----------------------------------------
//             Implementation
// ----------------------------------------
I_INT = 0;   // Internal or External
I_IP  = 1;   // Poly or circle
I_H   = 2;   // Total Height
I_W   = 3;   // Width of leaves for polygon shape
I_RI  = 4;   // Small radius
I_RE  = 5;   // Large radius
I_T   = 6;   // Wall thickness
I_L   = 7;   // Number of leaves
I_HW  = 8;   // Hook Width
I_HH  = 9;   // Hook Height
I_SW  = 10;  // Spring Width
I_SA  = 11;  // Spring inclinaison angle
I_SON = 12;  // Springs are enabled
I_CW  = 13;  // Spring cut width
I_CD  = 14;  // Spring cut distance from external radius
I_DZ  = 15;  // Height of cylindric part on top of internal joint
I_RT  = 16;  // Rotation angle

JOINT_H  = 6;
JOINT_R  = 8;
JOINT_L  = 5;
JOINT_T  = 1.2;

HOOK_B  = 0.6;
HOOK_W  = 0.6;
HOOK_H  = 2.0;
HOOK_DA = 5;

SPRING_W    = 3;
SPRING_A    = 40;

CUTTER_W  = 1;
CUTTER_D  = 1;

function newSnapJoint (
    isint,
    ispoly,
    height      = undef,
    radius      = undef,
    thickness   = undef,
    leaves      = undef,
    hook_w      = undef,
    hook_h      = undef,
    springs     = undef, 
    spring_w    = undef,
    spring_a    = undef,
    cutwidth    = undef,
    cutdistance = undef,
    source      = undef
) = let (
    loc_isint  = isint,
    loc_ispoly = ispoly,
    loc_height = is_undef(height) ? (is_undef(source)?JOINT_H:source[I_H]) : height,
    loc_leaves = is_undef(leaves) ? (is_undef(source)?JOINT_L:source[I_L]) : leaves,
    rotation   = loc_ispoly ? 180/loc_leaves : 0,
    loc_rext   = is_undef(radius) ? (is_undef(source)?JOINT_R:source[I_RE]) : radius,
    loc_width  = loc_ispoly ? 2*loc_rext*sin(rotation) : 0,
    loc_rint   = loc_ispoly ? loc_rext*(cos(rotation)) : loc_rext,
    loc_hook_w = is_undef(hook_w) ? (is_undef(source)?HOOK_W:source[I_HW]) : hook_w,
    loc_hook_h = is_undef(hook_h) ? (is_undef(source)?HOOK_H:source[I_HH]) : hook_h,
    loc_sp_on  = springs ? true : false,
    loc_sp_w   = is_undef(spring_w) ? (is_undef(source)?SPRING_W:source[I_SW]) : spring_w,
    loc_sp_a   = is_undef(spring_a) ? (is_undef(source)?SPRING_A:source[I_SA]) : spring_a,
    loc_cut_w  = is_undef(cutwidth)    ? (is_undef(source)?CUTTER_W:source[I_CW]) : cutwidth,
    loc_cut_d  = is_undef(cutdistance) ? (is_undef(source)?CUTTER_D:source[I_CD]) : cutdistance,
    loc_t      = is_undef(thickness) ? (is_undef(source)?JOINT_T:source[I_T]) : thickness,
    loc_dz     = loc_t*tan(loc_sp_a)
) [ loc_isint, loc_ispoly, loc_height, loc_width, loc_rint, loc_rext, loc_t, loc_leaves, loc_hook_w, loc_hook_h, loc_sp_w, loc_sp_a, loc_sp_on, loc_cut_w, loc_cut_d, loc_dz, rotation ];

function snapJointProfile( joint ) = let (
    step  = joint[I_IP] ? 1/joint[I_L] : getStep(),
    r     = joint[I_RE]
) [
    for ( i=[0:step:1] ) let ( a=360*i+joint[I_RT] )
        [ r*cos(-a), r*sin(-a) ]
];

function snapJointGripLine ( joint, off, cyl_h=undef ) = let(
    wTop     = joint[I_RI],
    wPassage = wTop     - joint[I_SW],
    wHook    = wPassage + joint[I_HW],
    wBottom  = wPassage,
    dxTop    = off,
    dyTop    = off*tan(joint[I_SA]),
    dxBot    = 0,
    dyBot    = 0
)[
    [ wBottom+dxBot,  dyBot ],
    [ wHook,          joint[I_HW] ],
    // -HOOK_DA to get more than 90 deg from spring in order to bend the spring
    //    when we try to release the joint
    [ wHook,          joint[I_HH]-joint[I_HW]/tan(joint[I_SA]-HOOK_DA) ],
    [ wBottom,        joint[I_HH] ],
    [ wPassage,       joint[I_H]-joint[I_SW]*tan(joint[I_SA]) ],
    [ wTop+dxTop,     joint[I_H]+dyTop ],
    if ( !is_undef(cyl_h) )
        [ wTop+dxTop,     joint[I_H]+dyTop+cyl_h ]
];
function tangentLinePath ( width, line ) = [
    for ( pt=line ) let (
        s = pt.x/width
    ) translation([0,0,pt.y])*scaling([s,s,1])
];

module snapJointGrip ( joint, off=0, cyl_h=undef ) {
    profile   = snapJointProfile( joint );
    shapeLine = snapJointGripLine(joint,off,cyl_h);
    shifted   = [ for ( pt=shapeLine ) [pt.x-off,pt.y+0] ];
    path      = tangentLinePath(joint[I_RI], shifted );
    sweep ( profile, path );
}

module snapJointCut (joint) {
    w     = joint[I_CW];
    d     = joint[I_CD];
    alpha = joint[I_SA];
    dz    = joint[I_RE]/tan(alpha)-d*sin(alpha);
    z     = joint[I_H] - (joint[I_INT] ? 0 : (joint[I_T]+getSnapJointHGap())*tan(joint[I_SA]) ) + dz;
    translate ( [0,0,z] ) {
        rotate( [0,90-joint[I_SA],0] )
            union() {
                translate ( [50,0,-w/2] )
                    rotate([0,90,0])
                    cylinder ( r=w/2, h=100, center=true );
                translate ( [0,0,-w/2] )
                    rotate( [90,0,0] )
                        translate ( [0,0,-w/2] )
                        linear_extrude( height=w )
                        polygon( [ [0,0], [100,0], [100,-100*tan(alpha)] ] );
            }
    }
}
module snapJointCuts (joint) {
    step  = 1/joint[I_L];
    r     = joint[I_RE];

    for ( i=[0:step:1] ) let ( a=360*i+joint[I_RT] )
        rotate([0,0,a])
            snapJointCut(joint);
}

// ----------------------------------------
//                Showcase
// ----------------------------------------

SHOW_INTERVAL = 0;

module showSnapJointParts (part=0, sub_part=0, cut=undef, cut_rotation=undef) {

    // One time snap joint, cannot be removed after insertion
    joint_circ_ext_spring_i = newSnapCircleInt ( height=7, radius=7, leaves=5, spring_w=5 );
    joint_circ_ext_spring_e = newSnapCircleExt ( source=joint_circ_ext_spring_i, springs=true, cutdistance=1 );

    // Removable snap joint
    joint_pent_i = newSnapPolygonInt ( radius=10, leaves=5, springs=true, cutdistance=3 );
    joint_pent_e = newSnapPolygonExt ( source=joint_pent_i );

    if ( part==0 ) {
        intersection () {
            union() {
                translate( [-10,0,0] ) {
                    translate( [0,0,SHOW_INTERVAL] )
                    snapJoint ( joint_pent_i );
                    snapJoint ( joint_pent_e );
                }
                translate( [+10,0,0] ) {
                    translate( [0,0,SHOW_INTERVAL] )
                    snapJoint ( joint_circ_ext_spring_i );
                    snapJoint ( joint_circ_ext_spring_e );
                }
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }
}

// part=0: mutiple parts at the same time
//   cut/cut_rotation: cut position/rotation (ex:0) to see inside (undef for no cut)
// $fn:    Rendering precision
SMOOTH  = 100;
FAST    = 20;
LOWPOLY = 6;
showSnapJointParts ( part=0, cut=0, cut_rotation=undef, $fn=SMOOTH );

