/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Shapes designed to glue parts avoiding supports
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <printing.scad>
use <extensions.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
module glue_circle ( d=CIRCLE_D, h=GLUE_H, g=GLUE_GRID, t=THICKNESS ) {
    ncircle = floor( d/(2*g) );
    diff_d  = d/ncircle;
    for ( i=[0:ncircle-1] )
        difference() {
            cylinder( r=diff_d/2+(i*diff_d)/2+t/2, h=h, center=true );
            cylinder( r=diff_d/2+(i*diff_d)/2-t/2, h=h+mfg(), center=true );
        }

    nradius = floor( PI*d/(2*g) );
    diff_a  = 360/nradius;
    step    = d / (is_undef($fn) ? 10: $fn) ;
    radius_profile = [
        for ( x=[0:step:d/2-diff_d/2] )
            [ diff_d/2+x, g/6*sin(x*180/(diff_d/2))+t/2 ],
        for ( x=[d/2-diff_d/2:-step:0] )
            [ diff_d/2+x, g/6*sin(x*180/(diff_d/2))-t/2 ]
    ];
    for ( i=[0:nradius] )
        rotate( [0,0,i*diff_a] )
            translate( [0,0,-h/2] )
            linear_extrude( height=h )
                polygon(radius_profile);
}

module glue_circle_receiver ( d=CIRCLE_D, h=GLUE_H, g=GLUE_GRID, t=THICKNESS ) {
    glue_circle( d, h+2*gap(), g, t+2*gap() );
}

// ----------------------------------------
//              Implementation
// ----------------------------------------
CIRCLE_D    = 50;
GLUE_GRID   = CIRCLE_D/6;
GLUE_H      = 4;
THICKNESS   = 3*nozzle()+0.05;

// ----------------------------------------
//                 Showcase
// ----------------------------------------
GLUE_D = 50;
GLUE_T = 1.6 ;

color( "gold" )
glue_circle ( GLUE_D, GLUE_T, $fn=200 );

translate( [0,0,20] )
rotate( [-30,0,0] )
difference() {
    translate( [0,0,5/2] )
        cube( [ 70, 70, 5 ], center=true );
#    glue_circle_receiver ( GLUE_D, GLUE_T, $fn=200 );
}

translate( [0,0,-20] )
rotate( [+30,0,0] )
difference() {
    translate( [0,0,-5/2] )
        cube( [ 70, 70, 5 ], center=true );
    glue_circle_receiver ( GLUE_D, GLUE_T, $fn=200 );
}

