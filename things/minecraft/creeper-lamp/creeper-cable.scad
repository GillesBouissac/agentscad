    /*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - cable passage
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <scad-utils/transformations.scad>
use <list-comprehension-demos/sweep.scad>
include <cable_path_svg.scad>
include <creeper-const.scad>


/**
 * Cable passage
 */
module cablePassage() {
    rotate( [0,0,90] )
        sweep(normalizedCableProfile, path_transforms);
}

/**
 * Cable cut to show the inside
 */
module cableCut() {
    rotate( [0,0,90] )
        sweep(cutProfile, path_transforms);
}

cutProfile = [
    [0, 0],
    [0, -HEAD_W],
    [-HEAD_W, -HEAD_W],
    [-HEAD_W, 0],
];

normalizedCablePathSide = [
    for(pt = cablePathSide_0_points)
        [pt.x - 67.5, 0, 142 - pt.y]
];
normalizedCablePathFront = [
    for(pt = cablePathFront_0_points)
        [77 + pt.x, 0, 142 - pt.y]
];
normalizedCableProfile = [
    for(pt = cableProfile_0_points)
        [ pt.x - cableProfile_0_center.x, cableProfile_0_center.y - pt.y]
];

/**
 * assume line is such that:
 *   len(list) >= 2
 *   list[i].z <= list[i+1].z
 */
function indexForZ ( line, z, _i=-1 ) =
    _i>=len(line)-1 ? _i :
    line[_i+1].z >= z ? _i :
    indexForZ( line, z, _i+1 )
;

function interpolatey(pt0, pt1, z) =
    let(
        n = (pt1.z-pt0.z)/(z-pt0.z)
    ) (pt1.x-pt0.x)/n + pt0.x
;

function interpolatexFromPathSide(z) =
    let(
        i = indexForZ(normalizedCablePathSide, z)
    ) interpolatey( normalizedCablePathSide[i], normalizedCablePathSide[i+1], z )
;

function cablePath() = [
    for(pt = normalizedCablePathFront)
        [pt.x,interpolatexFromPathSide(pt.z),pt.z]
];

path_transforms = construct_transform_path ( cablePath() );
