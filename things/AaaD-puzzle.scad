/*
 * Copyright (c) 2020, G.Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Rhombicosidodecahedron puzzle
 * Credits:     Rinus Roelofs
 *                http://www.rinusroelofs.nl/rhinoceros/slide-together/slide-038.html
 * Author:      Gilles Bouissac
 */

use <agentscad/mesh.scad>
use <agentscad/printing.scad>
use <agentscad/extensions.scad>
use <agentscad/bevel.scad>
use <agentscad/polyhedron/rhombicosidodecahedron.scad>

// ----------------------------------------
//             Rendering
// ----------------------------------------

$fn     = 300;  // Joints precision
R       = 80;   // circumscribed sphere radius

// 0 - Render printable pentagon tile
// 1 - Render printable square tile
// 2 - Render printable triangle tile
// 3 - Render printable pentagon to triangle joint
// 4 - Render printable square to square joint
// 5 - Render the rhombicosidodecahedron
// 6 - Render a single joint for design/debug purpose
showParts(5);

// ----------------------------------------
//             Implementation
// ----------------------------------------

WALL_T  = R/30;  // tiles and joints thickness
JOINT_H = R/5.5; // joints height
$bevel  = 0.6;   // parts bevel size

// Basic pentagon shape
module ppentagon(r,e,t) {
    meshPolyhedron(meshFrustum(
        meshRegularPolygon(5,circumscribedRadius(e-gap()/2,5)),
        h=t,
        a=pva(r,e)
    ));
}

// Basic square shape
module psquare(r,e,t) {
    meshPolyhedron(meshFrustum(
        meshRegularPolygon(4,circumscribedRadius(e-gap()/2,4)),
        h=t,
        a=sva(r,e)
    ));
}

// Basic triangle shape
module ptriangle(r,e,t) {
    meshPolyhedron(meshFrustum(
        meshRegularPolygon(3,circumscribedRadius(e-gap()/2,3)),
        h=t,
        a=tva(r,e)
    ));
}

// Basic joint shape
module jointRing(r,e,h,t,gap=0 ) {
    jointRavr = (po(r,e)+r)/2;
    jointRext = jointRavr+h/2;
    jointRint = jointRavr-h/2;

    rotate([90,0,0])
    difference() {
        cylinder(r=jointRext,h=t+gap,center=true);
        cylinder(r=jointRint,h=2*t+gap,center=true);
    }
}

// Pentagon to Triangle joint passage
module ptJointPassage(AaaD,h,t) {
    r   = getAaaDR(AaaD);
    e   = getAaaDE(AaaD);
    j2p = getAaaDV2P(AaaD);
    j2t = j2p*getAaaDP2V(AaaD)[0]*getAaaDV2T(AaaD);
    render()
    difference() {
        translate([0,0,-r])
            jointRing(r,e,h,t,gap());
        multmatrix(j2p) {
            translate([pv(e)/2-500-gap(),0,0])
            cube([1000,1000,1000],center=true);
        }
        multmatrix(j2t) {
            translate([tv(e)/2-500-gap(),0,0])
            cube([1000,1000,1000],center=true);
        }
    }
}

// Square to Square joint passage
module ssJointPassage(AaaD,h,t) {
    r   = getAaaDR(AaaD);
    e   = getAaaDE(AaaD);
    j2p = getAaaDV2P(AaaD);
    j2s = j2p*getAaaDP2E(AaaD)[0]*getAaaDE2S(AaaD);
    render()
    difference() {
        translate([0,0,-r])
            rotate([0,0,90])
            jointRing(r,e,h,t,gap());
        cloneMirror([0,1,0])
            multmatrix(j2s)
            rotate([0,0,45])
            translate([0,e/4-500-gap(),0])
            cube([1000,1000,1000],center=true);
    }
}

// Pentagon to Triangle joint
module ptJoint(AaaD,h,t) {
    r   = getAaaDR(AaaD);
    e   = getAaaDE(AaaD);
    j2p = getAaaDV2P(AaaD);
    j2t = j2p*getAaaDP2V(AaaD)[0]*getAaaDV2T(AaaD);
    jointRavr = (po(r,e)+r)/2;
    jointRext = jointRavr+h/2;
    jointRint = jointRavr-h/2;
    color("#ec0")
    render()
    difference() {
        translate([0,0,-r])
            jointRing(r,e,h,t);
        multmatrix(j2p) {
            translate([t+gap(),0,0]) {
                translate([-500,0,0])
                    cube([1000,1000,1000],center=true);
                rotate([90,0,180])
                    translate([0,-500,0])
                    bevelCutLinear(1000,t);
            }
            translate([pv(e)/2-500,0,0])
                cube([1000,1000,t+2*gap()],center=true);
        }
        multmatrix(j2t) {
            translate([t+gap(),0,0]) {
                translate([-500,0,0])
                    cube([1000,1000,1000],center=true);
                rotate([90,0,180])
                    translate([0,-500,0])
                    bevelCutLinear(1000,t);
            }
            translate([tv(e)/2-500,0,0])
                cube([1000,1000,t+2*gap()],center=true);
        }
        translate([0,0,+500-r+jointRavr-gap()/2])
            cube([t+2*gap(),1000,1000],center=true);
        translate([jointRext,0,jointRext-r+mfg()])
            rotate([90,0,0])
            bevelCutArc(jointRext,t,360);
        translate([0,0,-r-mfg()])
            rotate([90,0,0])
            bevelCutArcConcave(jointRint,t,360);
    }
}

// Square to Square joint
module ssJoint(AaaD,h,t) {
    r   = getAaaDR(AaaD);
    e   = getAaaDE(AaaD);
    j2p = getAaaDV2P(AaaD);
    j2s = j2p*getAaaDP2E(AaaD)[0]*getAaaDE2S(AaaD);
    jointRavr = (po(r,e)+r)/2;
    jointRext = jointRavr+h/2;
    jointRint = jointRavr-h/2;
    color("#ccc")
    render()
    difference() {
        translate([0,0,-r])
            rotate([0,0,90])
            jointRing(r,e,h,t);
        cloneMirror([0,1,0])
            multmatrix(j2s)
            rotate([0,0,45]) {
                translate([0,-500+t/2,0])
                cube([1000,1000,1000],center=true);
                translate([0,e/4-500,0])
                cube([1000,1000,t+2*gap()],center=true);
            }
        translate([0,0,-500-r+jointRavr+gap()/2])
            cube([1000,t+2*gap(),1000],center=true);
        translate([0,jointRext,jointRext-r+mfg()])
            rotate([0,-90,0])
            bevelCutArc(jointRext,t,360);
        translate([0,0,-r-mfg()])
            rotate([0,-90,0])
            bevelCutArcConcave(jointRint,t,360);
    }
}

module tileBevel(AaaD,t,n) {
    b = getRadiusBevel();
    r = getAaaDR(AaaD);
    e = getAaaDE(AaaD);
    diag = circumscribedRadius (e,n);
    svangle = sva(r,e);
    bv1a = (90-svangle)/2;
    bv1opp = b*sin(bv1a);
    bv1adj = b*cos(bv1a);
    for ( i=[0:n-1] )
        rotate([0,0,i*360/n])
        translate([diag+(t/2)*tan(svangle),0,t/2])
            rotate([0,0,180/n])
            rotate([0,-bv1a,0])
            translate([0,e/2,0])
            cube([2*bv1adj,e,2*bv1opp],center=true);
}

module tilePentagon(AaaD,h,t) {
    color("#ec0")
    render()
    difference() {
        ppentagon(getAaaDR(AaaD),getAaaDE(AaaD),t);
        for ( i=[0:4] )
            rotate( [0,0,i*360/5] )
            multmatrix(getAaaDP2V(AaaD)[0])
            rotate( [0,0,180] ) {
                ptJointPassage(AaaD,h,t);
                ssJointPassage(AaaD,h,t);
            }
        tileBevel(AaaD,t,5);
    }
}

module tileSquare(AaaD,h,t) {
    e2j = getAaaDS2E(AaaD)[0]*getAaaDE2P(AaaD)*getAaaDP2V(AaaD)[0];
    color("#ccc")
    render()
    difference() {
        psquare(getAaaDR(AaaD),getAaaDE(AaaD),t);
        cloneMirror([1,-1,0])
        cloneMirror([1,1,0]) {
            multmatrix(e2j)
            rotate( [0,0,180] ) {
                ptJointPassage(AaaD,h,t);
                ssJointPassage(AaaD,h,t);
            }
        }
        tileBevel(AaaD,t,4);
    }
}

module tileTriangle(AaaD,h,t) {
    color("#ec0")
    render()
    difference() {
        ptriangle(getAaaDR(AaaD),getAaaDE(AaaD),t);
        for ( i=[0:2] )
            rotate( [0,0,i*360/3] )
            multmatrix(getAaaDT2V(AaaD)[0]) {
                ptJointPassage(AaaD,h,t);
                ssJointPassage(AaaD,h,t);
            }
        tileBevel(AaaD,t,3);
    }
}

// ----------------------------------------
//               Showcase
// ----------------------------------------

module showParts( part=0 ) {
    AaaD = newRhombicosidodecahedron(R);

    echo ( "D=", 2*getAaaDR(AaaD) );
    echo ( "E=", getAaaDE(AaaD) );
    echo ( "T=", WALL_T );
    echo ( "H=", JOINT_H );

    if ( part==0 ) {
        rotate([180,0,0])
            tilePentagon(AaaD,JOINT_H,WALL_T);
        %translate([0,0,4])
            text( "12x pentagon", halign="center", valign="center", size=5, $fn=100 );
    }
    else if ( part==1 ) {
        rotate([180,0,0])
            tileSquare(AaaD,JOINT_H,WALL_T);
        %translate([0,0,4])
            text( "30x square", halign="center", valign="center", size=5, $fn=100 );
    }
    else if ( part==2 ) {
        rotate([180,0,0])
            tileTriangle(AaaD,JOINT_H,WALL_T);
        %translate([0,0,4])
            text( "20x triangle", halign="center", valign="center", size=5, $fn=100 );
    }
    else if ( part==3 ) {
        rotate([90,0,180])
            ptJoint(AaaD,JOINT_H,WALL_T);
        %translate([0,0,4])
            text( "60x pentagon/triangle joint", halign="center", valign="center", size=5, $fn=100 );
    }
    else if ( part==4 ) {
        rotate([0,90,90])
            ssJoint(AaaD,JOINT_H,WALL_T);
        %translate([0,0,4])
            text( "60x square/square joint", halign="center", valign="center", size=5, $fn=100 );
    }
    else if ( part==5 ) {
        // All together
        AaaDLayout(AaaD) {
            // First children placed at every pentagon location
            union() {
                tilePentagon(AaaD,JOINT_H,WALL_T);
                // Draw the joints at pentagons vertexes
                for ( i=[0:4] )
                    rotate( [0,0,i*360/5] )
                    multmatrix(getAaaDP2V(AaaD)[0])
                        rotate( [0,0,180] ) {
                        ptJoint(AaaD,JOINT_H,WALL_T);
                        ssJoint(AaaD,JOINT_H,WALL_T);
                    }
            }

            // Second children placed at every square location
            tileSquare(AaaD,JOINT_H,WALL_T);

            // Third children placed at every triangle location
            tileTriangle(AaaD,JOINT_H,WALL_T);
        }
    }
    else if ( part==6 ) {
        // Single joint
        ori_2_p = getAaaDV2P(AaaD);
        ori_2_t = ori_2_p * getAaaDP2V(AaaD)[0] * getAaaDV2T(AaaD);
        ori_2_s = ori_2_p * getAaaDP2E(AaaD)[0] * getAaaDE2S(AaaD);

        ptJoint(AaaD,JOINT_H,WALL_T);
        ssJoint(AaaD,JOINT_H,WALL_T);
        multmatrix(ori_2_p) tilePentagon(AaaD,JOINT_H,WALL_T);
        multmatrix(ori_2_t) tileTriangle(AaaD,JOINT_H,WALL_T);
        multmatrix(ori_2_s) tileSquare(AaaD,JOINT_H,WALL_T);
    }
}
