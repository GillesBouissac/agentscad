/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Glue shapes library test
 * Author:      Gilles Bouissac
 */
use <agentscad/glue.scad>

color( "gold" )
glue_circle ( $fn=200 );

translate( [0,0,20] )
rotate( [-30,0,0] )
difference() {
    translate( [0,0,5/2] )
        cube( [ 70, 70, 5 ], center=true );
#    glue_circle_receiver ( $fn=200 );
}

translate( [0,0,-20] )
rotate( [+30,0,0] )
difference() {
    translate( [0,0,-5/2] )
        cube( [ 70, 70, 5 ], center=true );
    glue_circle_receiver ( $fn=200 );
}

