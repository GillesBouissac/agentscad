/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Sweep an opened profile along a spiral to build a 3D surface without any manifold issue
 * Author:      Gilles Bouissac
 */
use <scad-utils/lists.scad>
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/extensions.scad>
use <agentscad/mesh.scad>

// ----------------------------------------
//
//      API
//
// ----------------------------------------

//
// Build an external spiral mesh from a given 2D profile
// The spiraled profile is the external surface of the mesh
//
// It is assumes that the profile respects these conditions:
// - x is always positive,
// - First profile point Y is less than last profile Y
//
// In other cases the result is likely to give bad normal orientation
//
// Params:
// - profile: 2D array (x,y) of points
// - loops:   Number of spiral rotation or fraction of rotation required
// - layer:   (Optional): Spiral layers height
//            computed from profile y min/max coordinates if not set
//min/max 
function meshSpiralExternal ( profile, loops=1, layer=undef ) =
    meshSpiralExternalImpl ( profile, loops, layer );

//
// Build an internal spiral mesh from a given 2D profile
// The spiraled profile is the internal surface of the mesh
// The external surface is a cylinder with given radius
//
// It is assumes that the profile respects these conditions:
// - x is always positive,
// - First profile point Y is less than last profile Y
//
// In other cases the result is likely to give bad normal orientation
//
// Params:
// - profile: 2D array (x,y) of points
// - loops:   Number of spiral rotation or fraction of rotation required
// - layer:   (Optional): Spiral layers height
//            computed from profile y min/max coordinates if not set
// - radius:  (Optional): Radius of cylinder around the profile:
//            computed to be equal to profile x max coordinates if not set
//
function meshSpiralInternal ( profile, loops=1, layer=undef, radius=undef ) =
    meshSpiralInternalImpl ( profile, loops, layer, radius );


// ----------------------------------------
//
//      Implementation
//
// ----------------------------------------

//
// Implementation of meshSpiralExternal
//
function meshSpiralExternalImpl ( profile, loops=1, layer=undef ) = let(
    profile3d = [ for (i=[0:len(profile)-1])  [profile[i].x,0,profile[i].y] ],
    loop_h        = is_undef(layer) ? abs(profile3d[0].z-profile3d[len(profile3d)-1].z) : layer,
    step            = getStep(),
    step_h          = step*loop_h,
    nb_slice        = floor ( loops/step ),
    nb_slice_loop   = floor ( 1/step ),
    nb_slice_facets = len ( profile3d ),
    nb_slice_cap    = nb_slice<nb_slice_loop ? nb_slice:nb_slice_loop,
    bot_z           = min ( [ for(p=profile3d) p.z ]  ),

    points_profiles = flatten([ for (i=[0:nb_slice])
        transform (
            translation([0,0,i*step_h])*rotation([0,0,i*step*360]),
            profile3d )
    ]),
    cap_pt_idx = len(points_profiles),
    cap_sl_idx = nb_slice+nb_slice_loop-nb_slice_cap,
    // One layer of first profile point for last seam
    cap_points = flatten([ for (i=[0:nb_slice_cap]) let (is=cap_sl_idx+i)
        transform (
            translation([0,0,is*step_h])*rotation([0,0,is*step*360]),
            [ profile3d[0] ] )
    ]),
    // Bottom pole (index of first point: pole_bot_pt_idx)
    pole_bot_pt_idx = cap_pt_idx + len(cap_points),
    bottom_points = [
        for ( i=[0:nb_slice_cap] ) [0,0,bot_z+(i+1)*step_h]
        ,[0,0,bot_z+loop_h] // Last point for complete Bottom face
    ],
    // Top pole (index of first point: pole_top_pt_idx)
    pole_top_pt_idx = pole_bot_pt_idx + len(bottom_points),
    top_points = [
        [0,0,bot_z+nb_slice*step_h], // First point for complete Top face
        for ( i=[0:nb_slice_cap] ) let (is=cap_sl_idx+i) [0,0,bot_z+is*step_h]
    ],

    points = concat( points_profiles, cap_points, bottom_points, top_points ),
    faces = [
        // Profile sweeping
        for ( s=[0:nb_slice-1], f=[0:nb_slice_facets-2] ) [
                 (  s    % (nb_slice+1)) * (nb_slice_facets) + f
                ,(  s    % (nb_slice+1)) * (nb_slice_facets) + (f+1) % (nb_slice_facets)
                ,( (s+1) % (nb_slice+1)) * (nb_slice_facets) + (f+1) % (nb_slice_facets)
                ,( (s+1) % (nb_slice+1)) * (nb_slice_facets) + f
            ],
        // Seams
        if ( nb_slice>nb_slice_cap )
            for ( s=[0:nb_slice-nb_slice_cap-1] ) [
                      (s+0)              * (nb_slice_facets) + nb_slice_facets-1
                    , (s+nb_slice_loop+0) * (nb_slice_facets) + 0
                    , (s+nb_slice_loop+1) * (nb_slice_facets) + 0
                    , (s+1)              * (nb_slice_facets) + nb_slice_facets-1
                ],
        // Seams top cap
        for ( s=[0:nb_slice_cap-1] ) [
                  (nb_slice-nb_slice_cap+s+0) * (nb_slice_facets) + nb_slice_facets-1
                , cap_pt_idx + s + 0
                , cap_pt_idx + s + 1
                , (nb_slice-nb_slice_cap+s+1) * (nb_slice_facets) + nb_slice_facets-1
            ],
        // Bottom cap
        for ( s=[0:nb_slice_cap-1] ) [ (s+1) * nb_slice_facets, pole_bot_pt_idx+s+0, (s+0) * nb_slice_facets ],
        for ( s=[0:nb_slice_cap-1-1] ) [ (s+1) * nb_slice_facets, pole_bot_pt_idx+s+1, pole_bot_pt_idx+s+0 ],
        // Top cap
        for ( s=[0:nb_slice_cap-1] ) [ cap_pt_idx+s+0, pole_top_pt_idx+s+1, cap_pt_idx+s+1 ],
        for ( s=[0:nb_slice_cap-2] ) [ cap_pt_idx+s+1, pole_top_pt_idx+s+1, pole_top_pt_idx+s+2 ],
        // Bottom wall
        [
            for ( i=[0:len(bottom_points)-1] )    pole_bot_pt_idx+i ,
            nb_slice>nb_slice_cap ? nb_slice_loop*nb_slice_facets:cap_pt_idx,
            for ( i=[nb_slice_facets-1:-1:0] )  i
        ],
        // Top wall
        [
            for ( i=[len(top_points)-2:-1:0] ) pole_top_pt_idx+i ,
            for ( i=[0:nb_slice_facets-1] )  len(points_profiles)-nb_slice_facets+i,
            cap_pt_idx+nb_slice_cap,
        ]
    ]
) newMesh ( points, faces );

//
// Implementation of meshSpiralInternal
//
function meshSpiralInternalImpl ( profile, loops, layer, radius ) = let(
    profile3d = [ for (i=[0:len(profile)-1])  [profile[i].x,0,profile[i].y] ],
    loop_h             = is_undef(layer) ? abs(profile3d[0].z-profile3d[len(profile3d)-1].z) : layer,
    step               = getStep(),
    step_h             = step*loop_h,
    nb_slice           = floor ( loops/step ),
    nb_slice_loop      = floor ( 1/step ),
    nb_slice_facets    = len ( profile3d ),
    nb_slice_cap       = nb_slice<nb_slice_loop ? nb_slice:nb_slice_loop,
    nb_slice_overlap   = nb_slice>nb_slice_loop ? nb_slice%nb_slice_loop:0,
    bot_z              = min ( [for(p=profile3d)p.z] ),
    min_r              = max ( [for(p=profile3d)p.x] ),
    loc_r              = is_undef(radius) || radius<min_r ? min_r : radius,

    points_profiles = flatten([ for (i=[0:nb_slice])
        transform (
            translation([0,0,i*step_h])*rotation([0,0,i*step*360]),
            profile3d )
    ]),
    cap_sl_idx = nb_slice+nb_slice_loop-nb_slice_cap,
    cap_pt_idx = len(points_profiles),
    // One layer of first profile point for last seam
    cap_points = flatten([ for (i=[0:nb_slice_cap]) let (is=cap_sl_idx+i)
        transform (
            translation([0,0,is*step_h])*rotation([0,0,is*step*360]),
            [ profile3d[0] ] )
    ]),
    // Cylinder bottom points
    cyl_bot_pt_idx = cap_pt_idx + len(cap_points),
    bottom_points = flatten([ for ( i=[0:nb_slice_cap] ) let (is=i)
        transform ( translation([0,0,is*step_h])*rotation([0,0,is*step*360]), [[loc_r,0,bot_z]])
    ]),
    // Cylinder top points
    cyl_ovl_pt_idx = cyl_bot_pt_idx + len(bottom_points),
    overlap_points = flatten([
        if (nb_slice_overlap>0) for ( i=[-nb_slice_overlap:0] ) let (is=cap_sl_idx+nb_slice_loop+i)
            transform ( translation([0,0,is*step_h])*rotation([0,0,is*step*360]), [[loc_r,0,bot_z]])
        ]),
    cyl_top_pt_idx = cyl_ovl_pt_idx + len(overlap_points),
    top_points = flatten([
        for ( i=[0:nb_slice_cap-nb_slice_overlap] ) let (is=cap_sl_idx+i)
            transform ( translation([0,0,is*step_h])*rotation([0,0,is*step*360]), [[loc_r,0,bot_z]])
        ]),
    spec_pt_idx = cyl_top_pt_idx + len(top_points),
    special_points = flatten([
        // Special point for complete Bottom face
        [[loc_r,0,bot_z+loop_h]],
        // Special point for complete Top face
        transform ( translation([0,0,nb_slice*step_h])*rotation([0,0,nb_slice*step*360]), [[loc_r,0,bot_z]])
    ]),
    points = concat( points_profiles,cap_points,bottom_points,overlap_points,top_points,special_points ),
    faces = [
        // Profile sweeping
        for ( s=[0:nb_slice-1], f=[0:nb_slice_facets-2] ) [
                 ( (s+1) % (nb_slice+1)) * (nb_slice_facets) + f
                ,( (s+1) % (nb_slice+1)) * (nb_slice_facets) + (f+1) % (nb_slice_facets)
                ,(  s    % (nb_slice+1)) * (nb_slice_facets) + (f+1) % (nb_slice_facets)
                ,(  s    % (nb_slice+1)) * (nb_slice_facets) + f
            ],
        // Seams
        if ( nb_slice>nb_slice_cap )
            for ( s=[0:nb_slice-nb_slice_cap-1] ) [
                     (s+1)               * (nb_slice_facets) + nb_slice_facets-1
                    ,(s+nb_slice_loop+1) * (nb_slice_facets) + 0
                    ,(s+nb_slice_loop+0) * (nb_slice_facets) + 0
                    ,(s+0)               * (nb_slice_facets) + nb_slice_facets-1
                ],
        // Seams top cap
        for ( s=[0:nb_slice_cap-1] ) [
                 (nb_slice-nb_slice_cap+s+1) * (nb_slice_facets) + nb_slice_facets-1
                ,cap_pt_idx + s + 1
                ,cap_pt_idx + s + 0
                ,(nb_slice-nb_slice_cap+s+0) * (nb_slice_facets) + nb_slice_facets-1
            ],
        // Cylinder
        if (nb_slice_overlap>0)
            for ( s=[0:nb_slice_overlap-1] ) let (
                    offs1=cyl_bot_pt_idx,
                    offs2=cyl_ovl_pt_idx,
                    is_first = s==0,
                    is_last  = s==nb_slice_overlap-1
                )
                concat(
                    [offs1+s+1,offs1+s+0],
                    is_first ? [spec_pt_idx+0]:[],
                    [offs2+s+0, offs2+s+1],
                    is_last  ? [spec_pt_idx+1]:[]
                ),
        for ( s=[0:nb_slice_cap-nb_slice_overlap-1] )
            let ( offs1=cyl_bot_pt_idx+nb_slice_overlap, offs2=cyl_top_pt_idx )
            [ offs1+s+1 ,offs1+s+0 ,offs2+s+0 ,offs2+s+1 ],
        // Bottom cap
        for ( s=[0:nb_slice_cap-1] ) let ( mult1=nb_slice_facets, offs2=cyl_bot_pt_idx )
            [ (s+1)*mult1, (s+0)*mult1, offs2+s+0, offs2+s+1 ],
        // Top cap
        for ( s=[0:nb_slice_cap-nb_slice_overlap-1] ) let ( offs1=cap_pt_idx, offs2=cyl_top_pt_idx )
            [ offs1+s+0, offs1+s+1, offs2+s+1, offs2+s+0 ],
        if ( nb_slice_overlap>0 )
        for ( s=[0:nb_slice_overlap-1] ) let ( offs1=cap_pt_idx+nb_slice_loop-nb_slice_overlap, offs2=cyl_ovl_pt_idx)
            [ offs1+s+0, offs1+s+1, offs2+s+1, offs2+s+0 ],
        // Bottom wall
        [
            for ( i=[0:nb_slice_facets-1] )  i,
            nb_slice_overlap>0 ? nb_slice_cap*nb_slice_facets: cap_pt_idx,
            spec_pt_idx+0,
            cyl_bot_pt_idx+0
        ],
        // Top wall
        [
            cap_pt_idx+nb_slice_cap,
            for ( i=[nb_slice_facets-1:-1:0] )  len(points_profiles)-nb_slice_facets+i,
            nb_slice_overlap>0 ? cyl_top_pt_idx: spec_pt_idx+1,
            nb_slice_overlap>0 ? cyl_ovl_pt_idx+len(overlap_points)-1: cyl_top_pt_idx+nb_slice_cap,
        ]
    ]
) newMesh ( points, faces );


// ----------------------------------------
//
//      Showcase
//
// ----------------------------------------

module showcase() {
    profile = [ for ( i=[0:0.05:1]) [2+0.2*sin(i*360),0.05+2*i] ];
//    profile = [ [2,0.1], [1,1], [2,2] ];

    loops = 5+20*getStep();
    gap   = 0.05;

    meshe = meshSpiralExternal ( profile=[for(p=profile)[p.x-gap,p.y]], loops=loops, layer=2 );
    meshi = meshSpiralInternal ( profile=[for(p=profile)[p.x+gap,p.y]], loops=loops, layer=2, radius=4 );
    difference() {
        intersection() {
            union() {
                meshPolyhedron(meshi,convexity=5);
                meshPolyhedron(meshe,convexity=5);
            }
            translate( [0,0,4] )
                cube( [100,100,4.5], true );
        }
        cube( [10,10,10] );
    }
}

showcase ($fn=50);
