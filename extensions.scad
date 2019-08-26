/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: OpenSCAD extensions to scad language
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/linalg.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// Render children modules with mirroring on plane [XZ]
//   Each child is rendered 2 times
module mirrorX( mirrorx=true ) {
    mirror([0, 0, 0])
        children();
    if ( mirrorx )
        mirror([0, 1, 0])
            children();
}

// Render children modules with mirroring on plane [YZ]
//   Each child is rendered 2 times
module mirrorY( mirrory=true ) {
    mirror([0, 0, 0])
        children();
    if ( mirrory )
        mirror([1, 0, 0])
            children();
}

// Render children modules with mirroring on plane [XY]
//   Each child is rendered 2 times
module mirrorZ( mirrorz=true ) {
    mirror([0, 0, 0])
        children();
    if ( mirrorz )
        mirror([0, 0, 1])
            children();
}

// Render children modules with mirroring on X then mirroring on Y
//   Each child is rendered 4 times
module mirrorXY( mirrorx=true, mirrory=true ) {
    mirrorY(mirrory)
        mirrorX(mirrorx)
            children();
}

// flatten([[0,1],[2,3]]) => [0,1,2,3]
function flatten(list) = [ for (i = list, v = i) v ];

// ManiFold Guard
MFG = 0.01;
function mfg(mult=1) = is_undef($mfg) ? mult*MFG : mult*$mfg;

// Modulo
function mod(a,m) = a - m*floor(a/m);



// Returns a vector of distance from each point in list and ref
function distanceToPoint ( list, ref ) =
let ( ref3=vec3(ref) ) [
    for ( e=list )
        norm ( vec3(e)-ref3 )
];

// input : list of numbers
// output: sorted list of numbers in couple [value,originalIdx]
function sortIndexed(arr) = !(len(arr)>0) ? [] : let(
    indexed = [ for ( i=[0:len(arr)-1] ) [ arr[i], i ]  ]
) sortIndexedImpl( indexed );

// Returns the index in list of the closest point to ref
function closestToPoint ( list, ref=undef ) =
let (
    sorted_dist = is_undef(ref) ? list : sortIndexed ( distanceToPoint(list,ref) )
) sorted_dist[0][1];

// Turn points in buffer so that element at index idx becomes element at index 0
function rotateBuffer( list, idx ) = 
let (
    pivot  = idx==0 ? [] : [ list[idx] ],
    before = idx==0 ? [] : (idx-1<0) ? [] : [ for (i=[0:idx-1]) list[i] ],
    after  = idx==0 ? [] : (idx+1>len(list)-1) ? [] : [ for (i=[idx+1:len(list)-1]) list[i] ]
) idx==0 ? list : concat( pivot, after, before );

// After this function the point at idx=0 is the closest point to zenith
function faceTheZenith( list, zenith=[0,100000] ) = rotateBuffer(list,closestToPoint(list,zenith));

// Compute a profile made from ratio of 2 given profiles
// The total participation of both profiles is 1
// We assume that:
//   - profile1 and profile2 are 3D points vectors
//   - profile1 and profile2 have the exact same number of points
//     use augment_profile from skin.scad if they don't
function interpolateProfile(profile1, profile2, t) = [
    for ( i=[0:len(profile1)-1] )
        [   (1-t)*profile1[i].x+t*profile2[i].x,
            (1-t)*profile1[i].y+t*profile2[i].y,
            (1-pow(t,2))*profile1[i].z+pow(t,2)*profile2[i].z
        ]
];

// ----------------------------------------
//              Implementation
// ----------------------------------------

function morphImpl ( profile1, profile2, slices=1 ) = [
	for(index = [0:slices-1])
		interpolateProfile(profile1, profile2, index/(slices-1) )
];
function sortIndexedImpl(arr) = !(len(arr)>0) ? [] : let(
    pivot   = arr[floor(len(arr)/2)][0],
    lesser  = [ for (y = arr) if (y[0]  < pivot) y ],
    equal   = [ for (y = arr) if (y[0] == pivot) y ],
    greater = [ for (y = arr) if (y[0]  > pivot) y ]
) concat(
    sortIndexedImpl(lesser), equal, sortIndexedImpl(greater)
);
function sortIndexedImpl(arr) = !(len(arr)>0) ? [] : let(
    pivot   = arr[floor(len(arr)/2)][0],
    lesser  = [ for (y = arr) if (y[0]  < pivot) y ],
    equal   = [ for (y = arr) if (y[0] == pivot) y ],
    greater = [ for (y = arr) if (y[0]  > pivot) y ]
) concat(
    sortIndexedImpl(lesser), equal, sortIndexedImpl(greater)
);


