/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Pickaxe - main file
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

layoutPixeledObject(PICKAXE_CELLS(), PICKAXE_NAILS(), PICKAXE_COLORS());


COLOR_DARK_BROWN   = "#513c1a";
COLOR_LIGHT_BROWN = "#a3752d";
COLOR_DARK_TURQUOISE = "#20594b";
COLOR_LIGHT_TURQUOISE = "#32e8bf";

VAL_STICK        = VAL_UNICOLOR_CELL(1);
VAL_STICK_SHINE  = VAL_BICOLOR_CELL(2);
VAL_BLADE        = VAL_UNICOLOR_CELL(3);
VAL_BLADE_SHINE  = VAL_BICOLOR_CELL(4);

/**
 * Mapping from layout values to colors
 */
function PICKAXE_COLORS() = [
[ // Cell color mapping: IDX_COLOR_CELL() array
    [ VAL_STICK,        COLOR_DARK_BROWN ],
    [ VAL_STICK_SHINE,  COLOR_DARK_BROWN ],
    [ VAL_BLADE,        COLOR_DARK_TURQUOISE ],
    [ VAL_BLADE_SHINE,  COLOR_DARK_TURQUOISE ]
],[ // Cap color mapping: IDX_COLOR_CAP() array
    [ VAL_STICK_SHINE,  COLOR_LIGHT_BROWN ],
    [ VAL_BLADE_SHINE,  COLOR_LIGHT_TURQUOISE ]
]];

/**
 *
 * Shape colors positions
 *   Splited in printable parts
 *
 */
function PICKAXE_CELLS() =
[
    BLADE1_CELLS, BLADE2_CELLS, BLADE3_CELLS,
    STICK1_CELLS, STICK2_CELLS, STICK3_CELLS
];

function PICKAXE_NAILS() =
[
    BLADE1_NAILS, BLADE2_NAILS, BLADE3_NAILS,
    STICK1_NAILS, STICK2_NAILS, STICK3_NAILS
];


_ = VAL_EMPTY();

/* ------------------------------------------------------------
 *
 *    Blade part 1/3
 *
 * ------------------------------------------------------------ */
BLADE1_CELLS = let (
    m = VAL_BLADE,
    o = VAL_BLADE_SHINE
) [
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,m,_,_,_,_,_,_,_,_,_,_,_ ],
    [ m,o,m,_,_,_,_,_,_,_,_,_,_ ],
    [ m,o,m,_,_,_,_,_,_,_,_,_,_ ],
    [ m,o,m,_,_,_,_,_,_,_,_,_,_ ],
    [ m,o,m,_,_,_,_,_,_,_,_,_,_ ],
    [ m,o,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

BLADE1_NAILS = let (
    a = VAL_NAIL_BOT(),
    b = VAL_NAIL_LFT() + VAL_NAIL_RGT(),
    c = VAL_NAIL_BOT() + VAL_NAIL_LFT() + VAL_NAIL_RGT()
)
[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,a,_,_,_,_,_,_,_,_,_,_ ],
    [ b,c,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

/* ------------------------------------------------------------
 *
 *    Blade part 2/3
 *
 * ------------------------------------------------------------ */
BLADE2_CELLS = let (
    m = VAL_BLADE,
    o = VAL_BLADE_SHINE
) [
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,m,m,m,m,_,_,_,_ ],
    [ _,_,_,_,o,o,o,o,o,m,_,_,_ ],
    [ _,_,_,_,m,m,m,m,m,_,_,_,_ ],
];

BLADE2_NAILS = let (
    a = VAL_NAIL_LFT(),
    b = VAL_NAIL_TOP() + VAL_NAIL_BOT(),
    c = VAL_NAIL_LFT() + VAL_NAIL_TOP() + VAL_NAIL_BOT()
)
[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,a,_,_,_,_,_,_,_ ],
    [ _,_,_,_,c,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,b,_,_,_,_,_,_,_,_ ],
];

/* ------------------------------------------------------------
 *
 *    Blade part 3/3
 *
 * ------------------------------------------------------------ */
BLADE3_CELLS = let (
    m = VAL_BLADE,
    o = VAL_BLADE_SHINE
)[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,o,_,_,_,_,_,_,_,_,_,_ ],
    [ _,m,o,o,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,o,o,_,_,_,_,_,_,_,_ ],
    [ _,_,_,m,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

BLADE3_NAILS = let (
    a = VAL_NAIL_BOT(),
    b = VAL_NAIL_BOT() + VAL_NAIL_TOP(),
    c = VAL_NAIL_TOP() + VAL_NAIL_LFT() + VAL_NAIL_RGT(),
    x = VAL_NAIL_TOP() + VAL_NAIL_RGT(),
    d = VAL_NAIL_LFT(),
    e = VAL_NAIL_LFT() + VAL_NAIL_RGT(),
    f = VAL_NAIL_RGT() + VAL_NAIL_TOP() + VAL_NAIL_BOT()
)
[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,c,_,_,_,_,_,_,_,_,_,_ ],
    [ _,b,a,x,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,d,f,_,_,_,_,_,_,_,_ ],
    [ _,_,_,e,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

/* ------------------------------------------------------------
 *
 *    Stick part 1/3
 *
 * ------------------------------------------------------------ */
STICK1_CELLS = let (
    m = VAL_STICK,
    o = VAL_STICK_SHINE
)[
    [ _,_,_,_,_,_,_,_,_,_,_,m,o ],
    [ _,_,_,_,_,_,_,_,_,_,m,o,m ],
    [ _,_,_,_,_,_,_,_,_,m,o,m,_ ],
    [ _,_,_,_,_,_,_,_,m,o,m,_,_ ],
    [ _,_,_,_,_,_,_,m,o,m,_,_,_ ],
    [ _,_,_,_,_,_,_,_,m,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

STICK1_NAILS = let (
    a = VAL_NAIL_BOT(),
    b = VAL_NAIL_LFT() + VAL_NAIL_RGT()
)
[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,a,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,b,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

/* ------------------------------------------------------------
 *
 *    Stick part 2/3
 *
 * ------------------------------------------------------------ */
STICK2_CELLS = let (
    m = VAL_STICK,
    o = VAL_STICK_SHINE
)[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,m,o,_,_,_,_,_ ],
    [ _,_,_,_,_,m,o,m,_,_,_,_,_ ],
    [ _,_,_,_,m,o,m,_,_,_,_,_,_ ],
    [ _,_,_,m,o,m,_,_,_,_,_,_,_ ],
    [ _,_,_,_,m,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

STICK2_NAILS = let (
    a = VAL_NAIL_TOP() + VAL_NAIL_RGT(),
    b = VAL_NAIL_BOT() + VAL_NAIL_LFT(),
    c = VAL_NAIL_BOT() + VAL_NAIL_LFT() + VAL_NAIL_RGT()
)
[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,a,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,b,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,c,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

/* ------------------------------------------------------------
 *
 *    Stick part 3/3
 *
 * ------------------------------------------------------------ */
STICK3_CELLS = let (
    m = VAL_STICK,
    o = VAL_STICK_SHINE
)[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,m,o,_,_,_,_,_,_,_,_,_,_ ],
    [ _,o,m,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];

STICK3_NAILS = let (
    a = VAL_NAIL_TOP() + VAL_NAIL_BOT(),
    b = VAL_NAIL_TOP() + VAL_NAIL_BOT() + VAL_NAIL_RGT()
)
[
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
    [ _,a,b,_,_,_,_,_,_,_,_,_,_ ],
    [ _,a,b,_,_,_,_,_,_,_,_,_,_ ],
    [ _,_,_,_,_,_,_,_,_,_,_,_,_ ],
];
