/*
 * Copyright (c) 2021, Gilles Bouissac
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

use <scad-utils/transformations.scad>
use <agentscad/mesh.scad>
use <agentscad/printing.scad>
use <agentscad/extensions.scad>
use <agentscad/extrude.scad>
use <agentscad/geometry.scad>
use <agentscad/bevel.scad>
use <agentscad/polyhedron/rhombicosidodecahedron.scad>

// ----------------------------------------
//             Rendering
// ----------------------------------------

R       = 80;   // Circumscribed sphere radius

$fn     = 300;  // Joints precision
$gap    = 0.08; // Tight joints

// 0 - Render printable pentagon tile
// 1 - Render printable square tile
// 2 - Render printable triangle tile
// 3 - Render printable pentagon to triangle joint
// 4 - Render printable square to square joint
// 5 - Render printable stand
// 6 - Render all together
// 7 - Render a single joint for design/debug purpose
showParts(6);

// ----------------------------------------
//             Implementation
// ----------------------------------------

WALL_T  = roundDown(R/30,layer());     // tiles and joints thickness
JOINT_H = R/5.5;                       // joints height
CLUE_R  = WALL_T-gap();                // center clue on tiles: radius
CLUE_T  = roundDown(WALL_T/2,layer()); // center clue on tiles: height
$bevel  = 0.6;                         // parts bevel size


function passageT(t) = t+2*gap();

// Basic pentagon shape
module ppentagon(r,e,t,g=gap()) {
    frustum(
        meshRegularPolygon(5,circumscribedRadius(e-g,5)),
        height=t,
        angle=pva(r,e)
    );
}

// Basic square shape
module psquare(r,e,t,g=gap()) {
    frustum(
        meshRegularPolygon(4,circumscribedRadius(e-g,4)),
        height=t,
        angle=sva(r,e)
    );
}

// Basic triangle shape
module ptriangle(r,e,t,g=gap()) {
    frustum(
        meshRegularPolygon(3,circumscribedRadius(e-g,3)),
        height=t,
        angle=tva(r,e)
    );
}

// Basic joint shape
module jointRing(r,e,h,t) {
    jointRavr = (po(r,e)+r)/2;
    jointRext = jointRavr+h/2;
    jointRint = jointRavr-h/2;

    rotate([90,0,0])
    difference() {
        cylinder(r=jointRext,h=t,center=true);
        cylinder(r=jointRint,h=2*t,center=true);
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
            jointRing(r,e,h,passageT(t));
        multmatrix(j2p) {
            translate([pv(e)/2-500-2*gap(),0,0])
            cube([1000,1000,1000],center=true);
        }
        multmatrix(j2t) {
            translate([tv(e)/2-500-2*gap(),0,0])
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
            jointRing(r,e,h,passageT(t));
        cloneMirror([0,1,0])
            multmatrix(j2s)
            rotate([0,0,45])
            translate([0,e/4-500-2*gap(),0])
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
            // mortise to receive pentagon
            translate([pv(e)/2-500,0,0])
                cube([1000,1000,passageT(t)],center=true);
        }
        multmatrix(j2t) {
            translate([t+gap(),0,0]) {
                translate([-500,0,0])
                    cube([1000,1000,1000],center=true);
                rotate([90,0,180])
                    translate([0,-500,0])
                    bevelCutLinear(1000,t);
            }
            // mortise to receive triangle
            translate([tv(e)/2-500,0,0])
                cube([1000,1000,passageT(t)],center=true);
        }
        // mortise to receive ssJoint
        translate([0,0,+500-r+jointRavr-gap()/2])
            cube([passageT(t),1000,1000],center=true);
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

    cutplane = transform(
        j2s*rotation([0,0,45]),
        plane3([[0,t/2],[0,1]]) );
    jointplane = plane3([[+t/2,0],[1,0]]);
    lineToBevel = intersec_planes_2(jointplane,cutplane);
    angle=angle_vector(lineToBevel[1],[0,0,1]);
    vn=cross(lineToBevel[1],[0,0,1]);
    bev=getRadiusBevel()/cos(60);

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
                // mortise to receive square
                translate([0,e/4-500,0])
                    cube([1000,1000,passageT(t)],center=true);
            }
        // Bevel the vertical edge
        cloneMirror([0,1,0])
            translate(lineToBevel[0])
            rotate(-angle,vn)
            rotate([0,0,-60])
            cube([bev,bev,100],center=true);
        // mortise to receive ptJoint
        translate([0,0,-500-r+jointRavr+gap()/2])
            cube([1000,passageT(t),1000],center=true);
        translate([0,jointRext,jointRext-r+mfg()])
            rotate([0,-90,0])
            bevelCutArc(jointRext,t,360);
        translate([0,0,-r-mfg()])
            rotate([0,-90,0])
            bevelCutArcConcave(jointRint,t,360);
    }
}

module stand(AaaD,h,t) {
    hp = h+4*gap();
    r = getAaaDR(AaaD);
    e = getAaaDE(AaaD);
    jointRavr = (po(r,e)+r)/2;
    jointRext = jointRavr+hp/2;
    j2p = getAaaDV2P(AaaD);
    j2t = j2p*getAaaDP2V(AaaD)[0]*getAaaDV2T(AaaD);
    j2s = j2p*getAaaDP2E(AaaD)[0]*getAaaDE2S(AaaD);

    color("sienna")
    difference() {
        translate([0,0,r/2])
            cylinder(r1=2*r/3,r2=0,h=r, center=true);

        translate([0,0,jointRext-po(r,e)+t])
            rotate( [0,180,0] )
            multmatrix(getAaaDP2V(AaaD)[0])
            rotate( [0,0,180] )
            multmatrix(j2p)
                translate([0,0,-r/2])
                prism(
                    meshRegularPolygon(5,circumscribedRadius(e,5)),
                    height=r
                );

        translate([0,0,jointRext-po(r,e)+t])
        rotate( [0,180,0] ){
            for ( i=[0:4] ) {
                rotate( [0,0,i*360/5] ) 
                multmatrix(getAaaDP2V(AaaD)[0])
                rotate( [0,0,180] ) {
                    render(2)
                    difference() {
                        translate([0,0,-r])
                            jointRing(r,e,hp,2*t);
                        multmatrix(j2p)
                            translate([t-gap(),0,0])
                            translate([-500,0,0])
                            cube(1000,center=true);
                        multmatrix(j2t)
                            translate([-500,0,0])
                            cube(1000,center=true);
                    }
                    render(2)
                    difference() {
                        translate([10,0,-r])
                            rotate([0,0,90])
                            jointRing(r,e,hp,2*(t+10));
                        cloneMirror([0,1,0])
                            multmatrix(j2s)
                            rotate([0,0,45])
                            translate([0,-mfg(),0])
                            translate([0,-500,0])
                                cube(1000,center=true);
                    }
                    render(2)
                    multmatrix(j2t)
                        translate([0,0,-r/2])
                        prism(
                            meshRegularPolygon(3,circumscribedRadius(e,3)),
                            height=r
                        );
                    render(2)
                    multmatrix(j2s)
                        translate([0,0,-r/2])
                        prism(
                            meshRegularPolygon(4,circumscribedRadius(e,4)),
                            height=r
                        );
                }
            }
        }
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
    render() {
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
        // Sphere center clue
        translate([0,0,-(t+CLUE_T)/2])
            cylinder(r=CLUE_R, h=CLUE_T, center=true);
    }
}

module tileSquare(AaaD,h,t) {
    e2j = getAaaDS2E(AaaD)[0]*getAaaDE2P(AaaD)*getAaaDP2V(AaaD)[0];
    color("#ccc")
    render() {
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
        // Sphere center clue
        translate([0,0,-(t+CLUE_T)/2])
            cylinder(r=CLUE_R, h=CLUE_T, center=true);
    }
}

module tileTriangle(AaaD,h,t) {
    color("#ec0")
    render() {
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
        // Sphere center clue
        translate([0,0,-(t+CLUE_T)/2])
            cylinder(r=CLUE_R, h=CLUE_T, center=true);
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
    echo ( "Passages =", passageT(WALL_T) );
    echo ( "CLUE R=", CLUE_R );
    echo ( "CLUE T=", CLUE_T );

    if ( part==0 ) {
        rotate([180,0,0])
            tilePentagon(AaaD,JOINT_H,WALL_T);
        %translate([0,0,4])
            text( "12x pentagon", halign="center", valign="center", size=5, $fn=100 );
    }
    else if ( part==1 ) {
        rotate([180,0,45])
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
        stand(AaaD,JOINT_H,WALL_T);
    }
    else if ( part==6 ) {
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
        // Stand
        translate( [0,0,-2*getAaaDR(AaaD)-3] )
            stand(AaaD,JOINT_H,WALL_T);
    }
    else if ( part==7 ) {
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
