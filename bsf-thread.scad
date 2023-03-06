/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: BSF thread modelisation
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/bsf-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Renders an external thread (for bolts)
module bsfThreadExternal ( screw, l=undef, f=true ) { libThreadExternal(screw,l,f); }

// Renders an internal thread (for nuts)
module bsfThreadInternal ( screw, l=undef, f=true, t=undef ) { libThreadInternal(screw,l,f,t); }

// Nut with Hexagonal head
module bsfNutHexagonalThreaded( screw, bt=true, bb=true ) { libNutHexagonalThreaded(screw,bt,bb); }

// Nut with Square head
module bsfNutSquareThreaded( screw, bt=true, bb=true ) { libNutSquareThreaded(screw,bt,bb); }

// Bolt with Hexagonal head
module bsfBoltHexagonalThreaded( screw, bt=true, bb=true ) { libBoltHexagonalThreaded(screw,bt,bb); }

// Bolt with Allen head
module bsfBoltAllenThreaded( screw, bt=true ) { libBoltAllenThreaded(screw,bt); }
