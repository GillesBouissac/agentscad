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
//    Turtle:       http://clipart-library.com/clipart/kTMnaXbMc.htm
//    Morris Minor: https://pixabay.com/fr/photos/morris-minor-limousine-oldtimer-4754082/
//
use <images/clipart-library-pinguin.scad>
use <images/pixabay-morris-minor.scad>

pinguin = levels_clipartlibrarypinguin();
module showPlane(preserve=true, moved=false, resized=false) {
    canvas = newCanvas( [200,100], [200,100] );
    image  = drawImage ( pinguin, canvas,
        size=resized?[100,50]:undef, start=moved?[90,40]:undef, preserve=preserve );
    mesh   = canvas2mesh( image, skin=false, thickness=5 );
    projected  = getMeshVertices(mesh);
    lithophane = newMesh(projected,getMeshFaces(mesh));
    //render()
    meshPolyhedron ( lithophane );
}
module showSphereFull( skin=true, positive=true, resized=false ) {
    // If image size is reduced we need more pixels in the canvas
    canvas = newCanvas( [2,1], resized?[400,200]:[200,100] );
    image  = drawImage ( pinguin, canvas, size=resized?[undef,0.5]:undef );
    mesh   = canvas2mesh( image, skin=skin, positive=positive, thickness=10 );
    projected  = projectSphereCylindrical( getMeshVertices(mesh), 100 );
    lithophane = newMesh(projected,getMeshFaces(mesh));
    // render()
    meshPolyhedron ( lithophane );
}
module showSphereCrop(preserve=true) {
    levels = imageCrop(pinguin, [40,40], [43,66]);
    canvas = newCanvas( [2,1], [200,100] );
    image  = drawImage ( levels, canvas, size=[1,0.5], preserve=preserve );
    mesh   = canvas2mesh( image, skin=true, thickness=10 );
    projected  = projectSphereCylindrical( getMeshVertices(mesh), 100 );
    lithophane = newMesh(projected,getMeshFaces(mesh));
    // render()
    meshPolyhedron ( lithophane );
}
module showCylinder() {
    canvas = newCanvas( [2,1], [200,100] );
    image  = drawImage ( pinguin, canvas );
    mesh   = canvas2mesh( image, skin=false, thickness=10 );
    projected  = projectCylinder( getMeshVertices(mesh), 100, 314 );
    lithophane = newMesh(projected,getMeshFaces(mesh));
    // render()
    meshPolyhedron ( lithophane );
}
module showBigShere() {
    levels = levels_pixabaymorrisminor();
    canvas = newCanvas( [2,1], [600,300] );
    image  = drawImage ( levels, canvas, size=[undef,0.4] );
    mesh   = canvas2mesh( image, skin=true, thickness=5 );
    projected  = projectSphereCylindrical( getMeshVertices(mesh), 100 );
    lithophane = newMesh(projected,getMeshFaces(mesh));
    // render()
    meshPolyhedron ( lithophane );
}
module showText( t ) {
    %
    for ( i=[0:len(t)-1] )
        translate( [0,0,-150-i*40] )
            rotate( [90,0,0] )
            color( "gold" )
            linear_extrude ( height=1 )
                text( t[i], halign="center", size=30-i*3 );
}
translate ( [000,0,0] ) {
    rotate( [90,0,0] )
        translate ( [-100,-50,0] )
        showPlane();
    showText( [ "Plane", "thick", "positive", "preserve on" ] );
}
translate ( [300,0,0] ) {
    rotate( [90,0,0] )
        translate ( [-100,-50,0] )
        showPlane(resized=true,moved=true,preserve=false);
    showText( [ "Plane", "resize", "move", "preserve off", "thick", "positive" ] );
}
translate ( [600,0,0] ) {
    rotate( [0,0,90]  )
        scale( 0.7 )
        showCylinder();
    showText( [ "Cylinder", "thick", "positive", "preserve on" ] );
}
translate ( [900,0,0] ) {
    rotate( [0,0,90]  )
        showSphereFull(skin=true);
    showText( [ "Sphere", "positive", "preserve on", "skin" ] );
}
translate ( [1200,0,0] ) {
    rotate( [0,0,90]  )
        showSphereFull(skin=true,positive=false);
    showText( [ "Sphere", "negative", "preserve on", "skin" ] );
}
translate ( [1500,0,0] ) {
    rotate( [0,0,90]  )
        showSphereFull(skin=true,resized=true);
    showText( [ "Sphere", "resize", "preserve on", "skin", "positive" ] );
}
translate ( [1800,0,0] ) {
    rotate( [0,0,90]  )
        showSphereCrop();
    showText( [ "Sphere", "crop", "resize", "preserve on", "skin", "positive" ] );
}
translate ( [2100,0,0] ) {
    rotate( [0,0,90]  )
        showSphereCrop(preserve=false);
    showText( [ "Sphere", "preserve off", "crop", "resize", "skin", "positive" ] );
}
translate ( [1000,1000,800] ) {
    scale( [10,10,10] )
    rotate( [0,0,90]  )
        showBigShere();
}


