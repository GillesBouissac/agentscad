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
//   - Every intermediate profile 'n-1' is closer to 'profile1' than profile 'n'
//   - Every intermediate profile 'n'   is closer to 'profile2' than profile 'n-1'
// zenith is a point far from the shape that will be used to reorder points in profiles before morphing
function morph ( profile1, profile2, slices=1, zenith=[0,100000] ) =
let (
    aug_profile1  = augment_profile(to_3d(profile1),max(len(profile1),len(profile2))),
    aug_profile2  = augment_profile(to_3d(profile2),max(len(profile1),len(profile2))),
    turn_profile1 = faceTheZenith(aug_profile1,zenith),
    turn_profile2 = faceTheZenith(aug_profile2,zenith)
) morphImpl (
	turn_profile1,
	turn_profile2,
	slices
);

// ----------------------------------------
//              Implementation
// ----------------------------------------
function morphImpl ( profile1, profile2, slices=1 ) = [
	for(index = [0:slices-1])
		interpolateProfile(profile1, profile2, index/(slices-1) )
];

// ----------------------------------------
//                 Showcase
// ----------------------------------------


