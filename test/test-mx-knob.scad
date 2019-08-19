/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Knob modelisation
 * Author:      Gilles Bouissac
 */

use <../mx-knob.scad>
use <../mx-screw.scad>

// ----------------------------------------
//
//    Showcase
//
// ----------------------------------------

module mxKnobTest() {
    translate([+60,+30,0]) {
        mxKnob ( M12(), 50, 30 );
        %mxScrewHexagonal ( M12() );
    }
    translate([+15,+50,0])
    rotate( [90,0,0] ) {
        mxKnob ( M6(), 25, 20, part=0 );
        #mxScrewHexagonal ( M6() );
    }
    translate([-15,+30,0]) {
        mxKnob ( M1_6(tlp=3), 15, 15, part=0 );
        %mxScrewHexagonal ( M1_6() );
    }

    translate([+60,-30,0]) {
        mxKnob ( M12() );
        %mxScrewHexagonal ( M12() );
    }
    translate([+15,-30,0]) {
        mxKnob ( M6(), part=1 );
        mxKnob ( M6(), part=3 );
        %mxScrewHexagonal ( M6() );
    }
    translate([-15,-30,0]) {
        mxKnob ( M1_6(tlp=3) );
        %mxScrewHexagonal ( M1_6() );
    }
}
mxKnobTest($fn=100);
