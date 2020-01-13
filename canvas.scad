/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Canvas on which we can draw B&W images
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/mesh.scad>

//
// These tools works with folowing convensions:
// images are double array of levels in range [0:255] (0:black, 255:white):
//    - First  level of array = rows (first row is top of image)
//    - Second level of array = columns (first col is left of image)
//
// images don't have any dimension, just a list of points
//    dimensions comes with canvas
//
// example for a n*m image:
//    [
//       //row 0: top of image
//       [ <row_0/col_0>, <row_0/col_1> ... <row_0/col_n> ],
//       [ <row_1/col_0>, <row_1/col_1> ... <row_1/col_n> ],
//       ...
//       [ <row_m/col_0>, <row_m/col_1> ... <row_m/col_n> ],
//    ]
//

// ----------------------------------------
//           B&W Images
// ----------------------------------------

//
// Returns a sub-image of input image
//
//   image: image levels data
//   size:  size of sub-image to return, set to image size if undef
//   start: starting point of sub-image in image, set to [0,0] if undef
//
function imageCrop ( image, size=undef, start=undef ) = let (
    nx  = len(image[0]),
    ny  = len(image),
    sx  = forceValueInRange(start.x, minv=0, maxv=nx-2),
    sy  = forceValueInRange(start.y, minv=0, maxv=ny-2),
    ex  = forceValueInRange(size.x,  minv=1, maxv=nx-sx-1, defv=nx-sx-1) + sx,
    ey  = forceValueInRange(size.y,  minv=1, maxv=ny-sy-1, defv=ny-sy-1) + sy
) [ for ( y=[sy:ey] ) [ for ( x=[sx:ex] ) image[y][x] ] ];

//
// Interpolate image data to compute the level at random position
//
//   image:      image levels data
//   size:       size [size.x, size.y] of the image
//   pos:        position [pos.x, pos.y] in the image where we need the level
//   outerlevel: level to return if pos is not in the image
//
function getLevelAt( image, size, pos, outerlevel=255 ) = let (
    nx  = len(image[0]),
    ny  = len(image),
    ixc = floor( (nx-1-0.0001)*pos.x/size.x ),
    iyc = floor( (ny-1-0.0001)*pos.y/size.y ),
    ix  = ixc==nx-1?nx-2:ixc,
    iy  = iyc==ny-1?ny-2:iyc,
    dx  = size.x/(nx-1),
    dy  = size.y/(ny-1),
    x1  = ix*dx,
    y1  = iy*dy,
    x2  = x1 + dx,
    y2  = y1 + dy
) ix<0||iy<0||ix>nx-1||iy>ny-1?outerlevel:
    interpolateBilinear ( pos,
        [ x1, y1, image[iy][ix] ],
        [ x1, y2, image[iy+1][ix] ],
        [ x2, y1, image[iy][ix+1] ],
        [ x2, y2, image[iy+1][ix+1] ]
    );

//
// Draw an image on a given canvas and returns a new image
//
// Placement of the image in the canvas:
//   size: is the size [szx,szy] of the image in the canvas
//     set to canvas size if undef
//   start: top left point [x,y] of the image in the canvas
//     computed to center the image in the canvas if undef
//   preserve: controls aspect ratio:
//     if true either szx or szy is reduced in order to preserve
//     image aspect ratio in the canvas (assume each point in image is a square)
//   outerlevel: image level to pick for points of the canvas that are not in the image
//     and that do not have a previous value
//
function drawImage ( image, canvas, size=undef, start=undef, preserve=true, outerlevel=255 ) = let (
    nx     = len(image[0]),
    ny     = len(image),
    npx    = getCanvasNbPointx(canvas)-1,
    npy    = getCanvasNbPointy(canvas)-1,
    cansz  = getCanvasSize(canvas),
    pixsz  = getCanvasPixelSize(canvas),
    ratio  = nx/ny,
    tmpszx = forceValueInRange(size.x, minv=0, maxv=cansz.x, defv=cansz.x),
    tmpszy = forceValueInRange(size.y, minv=0, maxv=cansz.y, defv=cansz.y),
    xratio = tmpszy*ratio,
    yratio = tmpszx/ratio,
    szx    = preserve?(xratio<tmpszx?xratio:tmpszx):tmpszx,
    szy    = preserve?(yratio<tmpszy?yratio:tmpszy):tmpszy,
    cx     = forceValueInRange(start.x,minv=0,maxv=cansz.x-szx,defv=(cansz.x-szx)/2),
    cy     = forceValueInRange(start.y,minv=0,maxv=cansz.y-szy,defv=(cansz.y-szy)/2)
) [ cansz, pixsz, [
    for ( iy=[0:npy] ) [
        for ( ix=[0:npx] ) let (
                x = ix*pixsz.x,
                y = iy*pixsz.y
            )
            [ x, y, getLevelAt(image,[szx,szy],[x-cx,szy-(y-cy)],outerlevel=outerlevel) ]
        ]
    ]
];

// ----------------------------------------
//           Canvas
// ----------------------------------------

//
// Builds a mesh from canvas
// Assume canvas pixel data values are in range [0,255]
//
//   canvas: canvas filled with image
//
function canvas2mesh (
    canvas,
    minlayer=0.01,
    thickness=1,
    skin=false,
    positive=true
) = let (
    nx    = getCanvasNbPointx(canvas),
    ny    = getCanvasNbPointy(canvas),
    size  = getCanvasSize(canvas),
    image = getCanvasPoints(canvas),
    szx   = size.x,
    szy   = size.y,
    szz   = thickness,
    dx    = szx/(nx-1),
    dy    = szy/(ny-1),
    bix   = nx*ny, // idx of first base point
    lmin  = minlayer<0?0:minlayer,
    vertices = [
        // Curved upper surface
        for ( iy=[0:ny-1] )
            for ( ix=[0:nx-1] )
                let ( elevation = lmin + szz*(positive ? 1-image[iy][ix].z/255 : image[iy][ix].z/255 ))
                [ ix*dx, iy*dy, elevation ]
        ,
        // Flat lower surface
        if ( !skin )
            for ( iy=[0:ny-1] )
                for ( ix=[0:nx-1] )
                    [ ix*dx, iy*dy, 0 ]
    ],
    volumefaces = skin ? []:[
        // Lower surface
        for ( iy=[0:ny-2] )
            for ( ix=[0:nx-2] ) let ( idx=bix+iy*nx+ix )
                [ idx, idx+1, idx+1+nx, idx+nx ],
        // Top Wall
        for ( ix=[0:nx-2] ) let ( iup=ix, ilo=bix+iup )
            [ iup, iup+1, ilo+1, ilo ],
        // Right Wall
        for ( iy=[0:ny-2] ) let ( iup=(iy+1)*nx-1, ilo=bix+iup )
            [ iup, iup+nx, ilo+nx, ilo ],
        // Left Wall
        for ( iy=[0:ny-2] ) let ( iup=iy*nx, ilo=bix+iup )
            [ iup, ilo, ilo+nx, iup+nx ],
        // Bottom Wall
        for ( ix=[0:nx-2] ) let ( iup=ix+bix-nx, ilo=bix+iup )
            [ iup, ilo, ilo+1, iup+1 ]
    ],
    imageface = [
        // Upper surface
        for ( iy=[0:ny-2] )
            for ( ix=[0:nx-2] ) let ( idx=iy*nx+ix )
                [ idx, idx+nx, idx+1+nx, idx+1 ]
        ]
) newMesh ( vertices, concat( imageface, volumefaces ) );

//
// Creates a canvas
//   size:    Size [szx, szy] of the image in the canvas
//   nbpixel: Number of pixels [npx,npy] in the canvas
//   level:   Default level of the image in the canvas
//
function newCanvas ( size=undef, nbpixel=undef, level=255 ) = let (
    szx = forceValueInRange(size.x,1e-6),
    szy = forceValueInRange(size.y,1e-6),
    npx = forceValueInRange(nbpixel.x,1,1e6),
    npy = forceValueInRange(nbpixel.y,1,1e6),
    px  = szx/npx,
    py  = szy/npy
) [ [szx,szy], [px,py], [
    for ( iy=[0:npy] ) [
            for ( ix=[0:npx] ) let (
                x = ix*px,
                y = iy*py
            ) [ x, y, level ]
        ]
    ]
];

function getCanvasSize(canvas)       = canvas[0];
function getCanvasPixelSize(canvas)  = canvas[1];
function getCanvasPoints(canvas)     = canvas[2];
function getCanvasNbPointx(canvas)   = len(canvas[2][0]);
function getCanvasNbPointy(canvas)   = len(canvas[2]);



// ----------------------------------------
//           Showcase
// ----------------------------------------

module showLithophane() {
    levels = [
        [ 100, 90,   70, 140 ],
        [ 255, 160, 170,  45 ],
        [ 110, 120,  30, 140 ],
        [ 160, 170, 120,  60 ]
    ];
    canvas     = newCanvas( [10,10], [30,30] );
    image      = drawImage ( levels, canvas );
    lithophane = canvas2mesh( image, skin=false, thickness=10 );
    render() meshPolyhedron ( lithophane );
}

showLithophane();

