/*
 * Copyright (c) 2_21, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Pickaxe - test layout
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

include <agentscad/things/pixeled/const.scad>
use <agentscad/things/pixeled/layout.scad>

/**
 * $part:
 *   ALL
 *   0: Cells only
 *   1: Caps only
 *   2: Nails only
 *
 *   3: Cells for printing
 *   4: Caps for printing
 *   5: Nails for printing
 * 
 * $subpart:
 *   ALL
 *   0: part 0
 *   1: part 1
 *   etc...
 *
 * $cut:
 *   true:  cut the figure to see internal structure (debug purpose)
 *   false: normal display (default)
 *
 */

// Selection of what to display
$part    = ALL;
$subpart = ALL;

// Beveling is essentially to counter first layer overextrusion
//   set this value to 0 to disable beveling
$bevel = 0.3;

layoutPixeledObject(TEST_CELLS(), TEST_NAILS(), TEST_COLORS());



VAL_PART1        = VAL_UNICOLOR_CELL(1);
VAL_PART1_SHINE  = VAL_BICOLOR_CELL(2);
VAL_PART2        = VAL_UNICOLOR_CELL(3);
VAL_PART2_SHINE  = VAL_BICOLOR_CELL(4);

COLOR_DARK_BROWN   = "#513c1a";
COLOR_LIGHT_BROWN = "#a3752d";
COLOR_DARK_TURQUOISE = "#20594b";
COLOR_LIGHT_TURQUOISE = "#32e8bf";

/**
 * Mapping from layout values to colors
 */
function TEST_COLORS() = [
[ // Cell color mapping: IDX_COLOR_CELL() array
    [ VAL_PART1,        COLOR_DARK_BROWN ],
    [ VAL_PART1_SHINE,  COLOR_DARK_BROWN ],
    [ VAL_PART2,        COLOR_DARK_TURQUOISE ],
    [ VAL_PART2_SHINE,  COLOR_DARK_TURQUOISE ]
],[ // Cap color mapping: IDX_COLOR_CAP() array
    [ VAL_PART1_SHINE,  COLOR_LIGHT_BROWN ],
    [ VAL_PART2_SHINE,  COLOR_LIGHT_TURQUOISE ]
]];

function TEST_CELLS() =
let (
    _ = VAL_EMPTY(),
    z = VAL_PART1,
    x = VAL_PART1_SHINE,
    m = VAL_PART2,
    o = VAL_PART2_SHINE
)
[[
    [ o,_ ],
    [ o,o ],
],[
    [ _,x ],
    [ _,_ ],
]];

function TEST_NAILS() =
let (
    _ = VAL_EMPTY(),
    r = VAL_NAIL_RGT(),
    x = VAL_NAIL_LFT() + VAL_NAIL_BOT(),
    I = VAL_NAIL_TOP() + VAL_NAIL_BOT()
)
[[
    [ r,_ ],
    [ _,I ],
],[
    [ _,x ],
    [ _,_ ],
]];
