/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Metric screw modelisation
 * Author:      Gilles Bouissac
 */
use <../mx-screw.scad>

// ----------------------------------------
//          Animation params:
//            fps:   10
//            steps: 100
// ----------------------------------------

ALL_SCREW  = [for ( idx=[0:mxGetDataLength()-1] ) mxData( idx ) ];

// Modulo
function mod(a,m) = a - m*floor(a/m);
module showcaseAnimated() {

    translate( [0,0,0] ) {

        idx=floor($t*len(ALL_SCREW));
        screw = ALL_SCREW[idx];

        translate( [1.5*mxGetHeadDP(screw),0,4*mxGetHeadLP(screw)] )
            color( "gold" )
            rotate( $vpr )
            linear_extrude(1)
            text( mxGetName(screw), halign="center", valign="center", size=mxGetThreadD(screw) );
        rotate( [180,0,0] )
        translate( [0,mxGetHeadDP(screw)/1.5,0] ) {
            translate( [3*mxGetHeadDP(screw),0,0] ) {
                color( "red", 0.5 )
                    mxBoltPassage( screw, 3 );
                translate( [0,0,+mxGetThreadL(screw)-mxGetHeadLP(screw)/2] )
                    color( "silver", 0.5 )
                    mxNutPassage( screw );
            }
            translate( [1.5*mxGetHeadDP(screw),0,0] ) {
                color( "red", 0.5 )
                    mxBoltAllenPassage( screw, 3 );
                translate( [0,0,+mxGetThreadL(screw)-mxGetHeadLP(screw)/2] )
                    color( "silver", 0.5 )
                    mxNutPassage( screw );
            }
            mxBoltAllen( screw );
            translate( [0,0,+mxGetThreadL(screw)-mxGetSquareHeadL(screw)/2] )
                color( "cyan", 0.5 )
                mxNutSquare( screw );
        }
        rotate( [180,0,0] )
        translate( [0,-mxGetHeadDP(screw)/1.5,0] ) {
            translate( [3*mxGetHeadDP(screw),0,0] ) {
                color( "red", 0.5 )
                    mxBoltPassage( screw, 3 );
                translate( [0,0,+mxGetThreadL(screw)-mxGetHeadLP(screw)/2] )
                    color( "silver", 0.5 )
                    mxNutPassage( screw );
            }
            translate( [1.5*mxGetHeadDP(screw),0,0] ) {
                color( "red", 0.5 )
                    mxBoltHexagonalPassage( screw, 3 );
                translate( [0,0,+mxGetThreadL(screw)-mxGetHeadLP(screw)/2] )
                    color( "silver", 0.5 )
                    mxNutPassage( screw );
            }
            mxBoltHexagonal( screw );
            translate( [0,0,+mxGetThreadL(screw)-mxGetSquareHeadL(screw)/2] )
                color( "cyan", 0.5 )
                mxNutHexagonal( screw );
        }
    }
}

showcaseAnimated ($fn=100);

