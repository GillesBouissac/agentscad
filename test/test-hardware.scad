/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Test hardware modules
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/hardware.scad>


PRECISION  = 200;
SEPARATION = 0;

module show_er() {
    collets_min = [ // Minimum printable dimensions with default prinable settings
        newER8(1), newER11(1), newER16(1), newER20(1),
        newER25(1),  newER32(2),   newER40(3),   newER50(6)
    ];
    collets_max = [ // Maximum printable dimensions with default prinable settings
        newER8(4), newER11(6.5),   newER16(10),  newER20(13),
        newER25(16), newER32(20),  newER40(26),  newER50(34)
    ];

    YER = -50;
    YERMAX = -110;
    YPASS = 10;
    offsetx = columnSum(collets_min,3)/2;
    for ( i=[0:len(collets_min)-1] ) let(
        x  = columnSum(collets_min,3,0,i),
        col = collets_min[i],
        colmax = collets_max[i]
    ) {
        translate([x-offsetx,YER,0])
            ERCollet(col);
        translate([x-offsetx,YERMAX,0])
            ERCollet(colmax);
        color( "gold" )
            translate([x-offsetx,YER,ERColletGetL(col)+5])
            rotate ( [90,0,0] )
            linear_extrude(1)
            text(ERColletGetName(col), halign="center", valign="center", size=3, $fn=100 );
        color("lime")
            translate([x-offsetx,YPASS,0]) ERColletPassage(col);
        color("blue")
            translate([x-offsetx,YER,0]) ERColletExtractorRing(col);
    }
}

module show_parts( part=0, cut=undef, cut_rotation=undef ) {
    zip   = newZipTie2_5();
    zipu1 = makeZipU( zip, 20 );
    zipu2 = makeZipU( zip, 10, 5 );
    zipo1 = makeZipOblong( zip, 1.5, 3 );

    if ( part==0 ) {
        intersection () {
            union() {
                zipShape ( zipu1 );
                rotate( [0,90,0] )
                    zipShape ( zipo1 );
                translate( [0, 0, 2])
                    difference() {
                        zipConduitShape ( zipu2 );
                        zipConduitHollow( zipu2 );
                    }
                }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
        color( "#fff" )
            translate( [0, 0, 2])
            zipShape ( zipu2 );
        show_er();
    }

    if ( part==1 ) {
        #zipShapePassage ( zipu2, $gap=1 );
        zipShape ( zipu2 );
    }
    if ( part==2 ) {
        #zipShapePassage ( zipo1 );
        zipShape ( zipo1 );
    }
    if ( part==3 ) {
        difference() {
            zipConduitShape( zipu2 );
            zipConduitHollow( zipu2 );
        }
        zipShape ( zipu2 );
    }
    if ( part==4 ) {
        show_er();
    }
}

// 0: all
// 1: zip U shape
// 2: zip Obblong shape
// 3: zip U shape conduit
// 4: ER Collets
show_parts ( 4, 0, -90, $fn=PRECISION );


