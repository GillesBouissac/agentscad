/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 16 branches star
 * Author:      Gilles Bouissac
 * 
 * Inspiration for the star: https://www.thingiverse.com/thing:4031938
 */

use <scad-utils/lists.scad>
use <scad-utils/transformations.scad>
use <agentscad/extensions.scad>
use <agentscad/printing.scad>
use <list-comprehension-demos/skin.scad>
use <list-comprehension-demos/sweep.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// width:     cell width (ie square border length)
// long:      long branches (square branches) length
// short:     short branches (triangle branches) length
// thickness: branch wall thickness
// form:      branch form factor ( 0: Flat, 2: Rounded, 3:Straight, 4:Sharp etc... )
// trunk_d:   tree trunk diameter if you need tree stand
// trunk_l:   tree trunk stand length if you need tree stand
function newStar( width=undef, long=undef, short=undef, thickness=undef, form=undef, trunk_d=undef, trunk_l=undef ) =
let (
    loc_w  = is_undef(width)     ? STAR_CELL_W      : width,
    loc_l  = is_undef(long)      ? STAR_LBRANCH_L   : long,
    loc_s  = is_undef(short)     ? STAR_SBRANCH_L   : short,
    loc_t  = is_undef(thickness) ? STAR_BRANCH_T    : thickness,
    loc_f  = is_undef(form)      ? STAR_FORM_FACTOR : form,
    loc_td = is_undef(trunk_d)   ? TREE_TRUNK_D     : trunk_d,
    loc_tl = is_undef(trunk_l)   ? TREE_TRUNK_L     : trunk_l,
    core_h = loc_w*(1+2*cos(45)),
    tri_h  = loc_w*tan(60)/2,
    tri_hs = loc_w*tan(30)/2,
    tri_hl = tri_h-tri_hs,
    sct    = STAR_SCELL_T+loc_t*tan(30),
    tct    = STAR_TCELL_T+loc_t*tan(30),
    x1     = echo( "Star core height = ", core_h ),
    x2     = echo( "Star height = ", core_h+2*loc_l )
) [ loc_w, loc_l, loc_s, loc_t, loc_f, loc_td, loc_tl, core_h, tri_h, tri_hs, tri_hl, sct, tct ];

function getStarBranchW(s)       = s[IB_W];
function getStarLongBranchL(s)   = s[IB_L];
function getStarShortBranchL(s)  = s[IB_S];
function getStarWallT(s)         = s[IB_T];
function getStarFormF(s)         = s[IB_F];
function getStarTrunkD(s)        = s[IB_TD];
function getStarTrunkL(s)        = s[IB_TL];
function getStarCoreH(s)         = s[IB_CH];
function getStarSquareCellT(s)   = s[IB_SCT];
function getStarTriangleCellT(s) = s[IB_TCT];

module snapStarLongBranch( star ) {
    difference() {
        snapStarBranch (
            star,
            snapStarLongBranchProfile( star ),
            star[IB_W]/2,
            STAR_SCELL_T,
            star[IB_L],
            star[IB_W] );
        cellSCut(star);
    }
}
module snapStarShortBranch( star ) {
    difference() {
        snapStarBranch(
            star,
            snapStarShortBranchProfile( star ),
            star[IB_THS],
            STAR_TCELL_T,
            star[IB_S],
            star[IB_TH] );
        cellTCut(star);
    }
}
module snapStarTreeStandBranch ( star ) {
    difference() {
        union() {
            snapStarLongBranch( star );
            snapStarTreeStandShape(star, star[IB_TL], 0, star[IB_TD]+2*star[IB_T]);
        }
        snapStarTreeStandShape(star, star[IB_L], star[IB_T], star[IB_TD]);
    }
}
module snapStarCore( star ) {
    difference() {
        union() {
            transformSCellRosace( star ) {
                snapStarSCell( star );
                snapStarSCell( star );
            }
            transformTCellRosace( star )
                snapStarTCell( star );
        }
        // Avoid empty first layer
        translate ( [0,0,-star[IB_CH]/2] )
            cube( [1000,1000,3*layer()], center=true );
    }
}
module snapStarAllBranches (star, num=26) {
    for ( cpt=[0:num-1] )
        let (
            j=floor(cpt/6),
            i=cpt-6*j
        )
        translate( [1.5*(i-2.5)*getStarBranchW(star), 1.5*(j-2)*getStarBranchW(star), 0] )
            if ( cpt<18 )
                translate ( [0,0,getStarSquareCellT(star)] )
                    snapStarLongBranch( star );
            else if ( cpt<26 )
                translate ( [0,0,getStarTriangleCellT(star)] )
                    snapStarShortBranch( star );
            else
                translate ( [0,0,getStarTrunkL(star)] )
                rotate( [180,0,0] )
                    snapStarTreeStandBranch( star );
}


// ----------------------------------------
//             Implementation
// ----------------------------------------
IB_W   = 0;
IB_L   = 1;
IB_S   = 2;
IB_T   = 3;
IB_F   = 4;
IB_TD  = 5;
IB_TL  = 6;
IB_CH  = 7;
IB_TH  = 8;
IB_THS = 9;
IB_THL = 10;
IB_SCT = 11;
IB_TCT = 12;

STAR_CELL_W      = 20;
STAR_LBRANCH_L   = 80;
STAR_SBRANCH_L   = STAR_LBRANCH_L/2;
STAR_BRANCH_T    = 3*nozzle();
STAR_FORM_FACTOR = 2.2;
TREE_TRUNK_D     = 20;
TREE_TRUNK_L     = STAR_LBRANCH_L*cos(45);

STAR_SCELL_T    = 5;
STAR_TCELL_T    = 5.2785;
STAR_CELL_A     = 50;

STAR_SCELL_B    = 3; // Border width
STAR_SCELL_PT   = 1; // Passage thickness

HOOK_R = 0.6;
HOOK_W = 0.5;
// Interval between hook centers (oblong hook)
HOOK_I = 0.6;

CUTTER_W  = 2*nozzle();
CUTTER_DH = 1;

function snapStarLongBranchProfile( star ) = [
    [ -star[IB_W]/2,  star[IB_W]/2 ],
    [  star[IB_W]/2,  star[IB_W]/2 ],
    [  star[IB_W]/2, -star[IB_W]/2 ],
    [ -star[IB_W]/2, -star[IB_W]/2 ]
];
function snapStarShortBranchProfile( star ) = [
    [  -star[IB_THS], -star[IB_W]/2 ],
    [  -star[IB_THS], +star[IB_W]/2 ],
    [  star[IB_THL], 0 ]
];
function getSCellRadius( star ) = let(
    h       = star[IB_W]*(1/2+cos(45)),
    alpha   = atan((star[IB_W]/2)/h),
    length1 = h/cos(alpha),
    beta    = asin(star[IB_THS]/length1),
    length2 = star[IB_THS]/tan(beta)
) length2;
function snapStarCellShapeBoxPath( star, width, thickness ) = let(
    alpha    = atan( (width/2)/getSCellRadius(star) ),
    sBox     = 2*(getSCellRadius(star)-thickness)*tan(alpha)/width
)[
    translation([0,0,0])*scaling([sBox,sBox,1]),
    translation([0,0,thickness])
];

function snapStarCellShapeHolePath( star, width, thickness, gap=0 ) = let(
    wPassage = width-2*STAR_SCELL_B-2*gap, // Passage
    sPassage = wPassage/width,
    hPassage = thickness+2*gap-STAR_SCELL_B/tan(STAR_CELL_A),
    hHook    = hPassage-(STAR_SCELL_PT+2*gap),
    hook_w   = HOOK_W, // We want a tight hook
    alpha    = asin((HOOK_R-hook_w)/HOOK_R),
    step     = 8*getStep() // Small part, don't need to much precision
) concat(
[
    for ( i=[0:step:1] )
        let(
            dh    = HOOK_R*sin(-90+i*(90-alpha)+alpha),
            dw    = HOOK_R*cos(-90+i*(90-alpha)+alpha),
            bottomW  = wPassage+2*dw-2*(HOOK_R-hook_w),
            sBottom  = bottomW/width
        )
        translation([0,0,dh])*
        scaling([sBottom,sBottom,1]),
],
[
    for ( i=[0:step:1] )
        let(
            // +gap to reduce looseness when branches are in place
            dh    = HOOK_R*sin(i*(90-alpha))+HOOK_I+gap,
            dw    = HOOK_R*cos(i*(90-alpha)),
            bottomW  = wPassage+2*dw-2*(HOOK_R-hook_w),
            sBottom  = bottomW/width
        )
        translation([0,0,dh])*
        scaling([sBottom,sBottom,1]),
],
[
    translation([0,0,hHook])*scaling([sPassage,sPassage,1]),
    translation([0,0,hPassage])*scaling([sPassage,sPassage,1]),
    translation([0,0,thickness+2*gap])
]);
module snapStarCellShape ( star, profile, width, thickness ) {
    difference() {
        sweep ( profile, snapStarCellShapeBoxPath( star, width, thickness ) );
        sweep ( profile, snapStarCellShapeHolePath( star, width, thickness ) );
    }
}

module snapStarSCell( star ) {
    translate( [0,0,-STAR_SCELL_T] )
        snapStarCellShape( star, snapStarLongBranchProfile( star ), star[IB_W], STAR_SCELL_T );
}
module snapStarTCell( star ) {
    translate( [0,0,-STAR_TCELL_T] )
        snapStarCellShape( star, snapStarShortBranchProfile( star ), star[IB_TH], STAR_TCELL_T );
}
module cellCutBranch ( d ) {
    alpha = 90-STAR_CELL_A;
    dx    = CUTTER_DH*cos(alpha);
    dz    = CUTTER_DH*sin(alpha);
    z     = (d - dx)/tan(alpha) - dz;
    translate ( [0,0,z] ) {
        rotate( [0,STAR_CELL_A,0] ) {
            translate ( [50,0,-CUTTER_W/2] )
                rotate([0,90,0])
                cylinder ( r=CUTTER_W/2, h=100, center=true );
            translate ( [0,0,-CUTTER_W/2] )
                rotate( [90,0,0] )
                    translate ( [0,0,-CUTTER_W/2] )
                    linear_extrude( height=CUTTER_W )
                    polygon( [ [0,0], [100,0], [100,-100*tan(alpha)] ] );
        }
    }
}
module cellSCut(star) {
    d = (star[IB_W]/2-star[IB_T])/sin(45);
    cloneRotate ( [0,0,180] )
        cloneRotate ( [0,0,90] )
        rotate ( [0,0,45] )
        cellCutBranch(d);
}
module cellTCut(star) {
    d = star[IB_THL]-star[IB_T]/cos(60);
    cloneRotate ( [0,0,120] )
        cloneRotate ( [0,0,120] )
        cellCutBranch(d);
}

module setSCellOnRosace ( star ) {
    translate( [0,0,star[IB_CH]/2] )
        children();
}
module setTCellOnRosace ( star ) {
    translate( [0,0,getSCellRadius(star)] )
        children();
}
module transformSCellQuadRosace( star ) {
    cloneRotate( [180,0,0] )
        cloneRotate( [90,0,0] )
            rotate( [45,0,0] )
                setSCellOnRosace( star )
                    children();
}
module transformSCellRosace( star ) {
    cloneRotate( [0,180,0] )
        rotate( [0,90,0] )
        setSCellOnRosace( star )
            children([1:$children-1]);
    rotate( [0,180,0] )
        setSCellOnRosace( star )
            children([0]);
    rotate( [0,0,0] )
        setSCellOnRosace( star )
            children([1:$children-1]);
    cloneRotate( [180,0,0] )
        rotate( [90,0,0] )
            setSCellOnRosace( star )
                children([1:$children-1]);
    rotate( [0,0,0] )
        transformSCellQuadRosace( star )
        children([1:$children-1]);
    rotate( [0,0,90] )
        transformSCellQuadRosace( star )
        children([1:$children-1]);
    rotate( [0,90,0] )
        transformSCellQuadRosace( star )
        children([1:$children-1]);
}
module transformTCellRosace( star ) {
    cloneRotate([0,180,0])
        cloneRotate([180,0,0])
            cloneRotate([90,0,0])
                alignOnVector ( [1,1,-1] )
                    setTCellOnRosace ( star )
                        children();
}

module snapStarBranchShape ( star, profile, base_h, height, width, dh ) {
    step  = 2*getStep();
    formFactor = star[IB_F];
    path_transforms = concat (
        [
            for ( t=snapStarCellShapeHolePath( star, width, base_h+dh, gap() ) )
                translation([0,0,-base_h-gap()])*t
        ],
        [
            for (t=[0:step:1])
                let( scal=pow(1-t,formFactor/3), s=scal<0?0:scal )
                translation([0,0,dh+height*t+gap()])*
                scaling([s,s,1])
        ]
    );
    sweep ( profile, path_transforms );
}
module snapStarBranch( star, profile, border_to_center, base_h, height, width ) {
    sc = (border_to_center-star[IB_T])/border_to_center;
    dh = star[IB_T]*tan(30);
    difference() {
        snapStarBranchShape ( star, profile, base_h, height, width, 0 );
        snapStarBranchShape ( star, profile*sc, base_h, height*sc, width*sc, dh );
    }
}
module snapStarTreeStandShape ( star, length, height, trunk_diameter, gap=0 ) {
    r = trunk_diameter/2;
    step       = getStep();
    formFactor = 0.8;
    profile = [
        for ( t=[0:step:1] )
            [ r*cos(-360*t), r*sin(-360*t) ]
    ];
    path_transforms = concat ([
        for (t=[0:2*step:1+step])
            let( scal=pow(t,formFactor/3), s=scal<0?0:scal )
            translation([0,0,length*t+height])*
            scaling([s,s,1])
    ]);
    sweep ( profile, path_transforms );
}

module snapStarRosace( star ) {
    color ( "yellow" ) {
        transformSCellRosace( star ) {
            children();
            snapStarLongBranch( star );
        }
        transformTCellRosace( star )
            snapStarShortBranch( star );
    }
}

// ----------------------------------------
//                Showcase
// ----------------------------------------

module showStarParts (part=0, sub_part=0, cut=undef, cut_rotation=undef) {
    star = newStar();

    if ( part==0 ) {
        intersection () {
            union() {
                if ( sub_part==0 ) {
                    snapStarCore( star );
                    color ( "yellow", 1 )
                        snapStarRosace( star )
                            snapStarTreeStandBranch( star );
                }
                if ( sub_part==1 ) {
                    snapStarCore( star );
                }
                if ( sub_part==2 ) {
                    snapStarRosace( star )
                        snapStarTreeStandBranch( star );
                }
                if ( sub_part==3 ) {
                    color ( "yellow", 1 )
                        snapStarLongBranch( star );
                    snapStarSCell( star );
                }
                if ( sub_part==4 ) {
                    color ( "yellow", 1 )
                        snapStarShortBranch( star );
                    snapStarTCell( star );
                }
            }
            color ( "#fff",0.1 )
                rotate( [0,0,is_undef(cut_rotation)?0:cut_rotation] )
                translate( [-500,is_undef(cut)?-500:cut,-500] )
                cube( [1000,1000,1000] );
        }
    }
    else if ( part==1 ) {
        // printable star core
        snapStarCore( star );
    }
    else if ( part==2 ) {
        // All branches on a single bed
        snapStarAllBranches(star);
        % translate([0,0,-1]) // Image of the printer bed
            cube( [ printVolume().x, printVolume().y, 1 ], center=true );
    }
    else if ( part==3 ) {
        // printable short branch for stand alone
        translate ( [0,0,getStarTrunkL(star)] )
        rotate( [180,0,0] )
            snapStarTreeStandBranch( star );
    }
    else if ( part==4 ) {
        // printable long branch alone
        snapStarLongBranch( star );
    }
    else if ( part==5 ) {
        // printable short branch alone
        snapStarShortBranch( star );
    }
}

// part=0: mutiple parts at the same time
//   sub_part=0: all
//   sub_part=1: star core
//   sub_part=2: star rosace
//   sub_part=3: square branch with cell
//   sub_part=4: triangle branch with cell
//   cut/cut_rotation: cut position/rotation (ex:0) to see inside (undef for no cut)
// part=1: printable: star core
// part=2: printable: all branches for a full star
// part=3: printable: branch for stand on a tree
// part=4: printable: star square branch
// part=5: printable: star triangle branch
// $fn:    Rendering precision
SMOOTH  = 100;
FAST    = 20;
LOWPOLY = 6;
showStarParts ( part=0, sub_part=0, cut=undef, cut_rotation=0, $fn=FAST );
