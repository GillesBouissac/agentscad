/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Pickaxe - cells for minecraft tool
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <agentscad/bevel.scad>
use <agentscad/mesh.scad>
use <agentscad/bevel.scad>

use <agentscad/things/pixeled/cap.scad>
use <agentscad/things/pixeled/nail.scad>
include <agentscad/things/pixeled/const.scad>


function cell_value( i, j, _p=0 ) =
    PARTS[_p][i][j] != VAL_EMPTY() ? PARTS[_p][i][j] :
    _p==len(PARTS)-1 ? VAL_EMPTY() : cell_value(i, j, _p+1)
;

module unicolorCell() {
    cube ( [ CELL_W, CELL_W, CELL_H ], center=true );
}

module bicolorCell() {
    difference() {
        cube (  [ CELL_W, CELL_W, CELL_H ], center=true );

        rotate ( [0,0,0] )
            capPassage();
        rotate ( [180,0,0] )
            capPassage();

        cube ( [ getCapGripWidth(), getCapGripWidth(), CELL_W], center=true );
    }
}

module partCells( part_layout, nails_layout, colors=[[],[]] ) {
    hy = floor(len(part_layout)/2);
    hx = floor(len(part_layout[0])/2);
    for ( i = [0:len(part_layout)-1] ) {
        for ( j = [0:len(part_layout[i])-1] ) {
            let ( val = part_layout[i][j] )
            if ( val>=0 ) {
                translate( [ (j-hx)*CELL_W, (hy-i)*CELL_W, 0 ] ) {
                    difference() {
                        color( getCellColor(colors, val) )
                        if ( isCellUnicolor(val) )
                            unicolorCell();
                        else
                            bicolorCell();
                        locateNailInCell(nails_layout[i][j])
                            nailPassagesLayer();
                    }
                }
            }
        }
    }
}


BEVEL_PROFILE = [
    [ +CELL_W/2, 0 ],
    [ +CELL_W/2, +getRadiusBevel() ],
    [ -CELL_W/2, +getRadiusBevel() ],
    [ -CELL_W/2, 0 ]
];

module bevelEdge() {
    rotate( [-90,0,0] )
    meshPolyhedron( meshExtrude(BEVEL_PROFILE, getRadiusBevel(), [undef, 0, getRadiusBevel()], [0, undef, -CELL_W/2]) );
}

module bevelCellSide() {
    translate( [0,-CELL_W/2,+CELL_H/2] )
        bevelEdge();
    translate( [0,-CELL_W/2,-CELL_H/2] )
        rotate( [0,180,0] )
        bevelEdge();
}

module bevelCell(data, i, j) {

    // top cell bevel
    if ( i==0 || data[i-1][j]==VAL_EMPTY() ) {
        rotate( [0,0,180] )
            bevelCellSide();
    }

    // bottom cell bevel
    if ( i==len(data)-1 || data[i+1][j]==VAL_EMPTY() ) {
        bevelCellSide();
    }

    // right cell bevel
    if ( j==len(data[i])-1 || data[i][j+1]==VAL_EMPTY() ) {
        rotate( [0,0,+90] )
            bevelCellSide();
    }

    // left cell bevel
    if ( j==0 || data[i][j-1]==VAL_EMPTY() ) {
        rotate( [0,0,-90] )
            bevelCellSide();
    }
}

module partBevel( part_layout, i, j) {
    if ( bevelActive() ) {
        hy = floor(len(part_layout)/2);
        hx = floor(len(part_layout[0])/2);
        for ( i = [0:len(part_layout)-1] )
            for ( j = [0:len(part_layout[i])-1] )
                if (part_layout[i][j]!=VAL_EMPTY())
                    translate( [ (j-hx)*CELL_W, (hy-i)*CELL_W, 0 ] )
                        bevelCell(part_layout, i, j);
    }
}
