/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - tools
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/extensions.scad>
use <agentscad/bevel.scad>

module bevelCube( length, width=undef, height=undef, nobot=false ) {
    w = is_undef(width) ? length : width;
    th = is_undef(height) ? length : height;
    h = nobot ? th*2 : th;
    dh = nobot ? -th/2 : 0;
    translate( [length/2,-w/2,dh] )
        bevelCutLinear(w, h, -1);
    translate( [-length/2,+w/2,dh] )
        rotate( [0,0,180] )
        bevelCutLinear(w, h, -1);
    translate( [+length/2,w/2,dh] )
        rotate( [0,0,90] )
        bevelCutLinear(length, h, -1);
    translate( [-length/2,-w/2,dh] )
        rotate( [0,0,-90] )
        bevelCutLinear(length, h, -1);
    translate( [0,0,0] )
        rotate( [90,0,0] )
        translate( [length/2,-h/2,0] )
        bevelCutLinear(h, w, -1);
    translate( [0,0,0] )
        rotate( [90,0,180] )
        translate( [length/2,-h/2,0] )
        bevelCutLinear(h, w, -1);
}

//
// Extrudes polygons following vectors from points to vaninsing lines
//
// polygons in a plane paralel to [x,y] plane:
//   - polys: list of polygons of 2D (x,y) points
//   - polysz: z distance of polygons plane
//
// polygons will be extruded along vectors to vanishing lines
//   - width: width of the required slice between polygons plane and image plane
//
// vanishing lines imply scaling of polygons on image plane:
//   - vanishLineX: [-,y,z] position of the vanishing line parallel to x axis
//   - vanishLineY: [x,-,z] position of the vanishing line parallel to y axis
//
// for a vanishing point:
//   - vanishLineX: [x,y,z] position of the vanishing point
//   - vanishLineY: undef
//
module extrudePolygons ( polys, polysz, width, vanishLineX, vanishLineY=undef ) {
    vx = [ 0, vanishLineX.y, vanishLineX.z ];
    vy = is_undef(vanishLineY) ? [ vanishLineX.x, 0, vanishLineX.z ] : [ vanishLineY.x, 0, vanishLineY.z ];

    // p: polygon plane
    //   lyp: distance from vy to polygon plane
    //   lxp: distance from vx to polygon plane
    //   dxp: x distance from vy to polygon point
    //   dyp: y distance from vx to polygon point
    lyp = polysz - vy.z;
    lxp = polysz - vx.z;

    // i: image plane closer to [0,0,0] by slice width
    //   lyi: distance from vy to image plane
    //   lxi: distance from vx to image plane
    //   dxi: x distance from vy to image point
    //   dyi: y distance from vx to image point
    lyi = lyp - width;
    lxi = lxp - width;

    // rx: dxi/dxp
    // ry: dyi/dyp
    rx = lyi/lyp;
    ry = lxi/lxp;

    for ( p=polys )
        let(
            p1 = transform(translation([0,0,polysz]),p),
            p2 = transform(
                translation([0,0,-width])
                *
                translation(+vx) * scaling([1,ry,1]) * translation(-vx)
                *
                translation(+vy) * scaling([rx,1,1]) * translation(-vy)
            ,p1)
        )
        skin( [ p2, p1 ] );
}

