/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Christmas tree for office
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
use <agentscad/things/snap-star.scad>

// ----------------------------------------
//                   API
// ----------------------------------------

// part=0: all
// part=1: tree branch adjusing
// part=2: tree branch
// part=3: tree stand core
// part=4: tree stand root
// part=5: top end
// part=6: top star branches
// part=7: top star core
// part=8: top star stand
// sub_part: branch number in range [0:BRANCH_NB]
//           see logs (ECHO: "NB Branches: "...) for BRANCH_NB value
// $fn:    Rendering precision
// $layer: Print layer thickness
SMOOTH  = 100;
FAST    = 20;
LOWPOLY = 6;
showParts ( part=6, sub_part=0, $fn=SMOOTH, $layer=0.3 );


// ----------------------------------------
//             Implementation
// ----------------------------------------

// Height of the branches stack
TREE_H        = 450;

// Radius of axis Rod
AXIS_R        = 4;

// Rings that form the trunk on a branch
TRUNK_R_MAX   = 15;
TRUNK_RING_T  = 10;

// Waves Width and Frequency around the trunk cylinder
TRUNK_WAVE_W  = 0.4;
TRUNK_WAVE_F  = 15;

TOOTH_W            = 2;
TOOTH_L            = 10;

BRANCH_T_MAX       = 5;
BRANCH_T_MIN       = 3;
BRANCH_A           = 65;
BRANCH_W_MAX       = 15;
BRANCH_FRONT_L_MAX = 180;
BRANCH_BACK_L_MAX  = 13;
BRANCH_B           = 0.6; // Bevel

LOCK_R             = 1.5;

TRUNK_R_MIN            = AXIS_R+3*nozzle()+2*LOCK_R;
BRANCH_W_MIN           = 2*TOOTH_W+4;
BRANCH_FRONT_L_MIN     = TRUNK_R_MIN+2*TOOTH_L;
BRANCH_BACK_L_MIN      = TRUNK_R_MIN;

BRANCH_NB              = floor(TREE_H/TRUNK_RING_T);
BRANCH_PER_ROTATION_NB = (360/BRANCH_A);
ROTATION_NB            = BRANCH_NB/BRANCH_PER_ROTATION_NB;

// Sub branches
SUB_BRANCH_DIST_COUNT = 3;
SUB_BRANCH_OPEN_A     = 60;
SUB_BRANCH_L_MIN      = 1*TOOTH_L;

// Stand
ROOTS_NB = 5;   // Number of roots

ROOT_B = 1;     // Root profile base cut
ROOT_R = 15;    // Root profile radius
ROOT_A = 20;    // Root profile stop angle

ROOT_LENGTH    = BRANCH_FRONT_L_MAX*0.75;
ROOT_WAVE_W    = 9;
ROOT_WAVE_F_T  = 2*360; // Translation wave frequency
ROOT_WAVE_F_S  = 3*710; // Scaling wave frequency
ROOT_SCALE_MAX = 1.0;
ROOT_SCALE_MIN = 0.3;

STAND_R      = TRUNK_R_MAX;
STAND_H      = 75;
STAND_AXIS_H = 50;

STAND_CUT_R      = STAND_R+10;
STAND_CUT_H      = 35;
STAND_CUT_CONE_H = STAND_H-STAND_CUT_H+TRUNK_RING_T;
STAND_HOOK_R     = 3;

TOP_L      = 50;
TOP_AXIS_H = 40;

STAR_CELL_W      = 15;
STAR_LBRANCH_L   = 56;
STAR_SBRANCH_L   = STAR_LBRANCH_L/2;
STAR_BRANCH_T    = 3*nozzle();
STAR_FORM_FACTOR = 2.3;

echo( "NB Branches:     ", BRANCH_NB );
echo( "Stages (mm):     ", TREE_H/ROTATION_NB );
echo( "ROD length (mm): ", STAND_AXIS_H+TREE_H+TOP_AXIS_H );

function getTrunkRingT() = TRUNK_RING_T;
function getBranchA()    = BRANCH_A;
function getBranchNb()   = BRANCH_NB;

function branchLengthToWidth ( length ) =
let(
    ratio = (length-BRANCH_FRONT_L_MIN)/(BRANCH_FRONT_L_MAX - BRANCH_FRONT_L_MIN )
) BRANCH_W_MIN + ratio*(BRANCH_W_MAX - BRANCH_W_MIN );;

function branchColor(num) =
let(
    r_range = 0.5,
    r_start = 0.05,
    g_range = 0.90,
    g_start = 0.1,
    b_range = 0.5,
    b_start = 0.05,
    c_ratio = num/BRANCH_NB
)
[c_ratio*r_range+r_start,c_ratio*g_range+g_start,c_ratio*b_range+b_start];

function combToothProfile ( height=TOOTH_W, width=TOOTH_L ) =
    let ( step = 4*getStep() )
    [ for ( a=[0.01:step:0.99] ) [ width*a, height*cos(a*360)/2+TOOTH_W/2 ] ];

function combProfile ( teeth ) =
    flatten ([
        if ( teeth>0 )
            for ( i=[0:teeth-1] )
                transform(
                    translation([i*TOOTH_L-teeth*TOOTH_L/2,0,0]),
                    combToothProfile( width=TOOTH_L )
                )
    ])
;

function branchHalfProfile ( trunk, width, lfront, lback ) =
let (
    comb_start_a  = asin( (width/2)/trunk ),
    comb_start    = max(0,trunk*cos(comb_start_a)),
    branch_axis_w = width-2*TOOTH_W,
    front_l       = max(comb_start,lfront),
    front_teeth   = floor((front_l-comb_start)/TOOTH_L),
    front_tl      = front_teeth*TOOTH_L,
    front_off     = front_l-front_tl,
    back_l        = max(comb_start,lback),
    back_teeth    = floor((back_l-comb_start)/TOOTH_L),
    back_tl       = back_teeth*TOOTH_L,
    back_off      = back_l-back_tl,
    step          = 360*getStep()
)
concat (
    // Rounded back
    transform(
        translation([-back_tl-back_off,0,0]),
        [ for ( a=[179.9:-step:90.1] )
                [ width/2*cos(a), width/2*sin(a) ] ]
    ),
    // Back comb
    transform(
        translation([-back_tl/2-back_off,branch_axis_w/2,0]),
        combProfile(back_teeth)
    ),
    // Front comb
    transform(
        translation([+front_tl/2+front_off,branch_axis_w/2,0]),
        combProfile(front_teeth)
    ),
    // Rounded front
    transform(
        translation([+front_tl+front_off,0,0]),
        [ for ( a=[89.9:-step:0.1] )
                [ width/2*cos(a), width/2*sin(a) ] ]
    )
);

function branchProfile ( trunk, width, lfront, lback ) =
    to_2d ( concat(
        branchHalfProfile( trunk, width, lfront, lback ),
        reverse(transform( scaling([1,-1,1]),
            branchHalfProfile( trunk, width, lfront, lback )
        ))
    ));

function rootProfile () =
let (
    step          = -360*getStep()
)
to_2d ( concat (
    // Rounded back
    transform(
        translation([-ROOT_R+ROOT_B,0,0]),
        [ for ( a=[360:step:ROOT_A] )
            let ( radius=ROOT_R+TRUNK_WAVE_W*cos(TRUNK_WAVE_F*a) )
            [ radius*cos(a), radius*sin(a) ]
        ]
    )
));
        
function rootScale(t,num) =
let (
    tl = t>1 ? 1 : t
) (ROOT_SCALE_MAX*(1-tl)+ROOT_SCALE_MIN*tl+0.05*cos(t*ROOT_WAVE_F_S))*pow(1-tl,0.2);

function rootPath(t,num) =let (
    tl = t>1 ? 1 : t
) [tl*ROOT_LENGTH, ROOT_WAVE_W*sin(pow(tl,1.5)*(ROOT_WAVE_F_T)), 0 ];

function trunkProfile ( trunk ) =
let (
    step          = 360*getStep()
)
concat (
    // Trunk
    transform(
        translation([0,0,0]),
        [ for ( a=[0:step:360-0.1] )
            let ( radius=trunk+TRUNK_WAVE_W*cos(TRUNK_WAVE_F*a) )
            [ radius*cos(a), radius*sin(a) ]
        ]
    )
);

function subBranchHalfProfile ( width, lfront ) =
let (
    branch_axis_w = width-2*TOOTH_W,
    front_l       = lfront,
    front_teeth   = floor(front_l/TOOTH_L),
    front_tl      = front_teeth*TOOTH_L,
    front_off     = lfront-front_tl,
    step          = 360*getStep()
)
concat (
    // Rounded back
    transform(
        translation([0,0,0]),
        [ for ( a=[179.9:-step:90.1] )
                [ width/2*cos(a), width/2*sin(a) ] ]
    ),
    // Comb
    transform(
        translation([+front_tl/2+front_off,branch_axis_w/2,0]),
        combProfile(front_teeth)
    ),
    // Rounded front
    transform(
        translation([front_tl+front_off,0,0]),
        [ for ( a=[89.9:-step:0.1] )
                [ width/2*cos(a), width/2*sin(a) ] ]
    )
);

function subBranchProfile ( width, lfront ) =
    to_2d ( concat(
        subBranchHalfProfile( width, lfront ),
        reverse(transform( scaling([1,-1,1]),
            subBranchHalfProfile( width, lfront )
        ))
    ));

// Recursive sub-branches
module subBranches ( width, lfront, thickness=BRANCH_T_MAX ) {
    local_dist = SUB_BRANCH_DIST_COUNT*width;

    ts = tan(SUB_BRANCH_OPEN_A);
    tb = tan(BRANCH_A/2);
    nb_sub = floor(lfront/local_dist);
    if ( nb_sub>0 )
        for ( isub=[0:nb_sub-1] ) {
            dist = (isub+1)*local_dist;

            y = dist*ts*tb/(ts-tb);
            sub_l_to_neighbor  = y/sin(SUB_BRANCH_OPEN_A)-width;

            a    = (1+ts*ts);
            b    = (2*dist*ts*ts);
            c    = dist*dist*ts*ts - lfront*lfront;
            disc = b*b-4*a*c;
            x    = ( b + sqrt(disc) )/(2*a);
            sub_l_to_border = ( x - dist )*ts/sin(SUB_BRANCH_OPEN_A);

            sub_l = min(sub_l_to_neighbor,sub_l_to_border);
            sub_w = branchLengthToWidth(sub_l);

            if ( sub_l>SUB_BRANCH_L_MIN ) {
                translate( [dist,0,0] )
                    rotate( [0,0,+SUB_BRANCH_OPEN_A] )
                    subBranch( sub_w, sub_l, thickness );
                translate( [dist,0,0] )
                    rotate( [0,0,-SUB_BRANCH_OPEN_A] )
                    subBranch( sub_w, sub_l, thickness );
            }
        }
}

module subBranch ( width, lfront, thickness=BRANCH_T_MAX ) {
    profile       = subBranchProfile(width,lfront);
    profile_bevel = subBranchProfile(width-2*BRANCH_B,lfront);
    if ( BRANCH_B==0 ) {
        skin ([
            transform(translation([0,0,thickness]),profile),
            profile
        ]);
    }
    else {
        skin ([
            transform(translation([0,0,thickness]),profile_bevel),
            transform(translation([0,0,thickness-BRANCH_B]),profile),
            transform(translation([0,0,BRANCH_B]),profile),
            profile_bevel
        ]);
    }
}

module lock ( trunk, thickness=BRANCH_T_MAX ) {
    radius = trunk-LOCK_R-TRUNK_WAVE_W;
    rotate( [0,0,BRANCH_A ] )
        translate ( [ radius,0,BRANCH_B ] )
        cylinder( r=LOCK_R, h=TRUNK_RING_T-BRANCH_B+thickness-2*layer()-gap() );
    rotate( [0,0,180+BRANCH_A ] )
        translate ( [ radius,0,BRANCH_B ] )
        cylinder( r=LOCK_R, h=TRUNK_RING_T-BRANCH_B+thickness-2*layer()-gap() );
}

module lock_hole ( trunk, thickness=BRANCH_T_MAX ) {
    radius = trunk-LOCK_R-TRUNK_WAVE_W;
    translate ( [ -radius,0,0 ] )
        cylinder( r=LOCK_R+gap(), h=thickness-2*layer() );
    translate ( [ +radius,0,0 ] )
        cylinder( r=LOCK_R+gap(), h=thickness-2*layer() );
}

module trunkSlice ( trunk, thickness=TRUNK_RING_T ) {
    trunkPrf       = trunkProfile ( trunk );
    step           = getStep();
    frequency      = (TRUNK_WAVE_F*thickness)/(2*PI*trunk);
    skin (concat (
        [ for ( i=[0:step:1+0.01] )
            let (
                wave_w_scale = TRUNK_WAVE_W/trunk,
                sx = 1+wave_w_scale*(1+cos(frequency*(180-360*i) )),
                sy = 1+wave_w_scale*(1+cos(frequency*(180-360*i)))
            )
            transform(translation([0,0,i*thickness])*scaling([sx,sy,1]),trunkPrf)
        ]
    ));
}

module branch ( num=0 ) {
    last = BRANCH_NB-1;
    local_num = max ( 0, min ( num, last ) );
    if ( local_num!=num ) {
        echo( "ERROR: invalid branch num: ", num, " min=", 0, " max=", last );
        color( "red" ) cylinder( r=TRUNK_R_MAX, h=TRUNK_RING_T );
    }
    else {
        ratio     = (last-local_num)/last;
        trunk     = TRUNK_R_MIN  + ratio*(TRUNK_R_MAX  - TRUNK_R_MIN  );
        lfront    = BRANCH_FRONT_L_MIN + ratio*(BRANCH_FRONT_L_MAX - BRANCH_FRONT_L_MIN );
        lback     = BRANCH_BACK_L_MIN  + ratio*(BRANCH_BACK_L_MAX  - BRANCH_BACK_L_MIN );
        thickness = BRANCH_T_MIN  + ratio*(BRANCH_T_MAX  - BRANCH_T_MIN );
        width     = branchLengthToWidth(lfront);

        next_num       = local_num==last ? local_num : local_num+1 ;
        next_ratio     = (last-next_num)/last;
        next_thickness = BRANCH_T_MIN  + next_ratio*(BRANCH_T_MAX  - BRANCH_T_MIN );
        next_trunk     = TRUNK_R_MIN   + next_ratio*(TRUNK_R_MAX   - TRUNK_R_MIN  );

        echo(
            "Branch: ",     local_num,
            ", width:",     width,
            ", trunk:",     trunk,
            ", length:",    lfront+lback+width,
            ", thickness:", thickness
        );

        // Main branch
        color( branchColor(local_num) ) {
            difference() {
                union() {
                    profile       = branchProfile(trunk,width,lfront,lback);
                    profile_bevel = branchProfile(trunk-BRANCH_B,width-2*BRANCH_B,lfront,lback);
                    if ( BRANCH_B==0 ) {
                        skin ([
                            transform(translation([0,0,thickness]),profile),
                            profile
                        ]);
                    }
                    else {
                        skin ([
                            transform(translation([0,0,thickness]),profile_bevel),
                            transform(translation([0,0,thickness-BRANCH_B]),profile),
                            transform(translation([0,0,BRANCH_B]),profile),
                            profile_bevel
                        ]);
                    }

                    trunkSlice ( trunk );
                }
                lock_hole( trunk, thickness );
                cylinder( r=AXIS_R+gap(), h=TRUNK_RING_T+thickness );
            } 
            lock( next_trunk, next_thickness );
            subBranches( width, lfront, thickness );
        }
    }
}

module topShape( dradius=0 ) {
    radius  = TRUNK_R_MIN+2*nozzle()+dradius;
    step    = getStep();
    height  = TOP_L;
    profile = [ for ( a=[0:step:1] ) [ radius*cos(-a*360), radius*sin(-a*360) ] ];
    path_transforms = [
        for (t=[0:step:1])
            translation([0,0,height*t]) *
            scaling([pow(1-t,1/3),pow(1-t,1/3),1])
    ];
    sweep ( profile, path_transforms );
}

module top() {
    difference() {
        topShape();
        cylinder( r=AXIS_R+gap(), h=TOP_AXIS_H );
        lock_hole(TRUNK_R_MIN,BRANCH_T_MIN);
    }
}

module root( num=0 ) {
    step    = getStep();
    profile = rootProfile();
    path_transforms = [
        for (t=[0:step:1])
            translation(rootPath(t,num)) *
            scaling([1,0.8*rootScale(t,num), 1.5*rootScale(t,num)]) *
            rotation([0,90,0])
    ];
    intersection() {
        sweep ( profile, path_transforms );
        translate( [0,0,STAND_H/2] )
            cube( [1000,1000,STAND_H], center=true );
    }
}

module tree() {
    last = BRANCH_NB-1;
    for ( i=[0:last] ) {
        translate( [0,0,i*(TRUNK_RING_T)] )
        rotate( [0,0,i*BRANCH_A ] )
            branch ( i );
    }
}

module stand() {
    difference() {
        union() {
            for ( i=[0:ROOTS_NB-1] )
                rotate( [0,0,(i/ROOTS_NB)*360] )
                    root(i);
            trunkSlice ( STAND_R, STAND_H );

        }
        translate( [0,0,STAND_H-STAND_AXIS_H] )
            cylinder( r=AXIS_R+gap(), h=STAND_H );
    }
    trunk     = TRUNK_R_MAX;
    thickness = BRANCH_T_MAX;
    translate( [0,0,STAND_H-TRUNK_RING_T] )
        lock(trunk, thickness);
}

module standCut( gap=0 ) {
    // make sure fn is a multiple of 5 to get 5 identical roots
    $fn = 5*floor(1+$fn/5);
    difference() {
        union() {
            cylinder( r=STAND_CUT_R+gap, h=STAND_CUT_H );
            translate( [0,0,STAND_CUT_H] )
                cylinder(
                    r1=STAND_CUT_R+gap,
                    r2=STAND_CUT_R+2*(STAND_CUT_CONE_H*cos(30))+gap,
                    h=STAND_CUT_CONE_H
                );
        }

        for ( i=[0:ROOTS_NB-1] )
            rotate( [0,0,(i/ROOTS_NB)*360] )
            translate( [0,STAND_CUT_R-1.5*STAND_HOOK_R,0] ) {
                cylinder( r=STAND_HOOK_R-gap, h=STAND_CUT_H );
                translate( [0,STAND_HOOK_R,STAND_CUT_H/2] )
                    cube ( [STAND_HOOK_R-2*gap,2*STAND_HOOK_R,STAND_CUT_H],center=true );
        }
    }
}

module standCore () {
    color( "Sienna" )
    intersection() {
        stand();
        standCut();
    }
}

module standRoot () {
    color( "Sienna" )
    difference() {
        root(0);
        standCut( gap() );
    }
}

module treeStarStand (star) {
    difference() {
        union() {
            snapStarLongBranch( star );
            translate( [0,0,TOP_L] )
                rotate ( [180,0,0] )
                topShape( gap()+getStarWallT(star) );
        }
        translate( [0,0,TOP_L] )
            rotate ( [180,0,0] ) {
                translate( [0,0,-TOP_AXIS_H] )
                    cylinder( r=AXIS_R+gap(), h=2*TOP_AXIS_H );
                lock_hole(TRUNK_R_MIN,BRANCH_T_MIN);
            }
    }
}

// ----------------------------------------
//                Showcase
// ----------------------------------------

module showParts (part=0, sub_part=0) {
    star = newStar( STAR_CELL_W, STAR_LBRANCH_L, STAR_SBRANCH_L, STAR_BRANCH_T, STAR_FORM_FACTOR );
    if ( part==0 ) {
        // All with less precision
        tree( $fn=LOWPOLY );
        translate( [0,0,-STAND_H-gap()] ) {
            standCore( $fn=LOWPOLY );
            for ( i=[0:ROOTS_NB-1] )
                rotate( [0,0,(i/ROOTS_NB)*360] )
                    standRoot( $fn=LOWPOLY );
        }
*        color( branchColor(BRANCH_NB-1) )
            translate( [100,0,TREE_H] )
            top( $fn=LOWPOLY );
        color ( "yellow", 1 )
            translate( [0,0,getStarCoreH(star)/2+TOP_L+TREE_H] )
            snapStarRosace( star, $fn=LOWPOLY )
                treeStarStand( star, $fn=LOWPOLY );
    }
    else if ( part==1 ) {
        // Branch adjusting on just 3 branches full precision
        separator=3;
        color("white") {
            branch( sub_part );
            translate( [0,0,TRUNK_RING_T+1*separator] )
                rotate( [0,0,1*BRANCH_A ] )
                branch( sub_part+1 );
            translate( [0,0,2*TRUNK_RING_T+2*separator] )
                rotate( [0,0,2*BRANCH_A ] )
                branch( sub_part+2 );
        }
        rotate( [0,0,-BRANCH_A] )
            translate( [0,0,-STAND_H-1*separator] ){
                standCore();
                for ( i=[0:ROOTS_NB-1] )
                    rotate( [0,0,(i/ROOTS_NB)*360] )
                        standRoot();
            }
    }
    else if ( part==2 ) {
        // Branch alone
        branch( sub_part );
    }
    else if ( part==3 ) {
        // Stand core
        standCore();
    }
    else if ( part==4 ) {
        // Stand root
        standRoot();
    }
    else if ( part==5 ) {
        // Top end
        top();
    }
    else if ( part==6 ) {
        // All branches on a single bed
        snapStarAllBranches(star);
        % translate([0,0,-1]) // Image of the printer bed
            cube( [ printVolume().x, printVolume().y, 1 ], center=true );
    }
    else if ( part==7 ) {
        // Star core
        snapStarCore(star);
    }
    else if ( part==8 ) {
        // Star stand
        translate( [0,0,TOP_L] )
            rotate( [180,0,0] )
            treeStarStand(star);
    }
}


