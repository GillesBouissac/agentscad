/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Rhombicosidodecahedron polyhedron topology
 * Credits:     Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/transformations.scad>
use <scad-utils/lists.scad>
use <scad-utils/spline.scad>
use <agentscad/mesh.scad>
use <agentscad/extensions.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// We use the shortcut AaaD for the Rhombicosidodecahedron
// aaD is the Conway transformation sequence to get a Rhombicosidodecahedron
// btw aaD just gives the topology, polygons are not necessarily regular:
//    https://en.wikipedia.org/wiki/Conway_polyhedron_notation
//    https://levskaya.github.io/polyhedronisme/?recipe=aaD
// We build an Archimedean Rhombicosidodecahedron which means regular polygons:
//    https://en.wikipedia.org/wiki/Archimedean_solid
//    http://dmccooey.com/polyhedra/Rhombicosidodecahedron.html
// This is why I prefix the aaD transformation with A for Archimedean aaD

//
// Build data that records repetitive operations to compute them once
// - r: radius of the circumscribed circle of the polyhedron
//
function newRhombicosidodecahedron(r=10) =
let(e=r*0.44784) // Well... yes this is a magic number
[
  classAaaD(),
  [ p2e(r,e,0),p2e(r,e,1),p2e(r,e,2),p2e(r,e,3),p2e(r,e,4) ],
  [ p2v(r,e,0),p2v(r,e,1),p2v(r,e,2),p2v(r,e,3),p2v(r,e,4) ],
  p2o(r,e), e2p(r,e), v2p(r,e),
  [ s2e(r,e,0), s2e(r,e,1), s2e(r,e,2), s2e(r,e,3) ],
  [ s2v(r,e,0), s2v(r,e,1), s2v(r,e,2), s2v(r,e,3) ],
  s2o(r,e), e2s(r,e), v2s(r,e),
  [ t2e(r,e,0), t2e(r,e,1), t2e(r,e,2) ],
  [ t2v(r,e,0), t2v(r,e,1), t2v(r,e,2) ],
  t2o(r,e), e2t(r,e), v2t(r,e),
  r, e,
];

//
// Assemble children on a rhombicosidodecahedron polyedron
// - obj: object created with newRhombicosidodecahedron()
// - children(0) is placed at every pentagon location
// - children(1) is placed at every square location
// - children(2) is placed at every triangle location
//
module AaaDLayout(obj) {
    class = assertClass(obj,classAaaD());

    // polyhedron topology
    //      ( p0 )
    //         |
    //   (t1) (s1)
    //      \  |
    // (s2)-( p1 )
    // (t2)-( p1 )
    //     /  |  \
    //  (s3) (t3) (s4)
    //       /
    //   ( p2 )-(s6)
    //    /  \
    //  (s5) (t4)
    //       /
    //    ( p3 )
    s1_2_p1 = obj[S2E][2] * obj[E2P];
    p1_2_s2 = obj[P2E][1] * obj[E2S];
    p1_2_s3 = obj[P2E][2] * obj[E2S];
    p1_2_s4 = obj[P2E][3] * obj[E2S];
    p1_2_t1 = obj[P2V][1] * obj[V2T];
    p1_2_t2 = obj[P2V][2] * obj[V2T];
    p1_2_t3 = obj[P2V][3] * obj[V2T];
    t3_2_p2 = obj[T2V][1] * obj[V2P];
    p2_2_s5 = obj[P2E][3] * obj[E2S];
    p2_2_s6 = obj[P2E][4] * obj[E2S];
    p2_2_t4 = obj[P2V][4] * obj[V2T];
    t4_2_p3 = obj[T2V][1] * obj[V2P];

    for( i=[0:4] ) {
        ori_2_s1 = obj[P2E][i] * obj[E2S];
        ori_2_p1 = ori_2_s1 * s1_2_p1;
        ori_2_s2 = ori_2_p1 * p1_2_s2;
        ori_2_s3 = ori_2_p1 * p1_2_s3;
        ori_2_s4 = ori_2_p1 * p1_2_s4;
        ori_2_t1 = ori_2_p1 * p1_2_t1;
        ori_2_t2 = ori_2_p1 * p1_2_t2;
        ori_2_t3 = ori_2_p1 * p1_2_t3;
        ori_2_p2 = ori_2_t3 * t3_2_p2;
        ori_2_s5 = ori_2_p2 * p2_2_s5;
        ori_2_s6 = ori_2_p2 * p2_2_s6;
        ori_2_t4 = ori_2_p2 * p2_2_t4;

        multmatrix(ori_2_p1) children(0);
        multmatrix(ori_2_p2) children(0);
        multmatrix(ori_2_s1) children(1);
        multmatrix(ori_2_s2) children(1);
        multmatrix(ori_2_s3) children(1);
        multmatrix(ori_2_s4) children(1);
        multmatrix(ori_2_s5) children(1);
        multmatrix(ori_2_s6) children(1);
        multmatrix(ori_2_t1) children(2);
        multmatrix(ori_2_t2) children(2);
        multmatrix(ori_2_t3) children(2);
        multmatrix(ori_2_t4) children(2);

        // Top and bottom pentagons only once
        if ( i==0 ) {
            children(0);
            multmatrix(ori_2_t4*t4_2_p3) children(0);
        }
    }
}

//
// Accessors
//
function getAaaDP2E(obj) = obj[P2E]; // from Pentagon center to one Edge
function getAaaDP2V(obj) = obj[P2V]; // from Pentagon center to one Vertex
function getAaaDP2O(obj) = obj[P2O]; // from Pentagon center to sphere Origin
function getAaaDE2P(obj) = obj[E2P]; // from any Edge to Pentagon center
function getAaaDV2P(obj) = obj[V2P]; // from any Vertex to Pentagon center

function getAaaDS2E(obj) = obj[S2E]; // from Square center to one Edge
function getAaaDS2V(obj) = obj[S2V]; // from Square center to one Vertex
function getAaaDS2O(obj) = obj[S2O]; // from Square center to sphere Origin
function getAaaDE2S(obj) = obj[E2S]; // from any Edge to Square center
function getAaaDV2S(obj) = obj[V2S]; // from any Vertex to Square center

function getAaaDT2E(obj) = obj[T2E]; // from Triangle center to one Edge
function getAaaDT2V(obj) = obj[T2V]; // from Triangle center to one Vertex
function getAaaDT2O(obj) = obj[T2O]; // from Triangle center to sphere Origin
function getAaaDE2T(obj) = obj[E2T]; // from any Edge to Triangle center
function getAaaDV2T(obj) = obj[V2T]; // from any Vertex to Triangle center

function getAaaDR(obj)   = obj[IR];  // circumscribed sphere radius
function getAaaDE(obj)   = obj[IE];  // polygons edges length (all equals)

// ----------------------------------------
//             Implementation
// ----------------------------------------

// circumscribed/inscribes circles radius
// - e: polygon edge length
// - n: number of edges in polygon
function circumscribedRadius(e,n) = (e/2)/sin(180/n);
function inscribedRadius(e,n)     = (e/2)/tan(180/n);
// Angle with sphere tangent at vertexes
// - r: sphere circumscribed at vertexes radius
// - e: polygon edge length
// - n: number of edges in polygon
function polyVertexAngle(r,e,n) =
    asin(circumscribedRadius(e,n)/r);
// Distance from sphere center to polygon center
function polyCenterRadius(r,e,n) =
    circumscribedRadius(e,n)/tan(polyVertexAngle(r,e,n));
// Angle with sphere tangent at edges
// - r: sphere circumscribed at vertexes radius
// - e: polygon edge length
// - n: number of edges in polygon
function polyEdgeAngle(r,e,n) =
    atan(inscribedRadius(e,n)/polyCenterRadius(r,e,n));
// Transformation from center of polygon to vertex i
function poly2vertex(n,r,e,i) =
    rotation([0,0,i*360/n]) *
    translation([circumscribedRadius(e,n),0,0]) *
    rotation([0,polyVertexAngle(r,e,n),0]) *
    rotation([0,0,180]);
function vertex2poly(n,r,e) =
    rotation([0,0,180])*matrix_invert(poly2vertex(n,r,e,0));
// Transformation from center of polygon to edge i
function poly2edge(n,r,e,i) =
    rotation([0,0,i*360/n+180/n]) *
    translation([inscribedRadius(e,n),0,0]) *
    rotation([0,polyEdgeAngle(r,e,n),0]) *
    rotation([0,0,180]);
function edge2poly(n,r,e) =
    rotation([0,0,180])*matrix_invert(poly2edge(n,r,e,0));

// Pendagon transformation from center to vertexes and edges
function pv(e)       = circumscribedRadius (e,5);
function pva(r,e)    = polyVertexAngle (r,e,5);
function po(r,e)     = polyCenterRadius (r,e,5);
function p2o(r,e)    = translation([0,0,-po(r,e)]);
function p2v(r,e,i)  = poly2vertex      (5,r,e,i);
function p2e(r,e,i)  = poly2edge        (5,r,e,i);
function v2p(r,e)    = vertex2poly      (5,r,e);
function e2p(r,e)    = edge2poly        (5,r,e);

// Square transformation from center to vertexes and edges
function sv(e)       = circumscribedRadius (e,4);
function sva(r,e)    = polyVertexAngle (r,e,4);
function so(r,e)     = polyCenterRadius (r,e,4);
function s2o(r,e)    = translation([0,0,-so(r,e)]);
function s2v(r,e,i)  = poly2vertex (4,r,e,i);
function s2e(r,e,i)  = poly2edge   (4,r,e,i);
function v2s(r,e)    = vertex2poly (4,r,e);
function e2s(r,e)    = edge2poly   (4,r,e);

// Triangle transformation from center to vertexes and edges
function tv(e)       = circumscribedRadius (e,3);
function tva(r,e)    = polyVertexAngle (r,e,3);
function to(r,e)     = polyCenterRadius (r,e,3);
function t2o(r,e)    = translation([0,0,-to(r,e)]);
function t2v(r,e,i)  = poly2vertex (3,r,e,i);
function t2e(r,e,i)  = poly2edge   (3,r,e,i);
function v2t(r,e)    = vertex2poly (3,r,e);
function e2t(r,e)    = edge2poly   (3,r,e);

function classAaaD() = "rhombicosidodecahedron";

P2E  = 1;
P2V  = 2;
P2O  = 3;
E2P  = 4;
V2P  = 5;

S2E  = 6;
S2V  = 7;
S2O  = 8;
E2S  = 9;
V2S  = 10;

T2E  = 11;
T2V  = 12;
T2O  = 13;
E2T  = 14;
V2T  = 15;

IR   = 16;
IE   = 17;

// ----------------------------------------
//               Showcase
// ----------------------------------------

module showParts() {
    AaaD = newRhombicosidodecahedron(50);

    AaaDLayout(AaaD) {
        WALL_T  = 3;

        // First children placed at every pentagon location
        // Can be anything else
        color("red")
        meshPolyhedron(meshFrustum(
            meshRegularPolygon(5,circumscribedRadius(AaaD[IE]-1,5)),
            h=WALL_T,
            a=polyVertexAngle(AaaD[IR],AaaD[IE],5)
        ));

        // Second children placed at every square location
        // Can be anything else
        color("yellow")
        meshPolyhedron(meshFrustum(
            meshRegularPolygon(4,circumscribedRadius(AaaD[IE]-1,4)),
            h=WALL_T,
            a=polyVertexAngle(AaaD[IR],AaaD[IE],4)
        ));

        // Third children placed at every triangle location
        // Can be anything else
        color("green")
        meshPolyhedron(meshFrustum(
            meshRegularPolygon(3,circumscribedRadius(AaaD[IE]-1,3)),
            h=WALL_T,
            a=polyVertexAngle(AaaD[IR],AaaD[IE],3)
        ));
    }
}

*
showParts();
