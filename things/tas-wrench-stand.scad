/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Tubular Angle Socket Wrench Stand
 * Author:      Gilles Bouissac
 * 
 */

use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/extensions.scad>
use <agentscad/mx-screw.scad>
use <agentscad/printing.scad>
use <agentscad/wrench.scad>


// Executes rendering
SMOOTH  = 100;
FAST    = 30;
LOWPOLY = 6;


// wrenches: The stand will be designed for this list of wrenches
// groups:   The stand can be splited into groups
//           This array contains one number per group, this number is the number of
//             wrenches in the group, the count start from first wrench in WRENCHES
//           Set this to undef is you want a single part stand
taswStand (
    wrenches     = 16_WRENCHES,
    groups       = 16_WRENCHES_GROUPS,
    group_num    = undef,
    numbers_only = false,
    $fn          = FAST );


// ----------------------------------------
//                API
// ----------------------------------------

// 10 Tubular Angled Socket Wrenches set
10_WRENCHES        = [ 8,10,11,12,13,14,16,17,18,19 ];
10_WRENCHES_GROUPS = [ 6,4 ];

// 14 Tubular Angled Socket Wrenches set
14_WRENCHES        = [ 8,9,10,11,12,13,14,15,16,17,18,19,20,21 ];
14_WRENCHES_GROUPS = [ 6,4,4 ];

// 16 Tubular Angled Socket Wrenches set
16_WRENCHES        = [ 8,9,10,11,12,13,14,15,16,17,18,19,21,22,23,24 ];
16_WRENCHES_GROUPS = [ 7,5,4 ];


// Special 12 Tubular Angled Socket Wrenches set for PL
12_WRENCHES        = [ 8, 9, 11, 12, 13, 14, 15, 16, 17, 17, 19, 19 ];
12_WRENCHES_GROUPS = [ 7,5 ];


// Vertical offsets between wrenches (perpendicular to ROD axis)
VOFFSET            = 10;

// Horizontal offsets between wrenches (along ROD axis)
HOFFSET            = 5;

// Control the distance of right stand from wrench strait socket
RIGHT_STAND_SHIFT  = 5;

// Distance between wrenches and wall
WALL_DISTANCE      = 5;

// Stand thickness
STAND_THIKNESS     = 3;

// Hook thickness
HOOK_THIKNESS      = 5;

// Hook width around wrenches
HOOK_WIDTH         = 6;

// Angle of hook opening
// We use overhang because the hook is printed back on bed
HOOK_SLOPE         = 90-overhang();

// Horinzontal distance between hooks and screws
SCREW_2_HOOK       = 15;

// Text control
TEXT_SIZE         = 10;
TEXT_THICKNESS    = 0.9;

// Back plate screws control
BACK_PLATE_SCREW = M4();

// ----------------------------------------
//             Implementation
// ----------------------------------------

// Global translation (cumul)
TASW_B   = 4;
function movedElbowCenter( list, i ) = let(
    n     = len(list)-1,
    ddh   = columnSum(list,TASW_B,end=i)
            -getTasWrenchB(list[0])/2
            -getTasWrenchB(list[i])/2,
    ddv   = ddh,
    dvi   = i*VOFFSET,
    dvg   = dvi+ddv,
    dhi   = i*HOFFSET,
    dhg   = dhi+ddh
)[ dhg, 0, dvg, 1 ];

// Creates matrix from vector to a new wrench position
function taswShear(v) = [
	[1,0,v.z==0?0:v.x/v.z,0],
	[0,1,0,0],
	[0,0,1,0],
	[0,0,0,1],
];
function taswTranslation(v) = translation([0,0,v.z]);
function taswRotation(v) = let( a=atan2(v.x,v.z) ) rotation ( [0,a,0]);

function rodHookVector ( wrenchList, i ) = let (
    n                 = len(wrenchList)-1,
    w0                = wrenchList[0],
    wn                = wrenchList[n],
    elbowOriginV_n    = movedElbowCenter(wrenchList,n),
    rod2elbow_0       = [ -RIGHT_STAND_SHIFT
                          -getTasWrenchStraitL(w0)
                          +getTasWrenchElbowCZ(w0)
                          ,0,0],
    rod2elbow_n       = [ -RIGHT_STAND_SHIFT
                          -getTasWrenchStraitL(wn)
                          +getTasWrenchElbowCZ(wn)
                          ,0,0]
) rod2elbow_0 + elbowOriginV_n - rod2elbow_n ;

function elbowHookRotation ( wrenchList, i ) = let (
    n                 = len(wrenchList)-1,
    elbowOriginV_n    = movedElbowCenter(wrenchList,n),
    elbowCenteri      = movedElbowCenter(wrenchList,i),
    elbowRotation     = taswRotation(elbowOriginV_n),
    originTranslation = translation(elbowCenteri),
    elbowR            = getTasWrenchElbowR(wrenchList[i])
) originTranslation*elbowRotation*translation([0,0,elbowR]) ;

function elbowHookShear ( wrenchList, i ) = let (
    n                 = len(wrenchList)-1,
    elbowOriginV_n    = movedElbowCenter(wrenchList,n),
    rodShear          = taswShear(elbowOriginV_n),

    elbowCenteri      = movedElbowCenter(wrenchList,i),
    elbowTranslation  = taswTranslation(elbowCenteri),
    elbowR            = getTasWrenchElbowR(wrenchList[i])
) rodShear*elbowTranslation*translation([0,0,elbowR]) ;

function rodHookShear ( wrenchList, i ) = let (
    n                 = len(wrenchList)-1,
    w0                = wrenchList[0],
    rod2elbow_0       = [ -RIGHT_STAND_SHIFT
                          -getTasWrenchStraitL(w0)
                          +getTasWrenchElbowCZ(w0)
                          ,0,0],
    rodOriginV_n      = rodHookVector(wrenchList, i),
    rodShear          = taswShear(rodOriginV_n),

    elbowCenteri      = movedElbowCenter(wrenchList,i),
    elbowTranslation  = taswTranslation(elbowCenteri),
    rodTranslation    = translation(-rod2elbow_0),
    elbowR            = getTasWrenchElbowR(wrenchList[i])
) rodTranslation*rodShear*elbowTranslation*translation([0,0,elbowR]) ;

function halfHookElbow(wrenchList) = HOOK_THIKNESS/2 ;

function halfHookRod(wrenchList) = let (
    n            = len(wrenchList)-1,
    rodOriginV_n = rodHookVector(wrenchList, n),
    sinangle     = sin(atan2(rodOriginV_n.z,rodOriginV_n.x))
) sinangle==0 ? 0 : (HOOK_THIKNESS/2)/sinangle ;

function backPlateTopPt1( wrenchList, i, gap=0 ) = let (
    w      = wrenchList[i],
    half_t = halfHookRod(wrenchList),
    pt = rodHookShear(wrenchList,i)*translation([-half_t,0,
        +hookProfileHA(w,getTasWrenchDE1(w)+2*gap())] )*[0,0,gap,1]
) pt ;

function backPlateTopPt2( wrenchList, i, gap=0 ) = let (
    w      = wrenchList[i],
    half_t = halfHookRod(wrenchList),
    pt = rodHookShear(wrenchList,i)*translation([+half_t,0,
        +hookProfileHA(w,getTasWrenchDE1(w)+2*gap())] )*[0,0,gap,1]
) pt ;

function backPlateTopPt3( wrenchList, i, gap=0 ) = let (
    w      = wrenchList[i],
    half_t = halfHookElbow(),
    pt = elbowHookRotation(wrenchList,i)*translation([-half_t,0,
        +hookProfileHA(w,getTasWrenchDE2(w)+2*gap())] )*[0,0,gap,1]
) pt ;

function backPlateTopPt4( wrenchList, i, gap=0 ) = let (
    w      = wrenchList[i],
    half_t = halfHookElbow(),
    pt = elbowHookRotation(wrenchList,i)*translation([+half_t,0,
        +hookProfileHA(w,getTasWrenchDE2(w)+2*gap())] )*[0,0,gap,1]
) pt ;

function backPlateBotPt1( wrenchList, i ) = let (
    w      = wrenchList[i],
    half_t = halfHookRod(wrenchList),
    pt = rodHookShear(wrenchList,i)*translation([-half_t,0,
         -hookProfileHB(w,getTasWrenchDE1(w)+2*gap())] )*[0,0,0,1]
) pt ;

function backPlateBotPt2( wrenchList, i ) = let (
    w      = wrenchList[i],
    half_t = halfHookElbow(),
    pt = elbowHookRotation(wrenchList,i)*translation([+half_t,0,
         -hookProfileHB(w,getTasWrenchDE2(w)+2*gap())] )*[0,0,0,1]
) pt ;

// 2 Screws on first and last wrench
module taswBackPlateHollow ( wrenchList, i0, i1 ) {
    w0 = wrenchList[i0];
    w1 = wrenchList[i1];
    profileCenterH0 = -hookProfileHB(w0)+(hookProfileHB(w0)+hookProfileHA(w0))/2;
    profileCenterH1 = -hookProfileHB(w1)+(hookProfileHB(w1)+hookProfileHA(w1))/2;

    screw = BACK_PLATE_SCREW;
    translate ( take3(translation([+SCREW_2_HOOK,0,0])*
        rodHookShear( wrenchList, i0 )*[0,0,profileCenterH0,1]) )
        rotate( [90,0,0] )
        mxBoltAllenPassage( screw );
    translate ( take3(translation([-SCREW_2_HOOK,0,0])*
        elbowHookShear( wrenchList, i0 )*[0,0,profileCenterH0,1]) )
        rotate( [90,0,0] )
        mxBoltAllenPassage( screw );

    translate ( take3(translation([+SCREW_2_HOOK,0,0])*
        rodHookShear( wrenchList, i1 )*[0,0,profileCenterH1,1]) )
        rotate( [90,0,0] )
        mxBoltAllenPassage( screw );
    translate ( take3(translation([-SCREW_2_HOOK,0,0])*
        elbowHookShear( wrenchList, i1 )*[0,0,profileCenterH1,1]) )
        rotate( [90,0,0] )
        mxBoltAllenPassage( screw );
}

module taswBackPlate ( wrenchList, i0, i1, color ) {
    top = [
        backPlateTopPt4( wrenchList,i1 ),
        backPlateTopPt3( wrenchList,i1 ),
        backPlateTopPt2( wrenchList,i1 ),
        backPlateTopPt1( wrenchList,i1 ),
    ];
    bottom = i0==0 ? [
        backPlateBotPt1( wrenchList,i0 ),
        backPlateBotPt2( wrenchList,i0 ),
    ]:[
        backPlateTopPt1( wrenchList,i0-1,gap() ),
        backPlateTopPt2( wrenchList,i0-1,gap() ),
        backPlateTopPt3( wrenchList,i0-1,gap() ),
        backPlateTopPt4( wrenchList,i0-1,gap() ),
    ];

    face = concat(top,bottom);
    difference() {
        color( color )
        skin([
            transform ( translation([0,+0,0]),face),
            transform ( translation([0,-STAND_THIKNESS,0]),face),
        ]);
        taswBackPlateHollow ( wrenchList, i0, i1 );
        %taswBackPlateHollow ( wrenchList, i0, i1 );
    }
}

function groupColor(g,n) = [0,g/n,0.4];

module taswStand ( wrenches, numbers_only=false, groups=undef, group_num ) {
    wrenchList = [ for ( a=wrenches ) newTasWrench(a) ];
    n    = len(wrenchList)-1;

    lgroups = is_undef(groups)?[len(wrenchList)]:groups;

    // Sanity check: The groups must consume all the wrenches
    assert( columnSum(lgroups)==len(wrenchList),
        "When groups is not equal to undef, the sum of number in this array must be equal to the number of elements in wrenches" );

    elbowOriginV_n = movedElbowCenter(wrenchList,n);
    alignOnVector([-elbowOriginV_n.x,0,elbowOriginV_n.z]) {

        if ( is_undef(group_num) )
            for ( g=[0:len(lgroups)-1] ) let (
                start = columnSum(lgroups,end=g-1),
                end=start+lgroups[g]-1>n?n:start+lgroups[g]-1 )
                if ( numbers_only ) 
                    taswStandGroupNumbers( wrenchList, start, end );
                else
                    difference() {
                        taswStandGroup ( wrenchList, start, end, groupColor(g,len(lgroups)) );
                        taswStandGroupNumbers( wrenchList, start, end );
                    }
        else let ( g=group_num,
            check=assert(g>=0 && g<=len(lgroups)-1, str("group_num must be in range [",0,"-",len(lgroups)-1,"]") ),
            start = columnSum(lgroups,end=g-1),
            end=start+lgroups[g]-1>n?n:start+lgroups[g]-1 )
            if ( numbers_only ) 
                taswStandGroupNumbers( wrenchList, start, end );
            else
                difference() {
                    taswStandGroup ( wrenchList, start, end, groupColor(g,len(lgroups)) );
                    taswStandGroupNumbers( wrenchList, start, end );
                }
    }
}

module taswStandGroupNumbers ( wrenchList, i0, i1 ) {
    n          = len(wrenchList)-1;
    wn         = wrenchList[n];

    for ( i=[i0:i1] ) {
        w    = wrenchList[i];

        profileCenterH = -hookProfileHB(w)+(hookProfileHB(w)+hookProfileHA(w))/2;
        elbowCenter = elbowHookShear( wrenchList, i )*[0,0,profileCenterH,1];
        rodCenter = rodHookShear( wrenchList, i )*[0,0,profileCenterH,1];
        translate ( take3((elbowCenter+rodCenter)/2)-[0,TEXT_THICKNESS-mfg(),0] )
            rotate( [90,0,180] )
            linear_extrude(TEXT_THICKNESS)
            text( str(getTasWrenchA(w)),
                font="Calibri:style=Bold",
                size=TEXT_SIZE,
                valign="center", halign="center" );
    }
}

module taswStandGroup ( wrenchList, i0, i1, color="yellow" ) {
    n          = len(wrenchList)-1;
    w0         = wrenchList[0];
    wn         = wrenchList[n];

    // Estimation of total heigh of the group
    group_lowest  = backPlateBotPt1(wrenchList,i0);
    group_highest = backPlateTopPt4(wrenchList,i1);
    diagonal_group = norm(group_highest-group_lowest);

    total_lowest  = backPlateBotPt1(wrenchList,0);
    total_highest = backPlateTopPt4(wrenchList,n);
    diagonal_total = norm(total_highest-total_lowest);

    echo ( "diagonal of the group: ", diagonal_group );
    echo ( "diagonal of the complete stand: ", diagonal_total );

    // Draw elbow hooks
    elbowOriginV_n = movedElbowCenter(wrenchList,n);
    elbowShear     = taswShear(elbowOriginV_n);
    color( color )
    for ( i=[i0:i1] )
        let (
            w       = wrenchList[i],
            profile = hookProfile(w,getTasWrenchDE2(w)+2*gap()),
            half_t  = halfHookElbow()
        )
        skin([
            transform ( elbowHookRotation(wrenchList,i)*translation([+half_t,0,0]),profile),
            transform ( elbowHookRotation(wrenchList,i)*translation([-half_t,0,0]),profile),
        ]);

    // Draw rod hooks
    // The rod hook origin is called rodOrigin
    color( color )
    for ( i=[i0:i1] )
        let (
            w            = wrenchList[i],
            profile      = hookProfile(w,getTasWrenchDE1(w)+2*gap()),
            half_t       = halfHookRod(wrenchList)
        )
        skin([
            transform ( rodHookShear(wrenchList,i)*translation([+half_t,0,0]),profile),
            transform ( rodHookShear(wrenchList,i)*translation([-half_t,0,0]),profile),
        ]);

    // Draw the backplates
    taswBackPlate ( wrenchList, i0, i1, color );

    // Draw the wrenches for visual check
%   for ( i=[i0:i1] )
        let (
            w=wrenchList[i],
            elbowCenteri = movedElbowCenter(wrenchList,i),
            elbowTranslation=taswTranslation(elbowCenteri),
            origin = take3(elbowShear*elbowTranslation*[0,0,0,1])
        )
        translate( origin )
        translate( [0,getTasWrenchB(w)/2+WALL_DISTANCE,0] )
        scale( [1,1,1] )
            rotate( [0,90,0] )
            tasWrench(w);

}

// Profile height above and below 0
PROFILE_STOP_A = 80;
function hookProfileHA( w, dy ) = let(
    ldy=forceValueInRange(dy,1,defv=getTasWrenchDE1(w)+2*gap()),
    ry=ldy/2,
    h=getTasWrenchB(w)/2+WALL_DISTANCE-ry
) h ;
function hookProfileHB( w, dz ) = let(
    ldz = forceValueInRange(dz,1,defv=getTasWrenchDE1(w)+2*gap()),
    rz  = ldz/2,
    r5  = getTasWrenchB(w)/2,
    h   = rz+HOOK_WIDTH+getTasWrenchB(w)/2-r5*sin(90-PROFILE_STOP_A)
) h ;

function hookProfile( w, dy=undef, dz=undef ) = let (
    da  = -HOOK_SLOPE,
    r2y = forceValueInRange(dy,1,defv=getTasWrenchDE1(w)+2*gap()) /2,
    r2z = forceValueInRange(dz,1,defv=2*r2y) /2,
    c2  = [0,getTasWrenchB(w)/2+WALL_DISTANCE,0 ],
    c1  = [0,0,0],
    r1y = c2.y-r2y,
    r1z = hookProfileHA( w, 2*r2y ),
    r3  = HOOK_WIDTH/2,
    c3  = c2+[ 0, (r2y+r3)*cos(da), (r2z+r3)*sin(da)],
    r4y = r2y+HOOK_WIDTH,
    r4z = r2z+HOOK_WIDTH,
    c4  = c2,
    r5  = getTasWrenchB(w)/2,
    c5  = [0, r5, -hookProfileHB( w, 2*r2z )]
)[
    [0,-STAND_THIKNESS,r1z],
    for ( s=[0:getStep(4):1] )
        c1 + [0,r1y*cos(90-90*s),r1z*sin(90-90*s)]
    ,
    for ( s=[0:getStep(2):1] )
        c2 + [0,r2y*cos(-180+(180-HOOK_SLOPE)*s),r2z*sin(-180+(180-HOOK_SLOPE)*s)]
    ,
    for ( s=[0:getStep(2):1] )
        c3 + [ [0,0,0], [0,cos(da),-sin(da)], [0,sin(da),cos(da)]]*
                [0,r3*cos(180-180*s),0.6*r3*sin(180-180*s)
            ]
    ,
    for ( s=[0:getStep(4):1] ) let ( ra=90+da )
        c4 + [0,r4y*cos(da-ra*s),r4z*sin(da-ra*s)]
    ,
    for ( s=[0:getStep(2):1] )
        c5 + [0,r5*cos(90+PROFILE_STOP_A*s),r5*sin(90+PROFILE_STOP_A*s)]
    ,
    [0,-STAND_THIKNESS,c5.z],
];

