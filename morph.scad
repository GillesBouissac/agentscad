/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Adaptation of morph function from openscad/list-comprehension-demos
 * Author:      Gilles Bouissac
 */
 
use <scad-utils/linalg.scad>
use <agentscad/extensions.scad>
use <list-comprehension-demos/skin.scad>
use <scad-utils/transformations.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// Morph two profile: Generates a succession of 'slices' profiles (=list of 3D points):
//   - The first one in the list is 'profile1'
//   - The last one in the list is 'profile2'
// speed: power factor of the x^speed curve: >1 we reach profile2 faster, <1 we reach profile2 slowlier
function morph ( profile1, profile2, slices=1, speed=1 ) =
let (
    profilelen = max(len(profile1),len(profile2)),
    profile1  = augment_profile(to_3d(profile1),profilelen),
    profile2  = augment_profile(to_3d(profile2),profilelen)
)[
for(index = [0:slices-1])
    interpolateProfile( profile1, profile2, index/(slices-1), speed )
];

// Morph two profile: Generates a succession of 'slices' profiles (=list of 3D points):
// The number of slices is the length of path_transforms
// Each slice is transformed using the current path_transforms[]
// This is a mix between morph and sweep
//   - The first one in the list is 'profile1'
//   - The last one in the list is 'profile2'
function morphpath(profile1, profile2, path_transforms, speed=1) = let(
    slices = len(path_transforms),
    profilelen = max(len(profile1),len(profile2)),
    profile1 = augment_profile(to_3d(profile1),profilelen),
    profile2 = augment_profile(to_3d(profile2),profilelen)
)[
for (index = [0:slices-1])
    transform(path_transforms[index], interpolateProfile(profile1, profile2, index/(slices-1),speed))
];

