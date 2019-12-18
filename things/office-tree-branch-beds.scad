/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Render beds for printing branches
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <office-tree.scad>

// ----------------------------------------
//                API
// ----------------------------------------

// part:   bed number [0-9]
// $layer: will be printed with 0.3mm layers
showCase ( part=3, $fn=PRECISION, $layer=0.3 );


// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION = 100;

BEDS = [
    [   // BED 0
        [ 00, [ -65, -20],   0 ],
        [ 44, [ 102, -42], -60 ],
        [ 43, [  60, -42], -60 ],
        [ 42, [  10, -42], -60 ],
        [ 41, [  30, -92], 165 ],
        [ 40, [  74,  27],  60 ],
        [ 39, [ -33, -88],  90 ],
        [ 38, [ -68, -51], -90 ],
        [ 37, [-100, -76],  90 ],
        [ 36, [  98,  80], 182 ],
        [ 35, [  18,   8],  75 ],
        [ 34, [  15,  80], 184 ],
        [ 33, [ -10,  30],-170 ],
        [ 32, [-100,  20],  70 ],
    ],
    [   // BED 1
        [ 01, [ -60, -01],   0 ],
        [ 31, [  19, -25], -80 ],
        [ 30, [ -35, -23], -80 ],
        [ 29, [ -95, -15], -80 ],
        [ 28, [  52,  80],-170 ],
        [ 27, [-110,  90], -52 ],
    ],
    [   // BED 2
        [ 02, [ -50, -85],  30 ],
        [ 03, [  50,  85],-150 ],
    ],
    [   // BED 3
        [ 04, [ -50, -85],  30 ],
        [ 05, [  50,  85],-150 ],
    ],
    [   // BED 4
        [ 06, [ -40, -85],  30 ],
        [ 07, [  45,  75],-150 ],
    ],
    [   // BED 5
        [ 08, [ -30, -90],  30 ],
        [ 09, [  25,  50],-150 ],
        [ 26, [  25,  85], -25 ],
    ],
    [   // BED 6
        [ 10, [ -22, -90],  30 ],
        [ 11, [  20,  20],-150 ],
        [ 25, [  22,  85], -20 ],
        [ 24, [   7,  60],-177 ],
    ],
    [   // BED 7
        [ 12, [ -22, -85],  26 ],
        [ 13, [  18,  18],-150 ],
        [ 23, [  15,  70], -10 ],
        [ 22, [ -10,  90],-145 ],
    ],
    [   // BED 8
        [ 14, [ -18, -90],  26 ],
        [ 15, [  10, -23],-174 ],
        [ 21, [  12,  68], -10 ],
        [ 20, [  27,  00], 145 ],
    ],
    [   // BED 9
        [ 16, [ -10, -90],  26 ],
        [ 17, [   3, -30],-174 ],
        [ 19, [   3,  75], -17 ],
        [ 18, [  30,  -8], 145 ],
    ],
];

BRANCH_NB = getBranchNb();

module showCase ( part ) {
        // Checks that:
        //   we missed no branch
        //   we didn't ask to print a branch twice
        //   we didn't ask to print an unexisting branch
        branches = [ for ( i=[0:BRANCH_NB-1] ) i ];
        declared = sortNum([
            for ( bed=BEDS )
                for ( b=bed )
                    b[0]
        ]);
        missing = [
            for ( b=branches )
                let(
                    found = search ( b, declared )
                ) if ( len(found)==0) b
        ];
        if ( len(missing)>0 ) {
            error = str("WARNING - branches not declared in any bed: ", missing);
            translate( [-printVolume().x/2,printVolume().y/2+5,0] ) text( error );
        }
        unknown = [
            for ( d=declared )
                let(
                    found = search ( d, branches )
                ) if ( len(found)==0) d
        ];
        if ( len(unknown)>0 ) {
            error = str("WARNING - unknown branches declared: ", unknown);
            translate( [-printVolume().x/2,printVolume().y/2+25,0] ) text( error );
        }
        duplicates = [
            for ( b=branches )
                let(
                    found = search ( b, declared, 0 )
                ) if ( len(found)>1) b
        ];
        if ( len(duplicates)>0 ) {
            error = str("WARNING - duplicates branches declared: ", duplicates);
            translate( [-printVolume().x/2,printVolume().y/2+45,0] ) text( error );
        }

        // Print beds for branches, sub_parts are bed numbers
        % translate([0,0,-1])
            cube( [ printVolume().x, printVolume().y, 1 ], center=true );

        // Print required bed
        for ( b=BEDS[part] )
            translate( b[1] ) {
                %translate( [0,0,40] )
                    color( "yellow" )
                    text( str(b[0]), halign="center" );
                rotate( [0,0,is_undef(b[2])?0:b[2]] )
                    branch( b[0] );
            }
}
