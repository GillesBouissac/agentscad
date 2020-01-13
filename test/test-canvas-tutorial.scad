/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Test canvas manipulations and rendering
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/mesh.scad>
use <agentscad/canvas.scad>

//
// Images sources:
//    Pinguin:       http://clipart-library.com/clipart/709738.htm
//
use <images/clipart-library-pinguin.scad>

// ----------------------------------------
//    API
// ----------------------------------------

// We use $fn for number of pixels to be able to have fast rendering
//   during design. We can set $fn to higher value for final rendering.
$fn=100;
showCase(8) {
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
SHOW_ITV_H   = 250;

module step_01() {
    // step_01 is about generating <myimage>.scad using
    // https://github.com/JustinSDK/img2gray
}

// 2: Simple Flat canvas
module step_02() {
    // Creates an empty canvas with dimension and number of pixels
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    // Load image levels
    pinguin    = levels_clipartlibrarypinguin();
    // Draw the image in the canvas
    canvas     = drawImage ( pinguin, empty );
    // Makes a 3D mesh with canvas
    flat       = canvas2mesh( canvas );

    // Render the mesh
    meshPolyhedron ( flat );
}

// 3: Scale image in canvas
module step_03() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();

    // Draw the image resized
    // preserves aspect ratio is on, these 3 method gives same result:
    // canvas     = drawImage ( pinguin, empty, size=[40,40] );
    // canvas     = drawImage ( pinguin, empty, size=[40,undef] );
    // canvas     = drawImage ( pinguin, empty, size=[40,<any number>] );
    // canvas     = drawImage ( pinguin, empty, size=[40] );
    // canvas     = drawImage ( pinguin, empty, size=[<any number>,40] );
    // The missing or incorrect value is ignored and recomputed
    canvas     = drawImage ( pinguin, empty, size=[150,40] );

    flat       = canvas2mesh( canvas );
    meshPolyhedron ( flat );
}

// 4: Preserve aspect ratio off
module step_04() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();

    // Draw the image resized, preserve aspect ratio is off
    // Now the image is squashed to fit the dimension specified
    canvas     = drawImage ( pinguin, empty, size=[150,40], preserve=false );

    flat       = canvas2mesh( canvas );
    meshPolyhedron ( flat );
}

// 5: Move image on canvas
module step_05() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();

    // Draw the image moved, preserve aspect ratio is on
    // Now the image is moved in the canvas at specified position
    canvas     = drawImage ( pinguin, empty, size=[40], start=[150,10] );

    flat = canvas2mesh( canvas );
    meshPolyhedron ( flat );
}

// 6: Crop image
module step_06() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();

    // Gets a small part of the image
    // Remember image 'y' goes from top to bottom
    eyes       = imageCrop( pinguin, size=[60,30], start=[20,15]);
    canvas     = drawImage ( eyes, empty );

    flat       = canvas2mesh( canvas );
    meshPolyhedron ( flat );
}

// 7: Set first layer thickness
module step_07() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();
    canvas     = drawImage ( pinguin, empty );

    // Specify a first layer thickness
    flat       = canvas2mesh( canvas, minlayer=10 );

    meshPolyhedron ( flat );
}

// 8: Set image thickness
module step_08() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();
    canvas     = drawImage ( pinguin, empty );

    // Specify image thickness
    flat       = canvas2mesh( canvas, thickness=10 );

    meshPolyhedron ( flat );
}

// 9: Only skin
module step_09() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();
    canvas     = drawImage ( pinguin, empty );

    // If we don't need base plate
    flat       = canvas2mesh( canvas, skin=true );

    meshPolyhedron ( flat );
}

// 10: Negative image
module step_10() {
    empty      = newCanvas( [200,100], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();
    canvas     = drawImage ( pinguin, empty );

    // Negative image
    flat       = canvas2mesh( canvas, positive=false );

    meshPolyhedron ( flat );
}

// 11: Projection on cylinder
module step_11() {

    // The canvas MUST have size [2,1] for correct projection on cylinder
    empty      = newCanvas( [2,1], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();
    canvas     = drawImage ( pinguin, empty );
    flat       = canvas2mesh( canvas );

    // Projection of the points on a cylinder
    // The cylinder can modify aspect ration as well
    // To prevent this must height=3.14*radius
    //    This is done by default if we don't give either radius or height
    projected  = projectCylinder( getMeshVertices(flat), radius=50 );
    bent       = newMesh( projected, getMeshFaces(flat) );
    meshPolyhedron ( bent );
}

// 12: Projection on sphere
module step_12() {

    // The canvas MUST have size [2,1] for correct projection on sphere
    empty      = newCanvas( [2,1], [2*$fn,$fn] );
    pinguin    = levels_clipartlibrarypinguin();

    // Reduce image to avoid ugly triangles on top of sphere
    // Everything we've seen (crop/scale/move/negative...) works
    //   works here as well
    canvas     = drawImage ( pinguin, empty, [undef,0.5] );
    
    // The sphere is a closed volume we only need the surface
    flat       = canvas2mesh( canvas, skin=true );

    // Projection of the points on a sphere
    projected  = projectSphereCylindrical( getMeshVertices(flat), radius=100 );
    bent       = newMesh( projected, getMeshFaces(flat) );
    meshPolyhedron ( bent );
}

// ----------------------------------------
//             Implementation
// ----------------------------------------

module showOneStep ( x=0 ) {
    translate([x-100,0,0])
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
            translate( [-5000,-5000,-5000] )
            cube( [10000,10000,10000] );
    }
}
