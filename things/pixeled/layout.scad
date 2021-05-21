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

use <agentscad/snap-joint.scad>
use <agentscad/printing.scad>
use <agentscad/extensions.scad>

use <agentscad/things/pixeled/cell.scad>
use <agentscad/things/pixeled/cap.scad>
use <agentscad/things/pixeled/nail.scad>
include <agentscad/things/pixeled/const.scad>

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

// Default parameters
$bevel   = 0.3;
$part    = ALL;
$subpart = ALL;
$cut     = true;

module layoutPixeledObject ( obj_parts, obj_nails, obj_colors ) {
    _parts   = is_undef( $part ) ? ALL : $part;
    _subpart = is_undef( $subpart ) ? ALL : $subpart;
    _cut     = is_undef( $cut ) ? false : $cut;
    difference() {
        layoutPixeledPart ( obj_parts, obj_nails, obj_colors, _parts, _subpart );
        if ( _cut ) {
            translate( [0,-500,0] )
                cube ( 1000, center=true );
        }
    }
}

module layoutPixeledPart( obj_parts, obj_nails, obj_colors, parts=ALL, subpart=ALL ) {
    
    if ( parts==ALL ) {
        layoutPixeledCells(obj_parts, obj_nails, obj_colors, subpart);
        layoutPixeledCaps(obj_parts, obj_nails, obj_colors, subpart);
        layoutPixeledNails(obj_parts, obj_nails, obj_colors, subpart);
    }

    if ( parts==0 ) {
        layoutPixeledCells(obj_parts, obj_nails, obj_colors, subpart);
    }

    if ( parts==1 ) {
        layoutPixeledCaps(obj_parts, obj_nails, obj_colors, subpart);
    }

    if ( parts==2 ) {
        layoutPixeledNails(obj_parts, obj_nails, obj_colors, subpart);
    }

    if ( parts==3 ) {
        layoutPixeledCells(obj_parts, obj_nails, obj_colors, subpart);
    }

    if ( parts==4 ) {
        layoutPixeledCapTypes(obj_parts, obj_nails, obj_colors);
    }

    if ( parts==5 ) {
        layoutPixeledNailTypes(obj_parts, obj_nails, obj_colors, subpart);
    }
}

module layoutPixeledCells(obj_parts, obj_nails, obj_colors, subpart) {
    parts = obj_parts;
    nails = obj_nails;
    if ( subpart==ALL )
        difference() {
            for ( i = [0:len(parts)-1] )
                difference() {
                    partCells(parts[i], nails[i], obj_colors);
                    partNailPassages(parts[i], nails[i]);
                    partBevel(parts[i]);
                }
        }
    else
        difference() {
            partCells(parts[subpart], nails[subpart], obj_colors);
            partNailPassages(parts[subpart], nails[subpart]);
            partBevel(parts[subpart]);
        }
}

module layoutPixeledCaps(obj_parts, obj_nails, obj_colors, subpart) {
    parts = obj_parts;
    if ( subpart==ALL )
        for ( p = parts )
            partCaps(p, obj_colors);
    else
        partCaps(parts[subpart], obj_colors);
}

module layoutPixeledNails(obj_parts, obj_nails, obj_colors, subpart) {
    parts = obj_parts;
    nails = obj_nails;
    if ( subpart==ALL )
        for ( i = [0:len(parts)-1] )
            partNails(parts[i], nails[i], obj_colors);
    else
        partNails(parts[subpart], nails[subpart], obj_colors);
}

module layoutPixeledCapTypes(obj_parts, obj_nails, obj_colors, subpart) {
    rotate( [180,0,0] )
        cap();
}

module layoutPixeledNailTypes(obj_parts, obj_nails, obj_colors, subpart) {
    if ( subpart==0 || subpart==ALL )
        nail ( 2*NAIL_H );
    if ( subpart==1 || subpart==ALL )
        translate( [CELL_W/2, 0, 0] )
        nail ( 3*NAIL_H );
    if ( subpart==2 || subpart==ALL )
        translate( [CELL_W, 0, 0] )
        nail ( 5*NAIL_H );
}
