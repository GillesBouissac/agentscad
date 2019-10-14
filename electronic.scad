/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Electronic components
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <agentscad/printing.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
module led_5mm() {
    color( LED_OOLOR, 0.5 ) {
        cylinder( r=LED_D/2, h=LED_L-LED_D/2 );
        cylinder( r=LED_FLANGE_D/2, h=LED_FLANGE_L );
        translate( [0,0,-LED_PINS_H/2] )
            cube( [LED_PINS_W,LED_PINS_L,LED_PINS_H], center=true );
        translate( [0,0,LED_L-LED_D/2] )
            sphere(r=LED_D/2);
    }
}
module led_5mm_passage() {
    cylinder( r=LED_DP/2, h=LED_L-LED_D/2 );
    translate( [0,0,-LED_PINS_H-gap()] )
        cylinder( r=LED_FLANGE_DP/2, h=LED_PINS_H+LED_FLANGE_L+2*gap() );
    translate( [0,0,LED_L-LED_D/2] )
        sphere(r=LED_DP/2);
}
function getLed5mmFlangeD()  = LED_FLANGE_D;
function getLed5mmFlangeDP() = LED_FLANGE_DP;
function getLed5mmFlangeL()  = LED_FLANGE_L;
function getLed5mmD()        = LED_D;
function getLed5mmDP()       = LED_DP;
function getLed5mmL()        = LED_L;
function getLed5mmPinsW()    = LED_PINS_W;
function getLed5mmPinsL()    = LED_PINS_L;
function getLed5mmPinsH()    = LED_PINS_H;

// ----------------------------------------
//              Implementation
// ----------------------------------------
LED_D         = 5;
LED_L         = 9;
LED_DP        = LED_D+2*gap();
LED_FLANGE_D  = 5.6;
LED_FLANGE_DP = LED_FLANGE_D+2*gap();
LED_FLANGE_L  = 1;
LED_PINS_W    = 1.4;
LED_PINS_L    = 4.6;
LED_PINS_H    = 10;
LED_OOLOR     = "#aa6";


// ----------------------------------------
//                Showcase
// ----------------------------------------
PRECISION  = 50;

led_5mm($fn=PRECISION);
#led_5mm_passage($fn=PRECISION);



