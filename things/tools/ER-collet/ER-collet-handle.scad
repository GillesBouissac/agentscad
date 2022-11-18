/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: ER Collets handle
 * Author:      Gilles Bouissac
 */

use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <agentscad/hardware.scad>
use <agentscad/lib-screw.scad>
use <agentscad/lib-spiral.scad>
use <agentscad/mesh.scad>
use <agentscad/mxf-screw.scad>
use <agentscad/mxf-thread.scad>
use <scad-utils/shapes.scad>
use <scad-utils/lists.scad>
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <list-comprehension-demos/sweep.scad>

// HOW to generate ER-collet-handle.svg.scad from ER-collet-handle.svg:
// 1 - install inkscape: https://inkscape.org/
// 2 - install inkscape extension paths2openscad: https://github.com/sillyfrog/inkscape-paths2openscad
// 3 - open ER-collet-handle.svg with inkscape
// 4 - hide layer "Guide", show layer "ExportAll"
// 5 - select all in the layer "ExportAll"
// 6 - use menu "Extensions"/"Generate from path"/"Paths to OpenSCAD" to open the export form:
//     - set "Output file" to the full path to "ER-collet-handle.svg.scad"
//     - check the box "Only create a module"
// 7 - click on the "Apply" button to generate
//     - the generate file contains the xxx_0_points datasets used below
include <ER-collet-handle.svg.scad>

$fn=150;

// Control of what to render
RENDER_TOOL_NB = 5;
RENDER_NUT     = true;
RENDER_HANDLE  = false;
DEBUG_MODE     = false;


NUT_WALL_T = 2;
GAP_TIGHT  = 0.1;

TOOLS = [
    [ newER32(), MF39(15),  ER32_0_points, ER32_grip_path_0_points, ER32_chamber_0_points],
    [ newER25(), MF33(10),  ER25_0_points, ER25_grip_path_0_points, ER25_chamber_0_points],
    [ newER20(), MF27(9.2), ER20_0_points, ER20_grip_path_0_points, ER20_chamber_0_points],
    [ newER16(), MF22(9),   ER16_0_points, ER16_grip_path_0_points, ER16_chamber_0_points],
    [ newER11(), MF16(6.8), ER11_0_points, ER11_grip_path_0_points, ER11_chamber_0_points],
    [ newER8(),  MF12(6.5),  ER8_0_points,  ER8_grip_path_0_points,  ER8_chamber_0_points],
];

// The tool to dig the pattern on the grip ring
NUT_GRIP_T = 1;        // Grip ring thickness
NUT_GRIP_WI = 0.0;     // Internal pattern width
NUT_GRIP_WE = 1.0;     // External pattern width
NUT_GRIP_TILT_A = 60;  // Strips tilt angle
NUT_GRIP_SLOPE_A = 40; // Grooves slope angle
module nut_grip_tool(ri, re) {
    d = re-ri;
    w = NUT_GRIP_WI;
    ww = w+2*d*tan(NUT_GRIP_SLOPE_A);

    sw = d*tan(NUT_GRIP_SLOPE_A); // slope width
    iw = NUT_GRIP_WI;             // internal pattern width
    ew = NUT_GRIP_WE;             // external pattern width (required)

    // projections on z axis
    psw = sw/cos(NUT_GRIP_TILT_A);
    piw = iw/cos(NUT_GRIP_TILT_A);
    pew = ew/cos(NUT_GRIP_TILT_A);

    // total profile height is h = psw+piw+psw+pew+pdw = reqh + pdw
    reqh = psw+piw+psw+pew;

    // spiral pitch
    pitch = 2*PI*re*tan(NUT_GRIP_TILT_A);

    // pdw is computed so that pitch is an integer multiple of h
    n = floor(pitch/reqh); // number of rotations required
    pdw = pitch/n - reqh;
    h = reqh+pdw;

    single_profile = [
        [d, 0], [d, pdw],  [d, pdw+pew],
        [0, pdw+pew+psw],  [0, pdw+pew+psw+piw],
        [d, pdw+pew+psw+piw+psw]
    ];
    profile = flatten([
        for ( i=[0:n] )
            transform(translation([0,i*h,0]),single_profile)
    ]);

    placed = transform(translation([ri+0.1,0,0]), profile);
    meshi = meshSpiralInternal (placed, 1.5, radius=re+10);
    translate( [0,0,-1.25*pitch] )
        meshPolyhedron(meshi,convexity=5);
}

// The grip ring around the nut
module nut_grip(ri, re, h) {
    translate([0,0,-h/2])
    difference() {
        cylinder(r=re, h=h, center=true);
        cylinder(r=ri, h=h+2*mfg(), center=true);
        nut_grip_tool(ri, re);
        cloneMirror([1,0,0])
            nut_grip_tool(ri, re);
    }
}

// final, bevelled nut
NUT_BEVEL_W = NUT_GRIP_T;
NUT_BEVEL_A = 40;
module nut(tool) {
    nut_flat_r  = tool[I_NUT_FLAT_R];
    nut_grip_r  = tool[I_NUT_GRIP_R];
    nut_bevel_r = nut_grip_r-NUT_BEVEL_W;
    nut_h       = tool[I_NUT_H];

    bevel_h1 = nut_bevel_r/tan(NUT_BEVEL_A);
    bevel_h2 = 2*nut_h;
    bevel_r  = (bevel_h1+bevel_h2)*tan(NUT_BEVEL_A);
    intersection() {
        nut_raw(tool);
        translate([0,0,-bevel_h2])
            cylinder(r1=bevel_r,r2=0,h=bevel_h1+bevel_h2);
        translate([0,0,-bevel_h1-nut_h])
            cylinder(r1=0,r2=bevel_r,h=bevel_h1+bevel_h2);
    }
}

// not bevelled nut
module nut_raw(tool) {
    collet = tool[I_COLLET];
    thread = tool[I_THREAD];
    thr_pr = tool[I_THR_PR];
    nut_flat_r = tool[I_NUT_FLAT_R];
    nut_grip_r = tool[I_NUT_GRIP_R];
    nut_top_h = tool[I_NUT_TOP_H];
    nut_mid_h = tool[I_NUT_MID_H];
    nut_h = tool[I_NUT_H];
    thread_z = tool[I_NUT_THR_Z];
    nut_top_z = tool[I_NUT_TOP_Z];

    // Nut top part - including the extractor ring
    difference() {
        union() {
            translate( [0,0,-nut_top_h] )
                cylinder(r=nut_flat_r, h=nut_top_h );
        }

        // Top slope is controlled by collet
        // Need a little gap, the collet must not be stressed when empty or the tools can't be inserted
        translate( [0,0,-nut_top_z] )
            ERColletPassage(collet,10,$gap=GAP_TIGHT);

        // The groove on top of the extractor ring to ease clipping
        clipping_groove_r = ERColletGetD(collet)/2+gap();
        clipping_groove_h = ERColletGetL3(collet)/10;
        translate( [0,0,-100-nut_top_h+clipping_groove_h] )
            cylinder(r=clipping_groove_r, h=100 );
        // Bevel the groove following overhang for vertical printability
        translate( [0,0,-nut_top_h+clipping_groove_h] )
            cylinder(r1=clipping_groove_r, r2=0, h=clipping_groove_r/tan(overhang()) );
    }

    // Nut middle part - from the botton of extractor ring to the thread
    difference() {
        // Top nut external shape
        union() {
            translate( [0,0,-nut_top_h-nut_mid_h] )
                cylinder(r=nut_flat_r, h=nut_mid_h );
        }

        // Thread passage with slope under extractor ring to take $overhang into account
        ring_slope_h = tool[I_RNG_SLOPE_H];
        translate( [0,0,-nut_top_h-ERColletGetRT(collet)] )
        skin([
            transform(translation([0,0,-ring_slope_h-mfg()]),
                circle(r=thr_pr)),
            transform(translation(ERColletGetRTr(collet))*translation([0,0,0]),
                circle(r=ERColletGetRD(collet)/2+gap())),
            transform(translation(ERColletGetRTr(collet))*translation([0,0,ERColletGetRT(collet)+mfg()]),
                circle(r=ERColletGetRD(collet)/2+gap()))
        ]);
        translate( [0,0,-100-nut_top_h-ERColletGetRT(collet)-ring_slope_h] )
            cylinder(r=thr_pr, h=100 );

    }

    // Nut bottom part - thread
    translate( [0,0,thread_z] )
    difference() {
        mxfThreadInternal(thread, t=NUT_WALL_T);
        // Mark the position of the extraction ring for easy insert/remove of the collet in the nut
        cloneMirror([0,1,0])
            rotate([0,0,10])
            translate([nut_flat_r-1,0,0])
            cylinder( r=0.8, h=1, center=true);
    }

    // Finally render the grip ring
    nut_grip(nut_flat_r, nut_grip_r, nut_h);
}

function profile_bbox(p) = let(
    max_x = max([for(i=[0:len(p)-1]) p[i].x]),
    max_y = max([for(i=[0:len(p)-1]) p[i].y]),
    min_x = min([for(i=[0:len(p)-1]) p[i].x]),
    min_y = min([for(i=[0:len(p)-1]) p[i].y])
) [[min_x, min_y, 0], [max_x, max_y, 0]];

HND_GRIP_NB = 8;
SVG_PT_TO_MM = [25.4/96, -25.4/96, 1];
module handle(tool) {
    collet = tool[I_COLLET];
    thread = tool[I_THREAD];
    hnd_profile_pt = transform(scaling(SVG_PT_TO_MM), tool[I_HND_PRF_PT]);
    hnd_profile_tr = -profile_bbox(hnd_profile_pt)[1];
    hnd_profile_points = transform(translation(hnd_profile_tr),hnd_profile_pt);
    hnd_grip_points    = transform(rotation([90,0,0])*translation(hnd_profile_tr)*scaling([25.4/96, -25.4/96, 1]), tool[I_HND_GRP_PT]);
    hnd_chamber_points = transform(translation(hnd_profile_tr)*scaling([25.4/96, -25.4/96, 1]), tool[I_HND_CHB_PT]);

    difference() {
        union() {
            translate( [0,0,tool[I_HND_TOP_Z]] )
                mxfThreadExternal(thread);
            translate( [0,0,tool[I_HND_BOT_Z]] )
                difference() {
                    rotate_extrude()
                        polygon(to_2d(hnd_profile_points));
                    rotate_extrude()
                        polygon(to_2d(hnd_chamber_points));
                    for ( i=[0:1/HND_GRIP_NB:1] )
                        rotate([0,0,i*360])
                            sweep(transform(scaling([-1,1,1]),circle(r=2)), construct_transform_path(hnd_grip_points) );
                }
        }
        translate( [0,0,-(ERColletGetL(collet)+layer()+gap())] )
            ERColletPassage(collet,0,$gap=0);
    }
}

// The gap between nut bottom and handle top in order to crush the collet
// Computed as a ration of thread pitch
PITCH_RATIO_MARGIN = 1;

function newTool(tool_data) = let(
    collet = tool_data[I_COLLET],
    thread = tool_data[I_THREAD],
    hnd_profile_points = tool_data[I_HND_PRF_PT],
    hnd_grip_points = tool_data[I_HND_GRP_PT],
    hnd_chamber_points = tool_data[I_HND_CHB_PT],

    thr_pr = screwGetThreadMaxD(thread)/2+gap(),
    nut_flat_r = screwGetThreadMaxD(thread)/2+NUT_WALL_T,
    nut_grip_r = nut_flat_r+NUT_GRIP_T,
    ring_slope_h = (thr_pr-ERColletGetRD(collet)/2)/tan(overhang()),
    nut_top_disc_h = 2*layer()+gap(),
    nut_top_h = ERColletGetL3(collet)+nut_top_disc_h,
    nut_mid_h = ERColletGetRT(collet)+ring_slope_h+layer(),
    nut_bot_h = screwGetThreadL(thread),
    nut_h = nut_top_h+nut_mid_h+nut_bot_h,
    nut_thr_z = -nut_h,
    nut_top_z = ERColletGetL(collet)+nut_top_disc_h,
    hnd_top_z = nut_thr_z-PITCH_RATIO_MARGIN*screwGetPitch(thread),
    hnd_bot_z = hnd_top_z
) [
    collet, thread, hnd_profile_points, hnd_grip_points, hnd_chamber_points,
    thr_pr, ring_slope_h,
    nut_flat_r, nut_grip_r, nut_top_h, nut_mid_h, nut_bot_h, nut_h, nut_thr_z, nut_top_z,
    hnd_top_z, hnd_bot_z
];

I_COLLET      =  0;
I_THREAD      =  1;
I_HND_PRF_PT  =  2;
I_HND_GRP_PT  =  3;
I_HND_CHB_PT  =  4;

I_THR_PR      =  5; // Thread Passage Radius
I_RNG_SLOPE_H =  6;
I_NUT_FLAT_R  =  7;
I_NUT_GRIP_R  =  8;
I_NUT_TOP_H   =  9;
I_NUT_MID_H   = 10;
I_NUT_BOT_H   = 11;
I_NUT_H       = 12;
I_NUT_THR_Z   = 13;
I_NUT_TOP_Z   = 14;
I_HND_TOP_Z   = 15;
I_HND_BOT_Z   = 16;

difference() {
    tool_data = TOOLS[RENDER_TOOL_NB];
    tool = newTool(tool_data);
    hnd_profile_pt = transform(scaling(SVG_PT_TO_MM), tool[I_HND_PRF_PT]);
    hnd_profile_bbox = profile_bbox(hnd_profile_pt);

    echo("  Rendering tool for: ", ERColletGetName(tool[I_COLLET]));
    echo("    Nut diameter:    ", 2*tool[I_NUT_GRIP_R]);
    echo("    Nut height:      ", tool[I_NUT_H]);
    echo("    Nut ratio:       ", 2*tool[I_NUT_GRIP_R]/tool[I_NUT_H]);
    echo("    Collet max D:    ", ERColletGetD(tool[I_COLLET]));
    echo("    Collet top D:    ", ERColletGetTopD(tool[I_COLLET]));
    echo("    Collet base D:   ", ERColletGetBaseD(tool[I_COLLET]));
    echo("    Thread min D:    ", screwGetThreadMinD(tool[I_THREAD]));
    echo("    Handle height:   ", abs(hnd_profile_bbox[1].y-hnd_profile_bbox[0].y));
    echo("    Handle diameter: ", 2*abs(hnd_profile_bbox[1].x-hnd_profile_bbox[0].x));
    echo("    Handle top z:    ", tool[I_NUT_TOP_Z]+tool[I_HND_TOP_Z]);

    union() {
        translate( [0,0,tool[I_NUT_TOP_Z]] ) {
            if (RENDER_NUT) nut(tool);
            if (RENDER_HANDLE) handle(tool);
        }
    }

    // For debugging
    if (DEBUG_MODE) {
//        %ERCollet(tool[I_COLLET]);
        translate([0,-500,0])
            cube(1000, center=true);
    }
}


