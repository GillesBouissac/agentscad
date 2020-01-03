/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Snap Joint tutorial
 * Author:      Gilles Bouissac
 */

use <../snap-joint.scad>

// ----------------------------------------
//    API
// ----------------------------------------
$fn=50;
showCase() {
    step_01();
    step_02();
    step_03();
    step_04();
    step_05();
    step_06();
    step_07();
    step_08();
    step_09();
    step_10();
    step_11();
    step_12();
};

// ----------------------------------------
//    Showcase
// ----------------------------------------
SHOW_ITV_H   = 30;

// 1: Simple Joint internal part
module step_01() {
    joint = newSnapCircleInt ();
    snapJoint(joint);
}

// 2: Same with external part
module step_02() {
    joint   = newSnapCircleInt();
    snapJoint(joint);
    joint_e = newSnapCircleExt(source=joint);
    snapJoint(joint_e);
}

// 3: Gap
module step_03() {
    $gap = 1;

    joint   = newSnapCircleInt();
    snapJoint(joint);
    joint_e = newSnapCircleExt(source=joint);
    snapJoint(joint_e);
}

// 4: Springs/Cutter
module step_04() {
    joint   = newSnapCircleInt(springs=true);
    snapJoint(joint);
    joint_e = newSnapCircleExt(source=joint);
    snapJoint(joint_e);
}

// 5: Polygon 5
module step_05() {
    joint   = newSnapPolygonInt(springs=true);
    snapJoint(joint);
    joint_e = newSnapPolygonExt(source=joint);
    snapJoint(joint_e);
}

// 6: Polygon 4
module step_06() {
    joint   = newSnapPolygonInt (
        leaves=4,
        springs=true );
    snapJoint(joint);
    joint_e = newSnapPolygonExt(source=joint);
    snapJoint(joint_e);
}

// 7: Cut external: one time joint
module step_07() {
    joint   = newSnapCircleInt ();
    snapJoint(joint);
    joint_e = newSnapCircleExt (
        source=joint,
        springs=true );
    snapJoint(joint_e);
}

// 8: Height/Thickness
module step_08() {
    joint   = newSnapCircleInt (
        height    = 10,
        thickness = 3,
        springs   = true );
    snapJoint(joint);
}

// 9: Hook
module step_09() {
    joint   = newSnapCircleInt (
        height    = 10,
        springs   = true,
        hook_h    = 5,
        hook_w    = 1.6 );
    snapJoint(joint);
}

// 10: Spring width
module step_10() {
    joint   = newSnapCircleInt (
        height    = 10,
        springs   = true,
        hook_h    = 5,
        hook_w    = 1.6,
        spring_w  = 5 );
    snapJoint(joint);
}

// 11: Spring angle
module step_11() {
    joint   = newSnapCircleInt (
        height    = 10,
        springs   = true,
        hook_h    = 5,
        hook_w    = 1.6,
        spring_w  = 5,
        spring_a  = 33 );
    snapJoint(joint);
}

// 12: Cut
module step_12() {
    joint   = newSnapCircleInt (
        springs     = true,
        cutwidth    = 2,
        cutdistance = 7
    );
    snapJoint(joint);
}

// ----------------------------------------
//             Implementation
// ----------------------------------------

module showOneStep ( x=0 ) {
    translate([x,SHOW_ITV_H,0])
        children();
    translate([x,0,0])
        children();
}

module showCase( only_one=undef ) {
    range = SHOW_ITV_H*($children-1);
    intersection () {
        union() {
            if ( is_undef(only_one) )
                for ( i=[0:$children-1] )
                    showOneStep(-range/2+i*SHOW_ITV_H)
                        children(i);
            else
                showOneStep()
                    children(only_one-1);
        }
        color ( "#fff",0.1 )
            translate( [-500,0,-500] )
            cube( [1000,1000,1000] );
    }
}





