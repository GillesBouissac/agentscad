/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Pickaxe - nails for minecraft tool
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/printing.scad>
use <agentscad/extensions.scad>
use <agentscad/mesh.scad>
use <agentscad/things/pixeled/const.scad>

function getNailGap() = 0.15;
function getNailW() = getPixelH()/8-2*getNailGap();
function getNailProfile() = meshRegularPolygon(8, getNailW()/(2*cos(45/2)));
function getNailPassageProfile() = newMesh(wrinkle(getMeshVertices(getNailProfile()), -getNailGap(), true), getMeshFaces(getNailProfile()));

// Horizontal and Vertical nail never cross each other
function getNailMarginH() = 0.1;
function getNailMaxH() = getPixelH()/4-getNailMarginH();
function getNailVH() = [+(getNailMaxH()-getNailW()-2*layer()), -getNailMaxH()];
function getNailHH() = [-(getNailMaxH()-getNailW()-2*layer()), +getNailMaxH()];

// Index in nails layouts arrays
IDX_TOP_NAILS = 0;
IDX_LFT_NAILS = 1;
IDX_BOT_NAILS = 2;
IDX_RGT_NAILS = 3;

module nail( l=getNailH() ) {
    rotate( [-90,0,0] )
    rotate( [0,0,45/2] )
        meshPolyhedron( meshExtrude( getMeshVertices(getNailProfile()), l ));
}
module nailPassage( l=getNailH() ) {
    rotate( [-90,0,0] )
    rotate( [0,0,45/2] )
        meshPolyhedron( meshExtrude( getMeshVertices(getNailPassageProfile()), l+2*gap() ));
}
module locateNailInLayer() {
    x = getPixelW()/2 - getNailW()/2 - 2*(nozzle()+0.1);
    translate ( [+x, 0, 0 ] )
        children();
    translate ( [-x, 0, 0 ] )
        children();
}
module nailPassagesLayer( l=getNailH() ) {
    locateNailInLayer()
        nailPassage(l);
}
module nailsLayer( l=getNailH() ) {
    locateNailInLayer()
        nail(l);
}

function decomposeValues ( val, values, _i=0 ) = let (
    i = floor ( val / values[_i] ),
    r = val % values[_i],
    cr = concat ( [ i>0 ], _i<(len(values)-1) ? decomposeValues(r, values, _i+1) : [])
) cr;

module locateNailInCell( val ) {
    values = decomposeValues ( val, NAIL_VALS() );
    if ( values[IDX_TOP_NAILS] ) {
        translate ( [0, 0, getNailVH()[0] ] )
            children();
        translate ( [0, 0, getNailVH()[1] ] )
            children();
    }
    if ( values[IDX_LFT_NAILS] ) {
        translate ( [0, 0, getNailHH()[0] ] )
            rotate ( [0, 0, +90] ) children();
        translate ( [0, 0, getNailHH()[1] ] )
            rotate ( [0, 0, +90] ) children();
    }
    if ( values[IDX_BOT_NAILS] ) {
        translate ( [0, 0, getNailVH()[0] ] )
            rotate ( [0, 0, 180] ) children();
        translate ( [0, 0, getNailVH()[1] ] )
            rotate ( [0, 0, 180] ) children();
    }
    if ( values[IDX_RGT_NAILS] ) {
        translate ( [0, 0, getNailHH()[0] ] )
            rotate ( [0, 0, -90] ) children();
        translate ( [0, 0, getNailHH()[1] ] )
            rotate ( [0, 0, -90] ) children();
    }
}

module partNails( part_layout, nails_layout, colors=[[],[]] ) {
    hy = floor(len(part_layout)/2);
    hx = floor(len(part_layout[0])/2);
    for ( i = [0:len(part_layout)-1] ) {
        for ( j = [0:len(part_layout[i])-1] ) {
            let ( val = part_layout[i][j] )
            if ( val>=0 ) {
                translate( [ (j-hx)*getPixelW(), (hy-i)*getPixelW(), 0 ] ) {
                    color( getPixelColor(colors, val) )
                        locateNailInCell(nails_layout[i][j])
                            nailsLayer();
                }
            }
        }
    }
}

module partNailPassages( part_layout, nails_layout ) {
    hy = floor(len(part_layout)/2);
    hx = floor(len(part_layout[0])/2);
    for ( i = [0:len(part_layout)-1] ) {
        for ( j = [0:len(part_layout[i])-1] ) {
            let ( val = part_layout[i][j] )
            if ( val>=0 ) {
                translate( [ (j-hx)*getPixelW(), (hy-i)*getPixelW(), 0 ] ) {
                    locateNailInCell(nails_layout[i][j])
                        nailPassagesLayer();
                }
            }
        }
    }
}
