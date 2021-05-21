/*
 * Copyright (c) 2_21, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Pickaxe - constants for minecraft tool
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

CELL_W = 25;
CELL_H = 20;
NAIL_H = CELL_W/2; // Height of an elementary nail in a cell

ALL = -1; // Used to render all parts or subparts

// Empty value in any layout
function VAL_EMPTY() = -1;

// Offset in layouts to specify one color cell (ie no cap)
VAL_UNICOLOR_CELL_FIRST = 000;
VAL_UNICOLOR_CELL_LAST  = 099;
function VAL_UNICOLOR_CELL(v) = VAL_UNICOLOR_CELL_FIRST+v;
function isCellUnicolor(v) = VAL_UNICOLOR_CELL_FIRST<=v && v<=VAL_UNICOLOR_CELL_LAST;

// Offset in layouts to specify bi color cell (ie with colored cap)
VAL_BICOLOR_CELL_FIRST = 100;
VAL_BICOLOR_CELL_LAST  = 199;
function VAL_BICOLOR_CELL(v) = VAL_BICOLOR_CELL_FIRST+v;
function isCellBicolor(v) = VAL_BICOLOR_CELL_FIRST<=v && v<=VAL_BICOLOR_CELL_LAST;

// Value in nails layout to tell there is a nail
function VAL_NAIL_TOP() = 8;
function VAL_NAIL_LFT() = 4;
function VAL_NAIL_BOT() = 2;
function VAL_NAIL_RGT() = 1;

// Values ordered from higher to lower
function NAIL_VALS() = [
    VAL_NAIL_TOP(),
    VAL_NAIL_LFT(),
    VAL_NAIL_BOT(),
    VAL_NAIL_RGT()
];

// Index in color mapping arrays
function IDX_COLOR_CELL() = 0;
function IDX_COLOR_CAP() = 1;

function getLayoutColor( mapping, v, _i=0 ) =
    mapping[_i][0]==v ? mapping[_i][1] :
    _i<len(mapping) ? getLayoutColor( mapping, v, _i+1 ) :
    "#FFFFFFFF"
;
function getCellColor( colors, v ) = getLayoutColor( colors[IDX_COLOR_CELL()], v );
function getCapColor( colors, v ) = getLayoutColor( colors[IDX_COLOR_CAP()], v );

