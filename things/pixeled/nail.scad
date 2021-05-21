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

include <agentscad/things/pixeled/const.scad>

NAIL_GAP = 0.15;
NAIL_W = CELL_H/8-2*NAIL_GAP;
NAIL_PROFILE = meshRegularPolygon(8, NAIL_W/(2*cos(45/2)));
NAIL_PASSAGE_PROFILE = newMesh(wrinkle(getMeshVertices(NAIL_PROFILE), -NAIL_GAP, true), getMeshFaces(NAIL_PROFILE));

// Horizontal and Vertical nail never cross each other
NAIL_MARGIN_H = 0.1;
NAIL_MAX_H = CELL_H/4-NAIL_MARGIN_H;
NAIL_V_H = [+(NAIL_MAX_H-NAIL_W-2*layer()), -NAIL_MAX_H];
NAIL_H_H = [-(NAIL_MAX_H-NAIL_W-2*layer()), +NAIL_MAX_H];

module nail( l=NAIL_H ) {
    rotate( [-90,0,0] )
    rotate( [0,0,45/2] )
        meshPolyhedron( meshExtrude( getMeshVertices(NAIL_PROFILE), l ));
}
module nailPassage( l=NAIL_H ) {
    rotate( [-90,0,0] )
    rotate( [0,0,45/2] )
        meshPolyhedron( meshExtrude( getMeshVertices(NAIL_PASSAGE_PROFILE), l+2*gap() ));
}
module locateNailInLayer() {
    x = CELL_W/2 - NAIL_W/2 - 2*(nozzle()+0.1);
    translate ( [+x, 0, 0 ] )
        children();
    translate ( [-x, 0, 0 ] )
        children();
}
module nailPassagesLayer( l=NAIL_H ) {
    locateNailInLayer()
        nailPassage(l);
}
module nailsLayer( l=NAIL_H ) {
    locateNailInLayer()
        nail(l);
}

// Index in nails layouts arrays
IDX_TOP_NAILS = 0;
IDX_LFT_NAILS = 1;
IDX_BOT_NAILS = 2;
IDX_RGT_NAILS = 3;

function decomposeValues ( val, values, _i=0 ) = let (
    i = floor ( val / values[_i] ),
    r = val % values[_i],
    cr = concat ( [ i>0 ], _i<(len(values)-1) ? decomposeValues(r, values, _i+1) : [])
) cr;

module locateNailInCell( val ) {
    values = decomposeValues ( val, NAIL_VALS() );
    if ( values[IDX_TOP_NAILS] ) {
        translate ( [0, 0, NAIL_V_H[0] ] )
            children();
        translate ( [0, 0, NAIL_V_H[1] ] )
            children();
    }
    if ( values[IDX_LFT_NAILS] ) {
        translate ( [0, 0, NAIL_H_H[0] ] )
            rotate ( [0, 0, +90] ) children();
        translate ( [0, 0, NAIL_H_H[1] ] )
            rotate ( [0, 0, +90] ) children();
    }
    if ( values[IDX_BOT_NAILS] ) {
        translate ( [0, 0, NAIL_V_H[0] ] )
            rotate ( [0, 0, 180] ) children();
        translate ( [0, 0, NAIL_V_H[1] ] )
            rotate ( [0, 0, 180] ) children();
    }
    if ( values[IDX_RGT_NAILS] ) {
        translate ( [0, 0, NAIL_H_H[0] ] )
            rotate ( [0, 0, -90] ) children();
        translate ( [0, 0, NAIL_H_H[1] ] )
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
                translate( [ (j-hx)*CELL_W, (hy-i)*CELL_W, 0 ] ) {
                    color( getCellColor(colors, val) )
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
                translate( [ (j-hx)*CELL_W, (hy-i)*CELL_W, 0 ] ) {
                    locateNailInCell(nails_layout[i][j])
                        nailPassagesLayer();
                }
            }
        }
    }
}
