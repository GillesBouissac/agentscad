/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - polygons
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <scad-utils/transformations.scad>
include <creeper_svg.scad>

// Returns the raw polygon transformed so that face center is [0,0]
function normalizeHeadFace( polys ) = let (
    HEAD_OFFSET = [ 0, -4, 0]
) [
    for ( p=polys )
        transform(translation(HEAD_OFFSET)*scaling([1,-1,1]),p)
];

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Head - front face polygons
//
HEAD_FRONT_BLACK = [
    frontHeadBlack_0_points, frontHeadBlack_1_points, frontHeadBlack_2_points, frontHeadBlack_3_points, frontHeadBlack_4_points, frontHeadBlack_5_points,
    frontHeadBlack_6_points, frontHeadBlack_7_points
];
HEAD_FRONT_GREY = [
    frontHeadGrey_0_points, frontHeadGrey_1_points, frontHeadGrey_2_points, frontHeadGrey_3_points, frontHeadGrey_4_points, frontHeadGrey_5_points,
    frontHeadGrey_6_points, frontHeadGrey_7_points, frontHeadGrey_8_points
];
HEAD_FRONT_GREEN1 = [
    frontHeadGreen1_0_points, frontHeadGreen1_1_points, frontHeadGreen1_2_points, frontHeadGreen1_3_points, frontHeadGreen1_4_points, frontHeadGreen1_5_points,
    frontHeadGreen1_6_points, frontHeadGreen1_7_points, frontHeadGreen1_8_points, frontHeadGreen1_9_points, frontHeadGreen1_10_points, frontHeadGreen1_11_points
];
HEAD_FRONT_GREEN2 = [
    frontHeadGreen2_0_points, frontHeadGreen2_1_points, frontHeadGreen2_2_points, frontHeadGreen2_3_points, frontHeadGreen2_4_points, frontHeadGreen2_5_points,
    frontHeadGreen2_6_points, frontHeadGreen2_7_points, frontHeadGreen2_8_points, frontHeadGreen2_9_points, frontHeadGreen2_10_points, frontHeadGreen2_11_points,
    frontHeadGreen2_12_points, frontHeadGreen2_13_points, frontHeadGreen2_14_points
];
HEAD_FRONT_GREEN3 = [
    frontHeadGreen3_0_points, frontHeadGreen3_1_points, frontHeadGreen3_2_points, frontHeadGreen3_3_points, frontHeadGreen3_4_points, frontHeadGreen3_5_points,
    frontHeadGreen3_6_points, frontHeadGreen3_7_points, frontHeadGreen3_8_points, frontHeadGreen3_9_points, frontHeadGreen3_10_points, frontHeadGreen3_11_points,
    frontHeadGreen3_12_points, frontHeadGreen3_13_points, frontHeadGreen3_14_points, frontHeadGreen3_15_points, frontHeadGreen3_16_points, frontHeadGreen3_17_points,
    frontHeadGreen3_18_points, frontHeadGreen3_19_points
];
function getFrontHeadBlackRings()  = normalizeHeadFace( HEAD_FRONT_BLACK );
function getFrontHeadGreyRings()   = normalizeHeadFace( HEAD_FRONT_GREY );
function getFrontHeadGreen1Rings() = normalizeHeadFace( HEAD_FRONT_GREEN1 );
function getFrontHeadGreen2Rings() = normalizeHeadFace( HEAD_FRONT_GREEN2 );
function getFrontHeadGreen3Rings() = normalizeHeadFace( HEAD_FRONT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Head - right face polygons
//
HEAD_RIGHT_GREY = [
    rightHeadGrey_0_points, rightHeadGrey_1_points, rightHeadGrey_2_points, rightHeadGrey_3_points, rightHeadGrey_4_points, rightHeadGrey_5_points,
    rightHeadGrey_6_points, rightHeadGrey_7_points, rightHeadGrey_8_points
];
HEAD_RIGHT_GREEN2 = [
    rightHeadGreen2_0_points, rightHeadGreen2_1_points, rightHeadGreen2_2_points, rightHeadGreen2_3_points, rightHeadGreen2_4_points, rightHeadGreen2_5_points,
    rightHeadGreen2_6_points, rightHeadGreen2_7_points, rightHeadGreen2_8_points, rightHeadGreen2_9_points, rightHeadGreen2_10_points, rightHeadGreen2_11_points,
    rightHeadGreen2_12_points, rightHeadGreen2_13_points, rightHeadGreen2_14_points, rightHeadGreen2_15_points, rightHeadGreen2_16_points, rightHeadGreen2_17_points,
    rightHeadGreen2_18_points, rightHeadGreen2_19_points, rightHeadGreen2_20_points, rightHeadGreen2_21_points, rightHeadGreen2_22_points, rightHeadGreen2_23_points,
    rightHeadGreen2_24_points, rightHeadGreen2_25_points
];
HEAD_RIGHT_GREEN3 = [
    rightHeadGreen3_0_points, rightHeadGreen3_1_points, rightHeadGreen3_2_points, rightHeadGreen3_3_points, rightHeadGreen3_4_points, rightHeadGreen3_5_points,
    rightHeadGreen3_6_points, rightHeadGreen3_7_points, rightHeadGreen3_8_points, rightHeadGreen3_9_points, rightHeadGreen3_10_points, rightHeadGreen3_11_points,
    rightHeadGreen3_12_points, rightHeadGreen3_13_points, rightHeadGreen3_14_points, rightHeadGreen3_15_points, rightHeadGreen3_16_points, rightHeadGreen3_17_points,
    rightHeadGreen3_18_points, rightHeadGreen3_19_points, rightHeadGreen3_20_points, rightHeadGreen3_21_points, rightHeadGreen3_22_points, rightHeadGreen3_23_points,
    rightHeadGreen3_24_points, rightHeadGreen3_25_points, rightHeadGreen3_26_points, rightHeadGreen3_27_points, rightHeadGreen3_28_points
];
function getRightHeadGreyRings()   = normalizeHeadFace( HEAD_RIGHT_GREY );
function getRightHeadGreen2Rings() = normalizeHeadFace( HEAD_RIGHT_GREEN2 );
function getRightHeadGreen3Rings() = normalizeHeadFace( HEAD_RIGHT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Head - back face polygons
//
HEAD_BACK_GREY = [
    backHeadGrey_0_points, backHeadGrey_1_points, backHeadGrey_2_points, backHeadGrey_3_points, backHeadGrey_4_points, backHeadGrey_5_points,
    backHeadGrey_6_points, backHeadGrey_7_points, backHeadGrey_8_points
];
HEAD_BACK_GREEN2 = [
    backHeadGreen2_0_points, backHeadGreen2_1_points, backHeadGreen2_2_points, backHeadGreen2_3_points, backHeadGreen2_4_points, backHeadGreen2_5_points,
    backHeadGreen2_6_points, backHeadGreen2_7_points, backHeadGreen2_8_points, backHeadGreen2_9_points, backHeadGreen2_10_points, backHeadGreen2_11_points,
    backHeadGreen2_12_points, backHeadGreen2_13_points, backHeadGreen2_14_points, backHeadGreen2_15_points, backHeadGreen2_16_points, backHeadGreen2_17_points,
    backHeadGreen2_18_points, backHeadGreen2_19_points, backHeadGreen2_20_points, backHeadGreen2_21_points, backHeadGreen2_22_points, backHeadGreen2_23_points,
    backHeadGreen2_24_points, backHeadGreen2_25_points
];
HEAD_BACK_GREEN3 = [
    backHeadGreen3_0_points, backHeadGreen3_1_points, backHeadGreen3_2_points, backHeadGreen3_3_points, backHeadGreen3_4_points, backHeadGreen3_5_points,
    backHeadGreen3_6_points, backHeadGreen3_7_points, backHeadGreen3_8_points, backHeadGreen3_9_points, backHeadGreen3_10_points, backHeadGreen3_11_points,
    backHeadGreen3_12_points, backHeadGreen3_13_points, backHeadGreen3_14_points, backHeadGreen3_15_points, backHeadGreen3_16_points, backHeadGreen3_17_points,
    backHeadGreen3_18_points, backHeadGreen3_19_points, backHeadGreen3_20_points, backHeadGreen3_21_points, backHeadGreen3_22_points, backHeadGreen3_23_points,
    backHeadGreen3_24_points, backHeadGreen3_25_points, backHeadGreen3_26_points, backHeadGreen3_27_points, backHeadGreen3_28_points
];
function getBackHeadGreyRings()   = normalizeHeadFace( HEAD_BACK_GREY );
function getBackHeadGreen2Rings() = normalizeHeadFace( HEAD_BACK_GREEN2 );
function getBackHeadGreen3Rings() = normalizeHeadFace( HEAD_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Head - left face polygons
//
HEAD_LEFT_GREY = [
    leftHeadGrey_0_points, leftHeadGrey_1_points, leftHeadGrey_2_points, leftHeadGrey_3_points, leftHeadGrey_4_points, leftHeadGrey_5_points,
    leftHeadGrey_6_points, leftHeadGrey_7_points, leftHeadGrey_8_points
];
HEAD_LEFT_GREEN2 = [
    leftHeadGreen2_0_points, leftHeadGreen2_1_points, leftHeadGreen2_2_points, leftHeadGreen2_3_points, leftHeadGreen2_4_points, leftHeadGreen2_5_points,
    leftHeadGreen2_6_points, leftHeadGreen2_7_points, leftHeadGreen2_8_points, leftHeadGreen2_9_points, leftHeadGreen2_10_points, leftHeadGreen2_11_points,
    leftHeadGreen2_12_points, leftHeadGreen2_13_points, leftHeadGreen2_14_points, leftHeadGreen2_15_points, leftHeadGreen2_16_points, leftHeadGreen2_17_points,
    leftHeadGreen2_18_points, leftHeadGreen2_19_points, leftHeadGreen2_20_points, leftHeadGreen2_21_points, leftHeadGreen2_22_points, leftHeadGreen2_23_points,
    leftHeadGreen2_24_points, leftHeadGreen2_25_points
];
HEAD_LEFT_GREEN3 = [
    leftHeadGreen3_0_points, leftHeadGreen3_1_points, leftHeadGreen3_2_points, leftHeadGreen3_3_points, leftHeadGreen3_4_points, leftHeadGreen3_5_points,
    leftHeadGreen3_6_points, leftHeadGreen3_7_points, leftHeadGreen3_8_points, leftHeadGreen3_9_points, leftHeadGreen3_10_points, leftHeadGreen3_11_points,
    leftHeadGreen3_12_points, leftHeadGreen3_13_points, leftHeadGreen3_14_points, leftHeadGreen3_15_points, leftHeadGreen3_16_points, leftHeadGreen3_17_points,
    leftHeadGreen3_18_points, leftHeadGreen3_19_points, leftHeadGreen3_20_points, leftHeadGreen3_21_points, leftHeadGreen3_22_points, leftHeadGreen3_23_points,
    leftHeadGreen3_24_points, leftHeadGreen3_25_points, leftHeadGreen3_26_points, leftHeadGreen3_27_points, leftHeadGreen3_28_points
];
function getLeftHeadGreyRings()   = normalizeHeadFace( HEAD_LEFT_GREY );
function getLeftHeadGreen2Rings() = normalizeHeadFace( HEAD_LEFT_GREEN2 );
function getLeftHeadGreen3Rings() = normalizeHeadFace( HEAD_LEFT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Head - top face polygons
//
HEAD_TOP_GREY = [
    topHeadGrey_0_points, topHeadGrey_1_points, topHeadGrey_2_points, topHeadGrey_3_points, topHeadGrey_4_points
];
HEAD_TOP_GREEN2 = [
    topHeadGreen2_0_points, topHeadGreen2_1_points, topHeadGreen2_2_points, topHeadGreen2_3_points, topHeadGreen2_4_points, topHeadGreen2_5_points,
    topHeadGreen2_6_points, topHeadGreen2_7_points, topHeadGreen2_8_points, topHeadGreen2_9_points, topHeadGreen2_10_points, topHeadGreen2_11_points,
    topHeadGreen2_12_points, topHeadGreen2_13_points, topHeadGreen2_14_points, topHeadGreen2_15_points, topHeadGreen2_16_points, topHeadGreen2_17_points,
    topHeadGreen2_18_points, topHeadGreen2_19_points, topHeadGreen2_20_points, topHeadGreen2_21_points, topHeadGreen2_22_points, topHeadGreen2_23_points,
    topHeadGreen2_24_points, topHeadGreen2_25_points
];
HEAD_TOP_GREEN3 = [
    topHeadGreen3_0_points, topHeadGreen3_1_points, topHeadGreen3_2_points, topHeadGreen3_3_points, topHeadGreen3_4_points, topHeadGreen3_5_points,
    topHeadGreen3_6_points, topHeadGreen3_7_points, topHeadGreen3_8_points, topHeadGreen3_9_points, topHeadGreen3_10_points, topHeadGreen3_11_points,
    topHeadGreen3_12_points, topHeadGreen3_13_points, topHeadGreen3_14_points, topHeadGreen3_15_points, topHeadGreen3_16_points, topHeadGreen3_17_points,
    topHeadGreen3_18_points, topHeadGreen3_19_points, topHeadGreen3_20_points, topHeadGreen3_21_points, topHeadGreen3_22_points, topHeadGreen3_23_points,
    topHeadGreen3_24_points, topHeadGreen3_25_points, topHeadGreen3_26_points, topHeadGreen3_27_points, topHeadGreen3_28_points, topHeadGreen3_29_points,
    topHeadGreen3_30_points, topHeadGreen3_31_points, topHeadGreen3_32_points
];
function getTopHeadGreyRings()   = normalizeHeadFace( HEAD_TOP_GREY );
function getTopHeadGreen2Rings() = normalizeHeadFace( HEAD_TOP_GREEN2 );
function getTopHeadGreen3Rings() = normalizeHeadFace( HEAD_TOP_GREEN3 );




// Returns the raw polygon transformed so that face center is [0,0]
function normalizeBodyFace( polys, offset=102 ) = let (
    HEAD_OFFSET = [ 0, offset, 0]
) [
    for ( p=polys )
        transform(translation(HEAD_OFFSET)*scaling([1,-1,1]),p)
];

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Body - front face polygons
//
BODY_FRONT_GREY = [
    frontBodyGrey_0_points, frontBodyGrey_1_points, frontBodyGrey_2_points, frontBodyGrey_3_points, frontBodyGrey_4_points, frontBodyGrey_5_points,
    frontBodyGrey_6_points
];
BODY_FRONT_GREEN2 = [
    frontBodyGreen2_0_points, frontBodyGreen2_1_points, frontBodyGreen2_2_points, frontBodyGreen2_3_points, frontBodyGreen2_4_points, frontBodyGreen2_5_points,
    frontBodyGreen2_6_points, frontBodyGreen2_7_points, frontBodyGreen2_8_points, frontBodyGreen2_9_points, frontBodyGreen2_10_points, frontBodyGreen2_11_points,
    frontBodyGreen2_12_points, frontBodyGreen2_13_points, frontBodyGreen2_14_points, frontBodyGreen2_15_points, frontBodyGreen2_16_points, frontBodyGreen2_17_points,
    frontBodyGreen2_18_points, frontBodyGreen2_19_points, frontBodyGreen2_20_points, frontBodyGreen2_21_points, frontBodyGreen2_22_points, frontBodyGreen2_23_points,
    frontBodyGreen2_24_points, frontBodyGreen2_25_points
];
BODY_FRONT_GREEN3 = [
    frontBodyGreen3_0_points, frontBodyGreen3_1_points, frontBodyGreen3_2_points, frontBodyGreen3_3_points, frontBodyGreen3_4_points, frontBodyGreen3_5_points,
    frontBodyGreen3_6_points, frontBodyGreen3_7_points, frontBodyGreen3_8_points, frontBodyGreen3_9_points, frontBodyGreen3_10_points, frontBodyGreen3_11_points,
    frontBodyGreen3_12_points, frontBodyGreen3_13_points, frontBodyGreen3_14_points, frontBodyGreen3_15_points, frontBodyGreen3_16_points, frontBodyGreen3_17_points,
    frontBodyGreen3_18_points, frontBodyGreen3_19_points, frontBodyGreen3_20_points, frontBodyGreen3_21_points, frontBodyGreen3_22_points, frontBodyGreen3_23_points
];
function getBodyFrontGreyRings()   = normalizeBodyFace( BODY_FRONT_GREY );
function getBodyFrontGreen2Rings() = normalizeBodyFace( BODY_FRONT_GREEN2 );
function getBodyFrontGreen3Rings() = normalizeBodyFace( BODY_FRONT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Body - right face polygons
//
BODY_RIGHT_GREY = [
    rightBodyGrey_0_points, rightBodyGrey_1_points, rightBodyGrey_2_points, rightBodyGrey_3_points, rightBodyGrey_4_points
];
BODY_RIGHT_GREEN2 = [
    rightBodyGreen2_0_points, rightBodyGreen2_1_points, rightBodyGreen2_2_points, rightBodyGreen2_3_points, rightBodyGreen2_4_points, rightBodyGreen2_5_points,
    rightBodyGreen2_6_points, rightBodyGreen2_7_points, rightBodyGreen2_8_points, rightBodyGreen2_9_points, rightBodyGreen2_10_points, rightBodyGreen2_11_points
];
BODY_RIGHT_GREEN3 = [
    rightBodyGreen3_0_points, rightBodyGreen3_1_points, rightBodyGreen3_2_points, rightBodyGreen3_3_points, rightBodyGreen3_4_points, rightBodyGreen3_5_points,
    rightBodyGreen3_6_points, rightBodyGreen3_7_points, rightBodyGreen3_8_points, rightBodyGreen3_9_points, rightBodyGreen3_10_points
];
function getBodyRightGreyRings()   = normalizeBodyFace( BODY_RIGHT_GREY );
function getBodyRightGreen2Rings() = normalizeBodyFace( BODY_RIGHT_GREEN2 );
function getBodyRightGreen3Rings() = normalizeBodyFace( BODY_RIGHT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Body - back face polygons
//
BODY_BACK_GREY = [
    backBodyGrey_0_points, backBodyGrey_1_points, backBodyGrey_2_points, backBodyGrey_3_points, backBodyGrey_4_points, backBodyGrey_5_points
];
BODY_BACK_GREEN2 = [
    backBodyGreen2_0_points, backBodyGreen2_1_points, backBodyGreen2_2_points, backBodyGreen2_3_points, backBodyGreen2_4_points, backBodyGreen2_5_points,
    backBodyGreen2_6_points, backBodyGreen2_7_points, backBodyGreen2_8_points, backBodyGreen2_9_points, backBodyGreen2_10_points, backBodyGreen2_11_points,
    backBodyGreen2_12_points, backBodyGreen2_13_points, backBodyGreen2_14_points, backBodyGreen2_15_points, backBodyGreen2_16_points, backBodyGreen2_17_points,
    backBodyGreen2_18_points, backBodyGreen2_19_points, backBodyGreen2_20_points, backBodyGreen2_21_points, backBodyGreen2_22_points, backBodyGreen2_23_points,
    backBodyGreen2_24_points, backBodyGreen2_25_points
];
BODY_BACK_GREEN3 = [
    backBodyGreen3_0_points, backBodyGreen3_1_points, backBodyGreen3_2_points, backBodyGreen3_3_points, backBodyGreen3_4_points, backBodyGreen3_5_points,
    backBodyGreen3_6_points, backBodyGreen3_7_points, backBodyGreen3_8_points, backBodyGreen3_9_points, backBodyGreen3_10_points, backBodyGreen3_11_points,
    backBodyGreen3_12_points, backBodyGreen3_13_points, backBodyGreen3_14_points, backBodyGreen3_15_points, backBodyGreen3_16_points, backBodyGreen3_17_points,
    backBodyGreen3_18_points, backBodyGreen3_19_points, backBodyGreen3_20_points, backBodyGreen3_21_points, backBodyGreen3_22_points, backBodyGreen3_23_points
];
function getBodyBackGreyRings()   = normalizeBodyFace( BODY_BACK_GREY );
function getBodyBackGreen2Rings() = normalizeBodyFace( BODY_BACK_GREEN2 );
function getBodyBackGreen3Rings() = normalizeBodyFace( BODY_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Body - left face polygons
//
BODY_LEFT_GREY = [
    leftBodyGrey_0_points, leftBodyGrey_1_points, leftBodyGrey_2_points, leftBodyGrey_3_points
];
BODY_LEFT_GREEN2 = [
    leftBodyGreen2_0_points, leftBodyGreen2_1_points, leftBodyGreen2_2_points, leftBodyGreen2_3_points, leftBodyGreen2_4_points, leftBodyGreen2_5_points,
    leftBodyGreen2_6_points, leftBodyGreen2_7_points, leftBodyGreen2_8_points, leftBodyGreen2_9_points, leftBodyGreen2_10_points, leftBodyGreen2_11_points
];
BODY_LEFT_GREEN3 = [
    leftBodyGreen3_0_points, leftBodyGreen3_1_points, leftBodyGreen3_2_points, leftBodyGreen3_3_points, leftBodyGreen3_4_points, leftBodyGreen3_5_points,
    leftBodyGreen3_6_points, leftBodyGreen3_7_points, leftBodyGreen3_8_points, leftBodyGreen3_9_points, leftBodyGreen3_10_points, leftBodyGreen3_11_points
];
function getBodyLeftGreyRings()   = normalizeBodyFace( BODY_LEFT_GREY );
function getBodyLeftGreen2Rings() = normalizeBodyFace( BODY_LEFT_GREEN2 );
function getBodyLeftGreen3Rings() = normalizeBodyFace( BODY_LEFT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Body - top face polygons
//
BODY_TOP_GREY = [
    topBodyGrey_0_points, topBodyGrey_1_points, topBodyGrey_2_points, topBodyGrey_3_points
];
BODY_TOP_GREEN2 = [
    topBodyGreen2_0_points, topBodyGreen2_1_points, topBodyGreen2_2_points, topBodyGreen2_3_points, topBodyGreen2_4_points, topBodyGreen2_5_points,
    topBodyGreen2_6_points, topBodyGreen2_7_points, topBodyGreen2_8_points, topBodyGreen2_9_points, topBodyGreen2_10_points, topBodyGreen2_11_points,
    topBodyGreen2_12_points, topBodyGreen2_13_points, topBodyGreen2_14_points
];
BODY_TOP_GREEN3 = [
    topBodyGreen3_0_points, topBodyGreen3_1_points, topBodyGreen3_2_points, topBodyGreen3_3_points, topBodyGreen3_4_points, topBodyGreen3_5_points,
    topBodyGreen3_6_points, topBodyGreen3_7_points, topBodyGreen3_8_points, topBodyGreen3_9_points, topBodyGreen3_10_points, topBodyGreen3_11_points,
    topBodyGreen3_12_points
];
function getBodyTopGreyRings()   = normalizeBodyFace( BODY_TOP_GREY, 78 );
function getBodyTopGreen2Rings() = normalizeBodyFace( BODY_TOP_GREEN2, 78 );
function getBodyTopGreen3Rings() = normalizeBodyFace( BODY_TOP_GREEN3, 78 );





// Returns the raw polygon transformed so that face center is [0,0]
function normalizeFootFace( polys, offset=118 ) = let (
    HEAD_OFFSET = [ 0, offset, 0]
) [
    for ( p=polys )
        transform(translation(HEAD_OFFSET)*scaling([1,-1,1]),p)
];

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Right - front face polygons
//
FOOT_FR_FRONT_BLACK = [
    frontFootRightBlack_0_points,
    frontFootRightBlack_1_points,
    frontFootRightBlack_2_points,
    frontFootRightBlack_3_points
];
FOOT_FR_FRONT_GREEN1 = [
    frontFootRightGreen1_0_points,
    frontFootRightGreen1_1_points,
    frontFootRightGreen1_2_points,
    frontFootRightGreen1_3_points
];
FOOT_FR_FRONT_GREEN2 = [
    frontFootRightGreen2_0_points,
    frontFootRightGreen2_1_points
];
FOOT_FR_FRONT_GREEN3 = [
    frontFootRightGreen3_0_points,
    frontFootRightGreen3_1_points
];
function getFootFRFrontBlackRings()  = normalizeFootFace( FOOT_FR_FRONT_BLACK );
function getFootFRFrontGreen1Rings() = normalizeFootFace( FOOT_FR_FRONT_GREEN1 );
function getFootFRFrontGreen2Rings() = normalizeFootFace( FOOT_FR_FRONT_GREEN2 );
function getFootFRFrontGreen3Rings() = normalizeFootFace( FOOT_FR_FRONT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Right - right face polygons
//
FOOT_FRL_RIGHT_GREEN1 = [
    rightFootFrontGreen1_0_points,
];
FOOT_FRL_RIGHT_GREEN2 = [
    rightFootFrontGreen2_0_points,
    rightFootFrontGreen2_1_points,
    rightFootFrontGreen2_2_points,
    rightFootFrontGreen2_3_points
];
FOOT_FRL_RIGHT_GREEN3 = [
    rightFootFrontGreen3_0_points,
    rightFootFrontGreen3_1_points,
    rightFootFrontGreen3_2_points,
    rightFootFrontGreen3_3_points
];
function getFootFRRightGreen1Rings() = normalizeFootFace( FOOT_FRL_RIGHT_GREEN1 );
function getFootFRRightGreen2Rings() = normalizeFootFace( FOOT_FRL_RIGHT_GREEN2 );
function getFootFRRightGreen3Rings() = normalizeFootFace( FOOT_FRL_RIGHT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Right - back face polygons
//
FOOT_FBRL_BACK_GREEN2 = [
    frontFootBackGreen2_0_points,
    frontFootBackGreen2_1_points,
    frontFootBackGreen2_2_points,
    frontFootBackGreen2_3_points,
    frontFootBackGreen2_4_points,
    frontFootBackGreen2_5_points
];
FOOT_FBRL_BACK_GREEN3 = [
    frontFootBackGreen3_0_points,
    frontFootBackGreen3_1_points,
    frontFootBackGreen3_2_points,
    frontFootBackGreen3_3_points,
    frontFootBackGreen3_4_points,
    frontFootBackGreen3_5_points
];
function getFootFRBackGreen2Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN2 );
function getFootFRBackGreen3Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Right - left face polygons
//
FOOT_FRL_LEFT_GREEN1 = [
    leftFootFrontGreen1_0_points,
];
FOOT_FRL_LEFT_GREEN2 = [
    leftFootFrontGreen2_0_points,
    leftFootFrontGreen2_1_points,
    leftFootFrontGreen2_2_points,
    leftFootFrontGreen2_3_points,
    leftFootFrontGreen2_4_points
];
FOOT_FRL_LEFT_GREEN3 = [
    leftFootFrontGreen3_0_points,
    leftFootFrontGreen3_1_points,
    leftFootFrontGreen3_2_points
];
function getFootFRLeftGreen1Rings() = normalizeFootFace( FOOT_FRL_LEFT_GREEN1 );
function getFootFRLeftGreen2Rings() = normalizeFootFace( FOOT_FRL_LEFT_GREEN2 );
function getFootFRLeftGreen3Rings() = normalizeFootFace( FOOT_FRL_LEFT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Right - top face polygons
//
FOOT_FR_TOP_GREEN2 = [
    topFootFrontRightGreen2_0_points,
    topFootFrontRightGreen2_1_points,
    topFootFrontRightGreen2_2_points,
    topFootFrontRightGreen2_3_points,
    topFootFrontRightGreen2_4_points,
    topFootFrontRightGreen2_5_points
];
FOOT_FR_TOP_GREEN3 = [
    topFootFrontRightGreen3_0_points,
    topFootFrontRightGreen3_1_points,
    topFootFrontRightGreen3_2_points,
    topFootFrontRightGreen3_3_points,
    topFootFrontRightGreen3_4_points,
    topFootFrontRightGreen3_5_points
];
function getFootFRTopGreen2Rings() = normalizeFootFace( FOOT_FR_TOP_GREEN2, 106 );
function getFootFRTopGreen3Rings() = normalizeFootFace( FOOT_FR_TOP_GREEN3, 106 );





// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Left - front face polygons
//
FOOT_FL_FRONT_BLACK = [
    frontFootLeftBlack_0_points,
    frontFootLeftBlack_1_points,
    frontFootLeftBlack_2_points,
    frontFootLeftBlack_3_points
];
FOOT_FL_FRONT_GREEN1 = [
    frontFootLeftGreen1_0_points,
    frontFootLeftGreen1_1_points,
    frontFootLeftGreen1_2_points,
    frontFootLeftGreen1_3_points
];
FOOT_FL_FRONT_GREEN2 = [
    frontFootLeftGreen2_0_points,
    frontFootLeftGreen2_1_points
];
FOOT_FL_FRONT_GREEN3 = [
    frontFootLeftGreen3_0_points,
    frontFootLeftGreen3_1_points
];
function getFootFLFrontBlackRings()  = normalizeFootFace( FOOT_FL_FRONT_BLACK );
function getFootFLFrontGreen1Rings() = normalizeFootFace( FOOT_FL_FRONT_GREEN1 );
function getFootFLFrontGreen2Rings() = normalizeFootFace( FOOT_FL_FRONT_GREEN2 );
function getFootFLFrontGreen3Rings() = normalizeFootFace( FOOT_FL_FRONT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Left - right face polygons
//
function getFootFLRightGreen1Rings() = normalizeFootFace( FOOT_FRL_RIGHT_GREEN1 );
function getFootFLRightGreen2Rings() = normalizeFootFace( FOOT_FRL_RIGHT_GREEN2 );
function getFootFLRightGreen3Rings() = normalizeFootFace( FOOT_FRL_RIGHT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Left - back face polygons
//
function getFootFLBackGreen2Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN2 );
function getFootFLBackGreen3Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Left - left face polygons
//
function getFootFLLeftGreen1Rings() = normalizeFootFace( FOOT_FRL_LEFT_GREEN1 );
function getFootFLLeftGreen2Rings() = normalizeFootFace( FOOT_FRL_LEFT_GREEN2 );
function getFootFLLeftGreen3Rings() = normalizeFootFace( FOOT_FRL_LEFT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Front Left - top face polygons
//
FOOT_FL_TOP_GREEN2 = [
    topFootFrontLeftGreen2_0_points,
    topFootFrontLeftGreen2_1_points,
    topFootFrontLeftGreen2_2_points,
    topFootFrontLeftGreen2_3_points,
    topFootFrontLeftGreen2_4_points,
    topFootFrontLeftGreen2_5_points
];
FOOT_FL_TOP_GREEN3 = [
    topFootFrontLeftGreen3_0_points,
    topFootFrontLeftGreen3_1_points,
    topFootFrontLeftGreen3_2_points,
    topFootFrontLeftGreen3_3_points,
    topFootFrontLeftGreen3_4_points,
    topFootFrontLeftGreen3_5_points
];
function getFootFLTopGreen2Rings() = normalizeFootFace( FOOT_FL_TOP_GREEN2, 106 );
function getFootFLTopGreen3Rings() = normalizeFootFace( FOOT_FL_TOP_GREEN3, 106 );





// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Right - front face polygons
//
FOOT_BR_BACK_BLACK = [
    backFootRightBlack_0_points,
    backFootRightBlack_1_points,
    backFootRightBlack_2_points,
    backFootRightBlack_3_points
];
FOOT_BR_BACK_GREEN1 = [
    backFootRightGreen1_0_points,
    backFootRightGreen1_1_points,
    backFootRightGreen1_2_points,
    backFootRightGreen1_3_points
];
FOOT_BR_BACK_GREEN2 = [
    backFootRightGreen2_0_points
];
FOOT_BR_BACK_GREEN3 = [
    backFootRightGreen3_0_points,
    backFootRightGreen3_1_points,
    backFootRightGreen3_2_points
];
function getFootBRFrontBlackRings()  = normalizeFootFace( FOOT_BR_BACK_BLACK );
function getFootBRFrontGreen1Rings() = normalizeFootFace( FOOT_BR_BACK_GREEN1 );
function getFootBRFrontGreen2Rings() = normalizeFootFace( FOOT_BR_BACK_GREEN2 );
function getFootBRFrontGreen3Rings() = normalizeFootFace( FOOT_BR_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Right - right face polygons
//
FOOT_BRL_RIGHT_GREEN1 = [
    rightFootBackGreen1_0_points,
];
FOOT_BRL_RIGHT_GREEN2 = [
    rightFootBackGreen2_0_points,
    rightFootBackGreen2_1_points,
    rightFootBackGreen2_2_points,
    rightFootBackGreen2_3_points,
    rightFootBackGreen2_4_points
];
FOOT_BRL_RIGHT_GREEN3 = [
    rightFootBackGreen3_0_points,
    rightFootBackGreen3_1_points,
    rightFootBackGreen3_2_points
];
function getFootBRRightGreen1Rings() = normalizeFootFace( FOOT_BRL_RIGHT_GREEN1 );
function getFootBRRightGreen2Rings() = normalizeFootFace( FOOT_BRL_RIGHT_GREEN2 );
function getFootBRRightGreen3Rings() = normalizeFootFace( FOOT_BRL_RIGHT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Right - back face polygons
//
function getFootBRBackGreen2Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN2 );
function getFootBRBackGreen3Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Right - left face polygons
//
FOOT_BRL_LEFT_GREEN1 = [
    leftFootBackGreen1_0_points,
];
FOOT_BRL_LEFT_GREEN2 = [
    leftFootBackGreen2_0_points,
    leftFootBackGreen2_1_points,
    leftFootBackGreen2_2_points,
    leftFootBackGreen2_3_points
];
FOOT_BRL_LEFT_GREEN3 = [
    leftFootBackGreen3_0_points,
    leftFootBackGreen3_1_points,
    leftFootBackGreen3_2_points,
    leftFootBackGreen3_3_points
];
function getFootBRLeftGreen1Rings() = normalizeFootFace( FOOT_BRL_LEFT_GREEN1 );
function getFootBRLeftGreen2Rings() = normalizeFootFace( FOOT_BRL_LEFT_GREEN2 );
function getFootBRLeftGreen3Rings() = normalizeFootFace( FOOT_BRL_LEFT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Right - top face polygons
//
FOOT_BR_TOP_GREEN2 = [
    topFootBackRightGreen2_0_points,
    topFootBackRightGreen2_1_points,
    topFootBackRightGreen2_2_points,
    topFootBackRightGreen2_3_points,
    topFootBackRightGreen2_4_points
];
FOOT_BR_TOP_GREEN3 = [
    topFootBackRightGreen3_0_points,
    topFootBackRightGreen3_1_points,
    topFootBackRightGreen3_2_points,
    topFootBackRightGreen3_3_points,
    topFootBackRightGreen3_4_points,
    topFootBackRightGreen3_5_points,
    topFootBackRightGreen3_6_points
];
function getFootBRTopGreen2Rings() = normalizeFootFace( FOOT_BR_TOP_GREEN2, 106 );
function getFootBRTopGreen3Rings() = normalizeFootFace( FOOT_BR_TOP_GREEN3, 106 );





// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Left - front face polygons
//
FOOT_BL_FRONT_BLACK = [
    backFootLeftBlack_0_points,
    backFootLeftBlack_1_points,
    backFootLeftBlack_2_points,
    backFootLeftBlack_3_points
];
FOOT_BL_FRONT_GREEN1 = [
    backFootLeftGreen1_0_points,
    backFootLeftGreen1_1_points,
    backFootLeftGreen1_2_points,
    backFootLeftGreen1_3_points
];
FOOT_BL_FRONT_GREEN2 = [
    backFootLeftGreen2_0_points,
    backFootLeftGreen2_1_points
];
FOOT_BL_FRONT_GREEN3 = [
    backFootLeftGreen3_0_points,
    backFootLeftGreen3_1_points
];
function getFootBLFrontBlackRings()  = normalizeFootFace( FOOT_BL_FRONT_BLACK );
function getFootBLFrontGreen1Rings() = normalizeFootFace( FOOT_BL_FRONT_GREEN1 );
function getFootBLFrontGreen2Rings() = normalizeFootFace( FOOT_BL_FRONT_GREEN2 );
function getFootBLFrontGreen3Rings() = normalizeFootFace( FOOT_BL_FRONT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Left - right face polygons
//
function getFootBLRightGreen1Rings() = normalizeFootFace( FOOT_BRL_RIGHT_GREEN1 );
function getFootBLRightGreen2Rings() = normalizeFootFace( FOOT_BRL_RIGHT_GREEN2 );
function getFootBLRightGreen3Rings() = normalizeFootFace( FOOT_BRL_RIGHT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Left - back face polygons
//
function getFootBLBackGreen2Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN2 );
function getFootBLBackGreen3Rings() = normalizeFootFace( FOOT_FBRL_BACK_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Left - left face polygons
//
function getFootBLLeftGreen1Rings() = normalizeFootFace( FOOT_BRL_LEFT_GREEN1 );
function getFootBLLeftGreen2Rings() = normalizeFootFace( FOOT_BRL_LEFT_GREEN2 );
function getFootBLLeftGreen3Rings() = normalizeFootFace( FOOT_BRL_LEFT_GREEN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Foot Back Left - top face polygons
//
FOOT_BL_TOP_GREEN2 = [
    topFootBackLeftGreen2_0_points,
    topFootBackLeftGreen2_1_points,
    topFootBackLeftGreen2_2_points,
    topFootBackLeftGreen2_3_points,
    topFootBackLeftGreen2_4_points,
    topFootBackLeftGreen2_5_points
];
FOOT_BL_TOP_GREEN3 = [
    topFootBackLeftGreen3_0_points,
    topFootBackLeftGreen3_1_points,
    topFootBackLeftGreen3_2_points,
    topFootBackLeftGreen3_3_points,
    topFootBackLeftGreen3_4_points,
    topFootBackLeftGreen3_5_points
];
function getFootBLTopGreen2Rings() = normalizeFootFace( FOOT_BL_TOP_GREEN2, 106 );
function getFootBLTopGreen3Rings() = normalizeFootFace( FOOT_BL_TOP_GREEN3, 106 );





// Returns the raw polygon transformed so that face center is [0,0]
function normalizeGroundFace( polys, offset=150 ) = let (
    HEAD_OFFSET = [ 0, offset, 0]
) [
    for ( p=polys )
        transform(translation(HEAD_OFFSET)*scaling([1,-1,1]),p)
];

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Ground - front face polygons
//
GROUND_FRONT_GREY = [
    frontGroundGrey_0_points, frontGroundGrey_1_points, frontGroundGrey_2_points, frontGroundGrey_3_points, frontGroundGrey_4_points, frontGroundGrey_5_points,
    frontGroundGrey_6_points, frontGroundGrey_7_points
];
GROUND_FRONT_GREEN3 = [
    frontGroundGreen3_0_points, frontGroundGreen3_1_points, frontGroundGreen3_2_points, frontGroundGreen3_3_points, frontGroundGreen3_4_points,
    frontGroundGreen3_5_points, frontGroundGreen3_6_points, frontGroundGreen3_7_points, frontGroundGreen3_8_points, frontGroundGreen3_9_points,
    frontGroundGreen3_10_points, frontGroundGreen3_11_points, frontGroundGreen3_12_points, frontGroundGreen3_13_points, frontGroundGreen3_14_points,
    frontGroundGreen3_15_points, frontGroundGreen3_16_points
];
GROUND_FRONT_BROWN1 = [
    frontGroundBrown1_0_points, frontGroundBrown1_1_points, frontGroundBrown1_2_points,  frontGroundBrown1_3_points, frontGroundBrown1_4_points, frontGroundBrown1_5_points,
    frontGroundBrown1_6_points, frontGroundBrown1_7_points, frontGroundBrown1_8_points, frontGroundBrown1_9_points, frontGroundBrown1_10_points, frontGroundBrown1_11_points,
    frontGroundBrown1_12_points, frontGroundBrown1_13_points, frontGroundBrown1_14_points, frontGroundBrown1_15_points
];
GROUND_FRONT_BROWN2 = [
    frontGroundBrown2_0_points, frontGroundBrown2_1_points, frontGroundBrown2_2_points, frontGroundBrown2_3_points, frontGroundBrown2_4_points, frontGroundBrown2_5_points,
    frontGroundBrown2_6_points, frontGroundBrown2_7_points, frontGroundBrown2_8_points, frontGroundBrown2_9_points, frontGroundBrown2_10_points, frontGroundBrown2_11_points,
    frontGroundBrown2_12_points, frontGroundBrown2_13_points, frontGroundBrown2_14_points, frontGroundBrown2_15_points, frontGroundBrown2_16_points
];
GROUND_FRONT_BROWN3 = [
    frontGroundBrown3_0_points, frontGroundBrown3_1_points, frontGroundBrown3_2_points, frontGroundBrown3_3_points, frontGroundBrown3_4_points, frontGroundBrown3_5_points,
    frontGroundBrown3_6_points, frontGroundBrown3_7_points, frontGroundBrown3_8_points, frontGroundBrown3_9_points
];
function getGroundFrontGreyRings()   = normalizeGroundFace( GROUND_FRONT_GREY );
function getGroundFrontGreen3Rings() = normalizeGroundFace( GROUND_FRONT_GREEN3 );
function getGroundFrontBrown1Rings() = normalizeGroundFace( GROUND_FRONT_BROWN1 );
function getGroundFrontBrown2Rings() = normalizeGroundFace( GROUND_FRONT_BROWN2 );
function getGroundFrontBrown3Rings() = normalizeGroundFace( GROUND_FRONT_BROWN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Ground - right face polygons
//
GROUND_RIGHT_GREY = [
    rightGroundGrey_0_points, rightGroundGrey_1_points, rightGroundGrey_2_points, rightGroundGrey_3_points, rightGroundGrey_4_points, rightGroundGrey_5_points,
    rightGroundGrey_6_points, rightGroundGrey_7_points
];
GROUND_RIGHT_GREEN3 = [
    rightGroundGreen3_0_points, rightGroundGreen3_1_points, rightGroundGreen3_2_points, rightGroundGreen3_3_points, rightGroundGreen3_4_points, rightGroundGreen3_5_points,
    rightGroundGreen3_6_points, rightGroundGreen3_7_points, rightGroundGreen3_8_points, rightGroundGreen3_9_points, rightGroundGreen3_10_points, rightGroundGreen3_11_points,
    rightGroundGreen3_12_points, rightGroundGreen3_13_points, rightGroundGreen3_14_points
];
GROUND_RIGHT_BROWN1 = [
    rightGroundBrown1_0_points, rightGroundBrown1_1_points, rightGroundBrown1_2_points, rightGroundBrown1_3_points, rightGroundBrown1_4_points, rightGroundBrown1_5_points,
    rightGroundBrown1_6_points, rightGroundBrown1_7_points, rightGroundBrown1_8_points, rightGroundBrown1_9_points, rightGroundBrown1_10_points, rightGroundBrown1_11_points,
    rightGroundBrown1_12_points, rightGroundBrown1_13_points, rightGroundBrown1_14_points, rightGroundBrown1_15_points, rightGroundBrown1_16_points, rightGroundBrown1_17_points
];
GROUND_RIGHT_BROWN2 = [
    rightGroundBrown2_0_points, rightGroundBrown2_1_points, rightGroundBrown2_2_points, rightGroundBrown2_3_points, rightGroundBrown2_4_points, rightGroundBrown2_5_points,
    rightGroundBrown2_6_points, rightGroundBrown2_7_points,rightGroundBrown2_8_points, rightGroundBrown2_9_points, rightGroundBrown2_10_points, rightGroundBrown2_11_points,
    rightGroundBrown2_12_points, rightGroundBrown2_13_points, rightGroundBrown2_14_points, rightGroundBrown2_15_points, rightGroundBrown2_16_points
];
GROUND_RIGHT_BROWN3 = [
    rightGroundBrown3_0_points, rightGroundBrown3_1_points, rightGroundBrown3_2_points, rightGroundBrown3_3_points, rightGroundBrown3_4_points, rightGroundBrown3_5_points,
    rightGroundBrown3_6_points, rightGroundBrown3_7_points, rightGroundBrown3_8_points, rightGroundBrown3_9_points
];
function getGroundRightGreyRings()   = normalizeGroundFace( GROUND_RIGHT_GREY );
function getGroundRightGreen3Rings() = normalizeGroundFace( GROUND_RIGHT_GREEN3 );
function getGroundRightBrown1Rings() = normalizeGroundFace( GROUND_RIGHT_BROWN1 );
function getGroundRightBrown2Rings() = normalizeGroundFace( GROUND_RIGHT_BROWN2 );
function getGroundRightBrown3Rings() = normalizeGroundFace( GROUND_RIGHT_BROWN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Ground - back face polygons
//
GROUND_BACK_GREY = [
    backGroundGrey_0_points, backGroundGrey_1_points, backGroundGrey_2_points, backGroundGrey_3_points, backGroundGrey_4_points, backGroundGrey_5_points,
    backGroundGrey_6_points
];
GROUND_BACK_GREEN3 = [
    backGroundGreen3_0_points, backGroundGreen3_1_points, backGroundGreen3_2_points, backGroundGreen3_3_points, backGroundGreen3_4_points, backGroundGreen3_5_points,
    backGroundGreen3_6_points,  backGroundGreen3_7_points, backGroundGreen3_8_points, backGroundGreen3_9_points, backGroundGreen3_10_points, backGroundGreen3_11_points,
    backGroundGreen3_12_points, backGroundGreen3_13_points, backGroundGreen3_14_points, backGroundGreen3_15_points, backGroundGreen3_16_points
];
GROUND_BACK_BROWN1 = [
    backGroundBrown1_0_points, backGroundBrown1_1_points, backGroundBrown1_2_points, backGroundBrown1_3_points, backGroundBrown1_4_points, backGroundBrown1_5_points,
    backGroundBrown1_6_points, backGroundBrown1_7_points, backGroundBrown1_8_points, backGroundBrown1_9_points, backGroundBrown1_10_points, backGroundBrown1_11_points,
    backGroundBrown1_12_points, backGroundBrown1_13_points, backGroundBrown1_14_points, backGroundBrown1_15_points
];
GROUND_BACK_BROWN2 = [
    backGroundBrown2_0_points, backGroundBrown2_1_points, backGroundBrown2_2_points, backGroundBrown2_3_points, backGroundBrown2_4_points, backGroundBrown2_5_points,
    backGroundBrown2_6_points, backGroundBrown2_7_points, backGroundBrown2_8_points, backGroundBrown2_9_points, backGroundBrown2_10_points, backGroundBrown2_11_points,
    backGroundBrown2_12_points, backGroundBrown2_13_points, backGroundBrown2_14_points, backGroundBrown2_15_points, backGroundBrown2_16_points, backGroundBrown2_17_points
];
GROUND_BACK_BROWN3 = [
    backGroundBrown3_0_points, backGroundBrown3_1_points, backGroundBrown3_2_points, backGroundBrown3_3_points, backGroundBrown3_4_points, backGroundBrown3_5_points,
    backGroundBrown3_6_points, backGroundBrown3_7_points, backGroundBrown3_8_points, backGroundBrown3_9_points
];
function getGroundBackGreyRings()   = normalizeGroundFace( GROUND_BACK_GREY );
function getGroundBackGreen3Rings() = normalizeGroundFace( GROUND_BACK_GREEN3 );
function getGroundBackBrown1Rings() = normalizeGroundFace( GROUND_BACK_BROWN1 );
function getGroundBackBrown2Rings() = normalizeGroundFace( GROUND_BACK_BROWN2 );
function getGroundBackBrown3Rings() = normalizeGroundFace( GROUND_BACK_BROWN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Ground - left face polygons
//
GROUND_LEFT_GREY = [
    leftGroundGrey_0_points, leftGroundGrey_1_points, leftGroundGrey_2_points, leftGroundGrey_3_points, leftGroundGrey_4_points
];
GROUND_LEFT_GREEN3 = [
    leftGroundGreen3_0_points, leftGroundGreen3_1_points, leftGroundGreen3_2_points, leftGroundGreen3_3_points, leftGroundGreen3_4_points, leftGroundGreen3_5_points,
    leftGroundGreen3_6_points, leftGroundGreen3_7_points, leftGroundGreen3_8_points, leftGroundGreen3_9_points, leftGroundGreen3_10_points, leftGroundGreen3_11_points,
    leftGroundGreen3_12_points, leftGroundGreen3_13_points, leftGroundGreen3_14_points
];
GROUND_LEFT_BROWN1 = [
    leftGroundBrown1_0_points, leftGroundBrown1_1_points, leftGroundBrown1_2_points, leftGroundBrown1_3_points, leftGroundBrown1_4_points, leftGroundBrown1_5_points,
    leftGroundBrown1_6_points, leftGroundBrown1_7_points, leftGroundBrown1_8_points, leftGroundBrown1_9_points, leftGroundBrown1_10_points, leftGroundBrown1_11_points,
    leftGroundBrown1_12_points, leftGroundBrown1_13_points, leftGroundBrown1_14_points, leftGroundBrown1_15_points, leftGroundBrown1_16_points,leftGroundBrown1_17_points
];
GROUND_LEFT_BROWN2 = [
    leftGroundBrown2_0_points, leftGroundBrown2_1_points, leftGroundBrown2_2_points, leftGroundBrown2_3_points, leftGroundBrown2_4_points, leftGroundBrown2_5_points,
    leftGroundBrown2_6_points, leftGroundBrown2_7_points, leftGroundBrown2_8_points, leftGroundBrown2_9_points, leftGroundBrown2_10_points, leftGroundBrown2_11_points,
    leftGroundBrown2_12_points, leftGroundBrown2_13_points, leftGroundBrown2_14_points, leftGroundBrown2_15_points, leftGroundBrown2_16_points, leftGroundBrown2_17_points,
    leftGroundBrown2_18_points, leftGroundBrown2_19_points
];
GROUND_LEFT_BROWN3 = [
    leftGroundBrown3_0_points, leftGroundBrown3_1_points, leftGroundBrown3_2_points, leftGroundBrown3_3_points, leftGroundBrown3_4_points, leftGroundBrown3_5_points,
    leftGroundBrown3_6_points, leftGroundBrown3_7_points, leftGroundBrown3_8_points, leftGroundBrown3_9_points
];
function getGroundLeftGreyRings()   = normalizeGroundFace( GROUND_LEFT_GREY );
function getGroundLeftGreen3Rings() = normalizeGroundFace( GROUND_LEFT_GREEN3 );
function getGroundLeftBrown1Rings() = normalizeGroundFace( GROUND_LEFT_BROWN1 );
function getGroundLeftBrown2Rings() = normalizeGroundFace( GROUND_LEFT_BROWN2 );
function getGroundLeftBrown3Rings() = normalizeGroundFace( GROUND_LEFT_BROWN3 );

// ------------------------------------------------------------------------------------------------------------------------------------------------------
//
//   Ground - top face polygons
//
GROUND_TOP_BROWN3 = [
topGroundGreen2_0_points, topGroundGreen2_1_points, topGroundGreen2_2_points, topGroundGreen2_3_points, topGroundGreen2_4_points, topGroundGreen2_5_points,
topGroundGreen2_6_points, topGroundGreen2_7_points, topGroundGreen2_8_points, topGroundGreen2_9_points, topGroundGreen2_10_points, topGroundGreen2_11_points,
topGroundGreen2_12_points, topGroundGreen2_13_points, topGroundGreen2_14_points, topGroundGreen2_15_points, topGroundGreen2_16_points, topGroundGreen2_17_points,
topGroundGreen2_18_points
];
GROUND_TOP_GREEN3 = [
topGroundGreen3_0_points, topGroundGreen3_1_points, topGroundGreen3_2_points, topGroundGreen3_3_points, topGroundGreen3_4_points, topGroundGreen3_5_points, topGroundGreen3_6_points, topGroundGreen3_7_points, topGroundGreen3_8_points, topGroundGreen3_9_points,
topGroundGreen3_10_points, topGroundGreen3_11_points, topGroundGreen3_12_points, topGroundGreen3_13_points, topGroundGreen3_14_points, topGroundGreen3_15_points, topGroundGreen3_16_points, topGroundGreen3_17_points, topGroundGreen3_18_points, topGroundGreen3_19_points,
topGroundGreen3_20_points, topGroundGreen3_21_points, topGroundGreen3_22_points, topGroundGreen3_23_points, topGroundGreen3_24_points, topGroundGreen3_25_points, topGroundGreen3_26_points, topGroundGreen3_27_points, topGroundGreen3_28_points, topGroundGreen3_29_points,
topGroundGreen3_30_points, topGroundGreen3_31_points, topGroundGreen3_32_points, topGroundGreen3_33_points, topGroundGreen3_34_points, topGroundGreen3_35_points, topGroundGreen3_36_points, topGroundGreen3_37_points, topGroundGreen3_38_points, topGroundGreen3_39_points,
topGroundGreen3_40_points, topGroundGreen3_41_points, topGroundGreen3_42_points, topGroundGreen3_43_points, topGroundGreen3_44_points, topGroundGreen3_45_points, topGroundGreen3_46_points, topGroundGreen3_47_points, topGroundGreen3_48_points, topGroundGreen3_49_points,
topGroundGreen3_50_points, topGroundGreen3_51_points, topGroundGreen3_52_points, topGroundGreen3_53_points, topGroundGreen3_54_points, topGroundGreen3_55_points, topGroundGreen3_56_points, topGroundGreen3_57_points, topGroundGreen3_58_points, topGroundGreen3_59_points,
topGroundGreen3_60_points, topGroundGreen3_61_points, topGroundGreen3_62_points, topGroundGreen3_63_points, topGroundGreen3_64_points, topGroundGreen3_65_points, topGroundGreen3_66_points, topGroundGreen3_67_points, topGroundGreen3_68_points, topGroundGreen3_69_points,
topGroundGreen3_70_points, topGroundGreen3_71_points, topGroundGreen3_72_points, topGroundGreen3_73_points, topGroundGreen3_74_points, topGroundGreen3_75_points, topGroundGreen3_76_points, topGroundGreen3_77_points, topGroundGreen3_78_points, topGroundGreen3_79_points,
topGroundGreen3_80_points, topGroundGreen3_81_points, topGroundGreen3_82_points, topGroundGreen3_83_points, topGroundGreen3_84_points, topGroundGreen3_85_points, topGroundGreen3_86_points, topGroundGreen3_87_points, topGroundGreen3_88_points, topGroundGreen3_89_points,
topGroundGreen3_90_points, topGroundGreen3_91_points, topGroundGreen3_92_points, topGroundGreen3_93_points, topGroundGreen3_94_points, topGroundGreen3_95_points, topGroundGreen3_96_points, topGroundGreen3_97_points, topGroundGreen3_98_points, topGroundGreen3_99_points,

topGroundGreen3_100_points, topGroundGreen3_101_points, topGroundGreen3_102_points, topGroundGreen3_103_points, topGroundGreen3_104_points, topGroundGreen3_105_points, topGroundGreen3_106_points, topGroundGreen3_107_points, topGroundGreen3_108_points, topGroundGreen3_109_points,
topGroundGreen3_110_points, topGroundGreen3_111_points, topGroundGreen3_112_points, topGroundGreen3_113_points, topGroundGreen3_114_points, topGroundGreen3_115_points, topGroundGreen3_116_points, topGroundGreen3_117_points, topGroundGreen3_118_points, topGroundGreen3_119_points,
topGroundGreen3_120_points, topGroundGreen3_121_points, topGroundGreen3_122_points, topGroundGreen3_123_points, topGroundGreen3_124_points, topGroundGreen3_125_points, topGroundGreen3_126_points, topGroundGreen3_127_points, topGroundGreen3_128_points, topGroundGreen3_129_points,
topGroundGreen3_130_points, topGroundGreen3_131_points, topGroundGreen3_132_points, topGroundGreen3_133_points, topGroundGreen3_134_points, topGroundGreen3_135_points, topGroundGreen3_136_points, topGroundGreen3_137_points, topGroundGreen3_138_points, topGroundGreen3_139_points,
topGroundGreen3_140_points, topGroundGreen3_141_points, topGroundGreen3_142_points, topGroundGreen3_143_points, topGroundGreen3_144_points, topGroundGreen3_145_points, topGroundGreen3_146_points, topGroundGreen3_147_points, topGroundGreen3_148_points, topGroundGreen3_149_points,
topGroundGreen3_150_points, topGroundGreen3_151_points, topGroundGreen3_152_points, topGroundGreen3_153_points, topGroundGreen3_154_points, topGroundGreen3_155_points, topGroundGreen3_156_points, topGroundGreen3_157_points, topGroundGreen3_158_points, topGroundGreen3_159_points,
topGroundGreen3_160_points, topGroundGreen3_161_points, topGroundGreen3_162_points, topGroundGreen3_163_points, topGroundGreen3_164_points, topGroundGreen3_165_points, topGroundGreen3_166_points, topGroundGreen3_167_points, topGroundGreen3_168_points, topGroundGreen3_169_points,
topGroundGreen3_170_points, topGroundGreen3_171_points, topGroundGreen3_172_points, topGroundGreen3_173_points, topGroundGreen3_174_points, topGroundGreen3_175_points, topGroundGreen3_176_points, topGroundGreen3_177_points, topGroundGreen3_178_points, topGroundGreen3_179_points,
topGroundGreen3_180_points, topGroundGreen3_181_points, topGroundGreen3_182_points, topGroundGreen3_183_points, topGroundGreen3_184_points, topGroundGreen3_185_points, topGroundGreen3_186_points, topGroundGreen3_187_points, topGroundGreen3_188_points, topGroundGreen3_189_points,
topGroundGreen3_190_points, topGroundGreen3_191_points, topGroundGreen3_192_points, topGroundGreen3_193_points, topGroundGreen3_194_points, topGroundGreen3_195_points, topGroundGreen3_196_points, topGroundGreen3_197_points, topGroundGreen3_198_points, topGroundGreen3_199_points,

topGroundGreen3_200_points, topGroundGreen3_201_points, topGroundGreen3_202_points, topGroundGreen3_203_points, topGroundGreen3_204_points, topGroundGreen3_205_points, topGroundGreen3_206_points, topGroundGreen3_207_points, topGroundGreen3_208_points, topGroundGreen3_209_points,
topGroundGreen3_210_points, topGroundGreen3_211_points, topGroundGreen3_212_points, topGroundGreen3_213_points, topGroundGreen3_214_points, topGroundGreen3_215_points, topGroundGreen3_216_points, topGroundGreen3_217_points, topGroundGreen3_218_points, topGroundGreen3_219_points,
topGroundGreen3_220_points, topGroundGreen3_221_points, topGroundGreen3_222_points, topGroundGreen3_223_points, topGroundGreen3_224_points, topGroundGreen3_225_points, topGroundGreen3_226_points, topGroundGreen3_227_points, topGroundGreen3_228_points, topGroundGreen3_229_points,
topGroundGreen3_230_points, topGroundGreen3_231_points, topGroundGreen3_232_points, topGroundGreen3_233_points, topGroundGreen3_234_points, topGroundGreen3_235_points, topGroundGreen3_236_points, topGroundGreen3_237_points, topGroundGreen3_238_points, topGroundGreen3_239_points,
topGroundGreen3_240_points, topGroundGreen3_241_points, topGroundGreen3_242_points, topGroundGreen3_243_points, topGroundGreen3_244_points, topGroundGreen3_245_points, topGroundGreen3_246_points, topGroundGreen3_247_points, topGroundGreen3_248_points, topGroundGreen3_249_points,
topGroundGreen3_250_points, topGroundGreen3_251_points, topGroundGreen3_252_points, topGroundGreen3_253_points, topGroundGreen3_254_points, topGroundGreen3_255_points, topGroundGreen3_256_points, topGroundGreen3_257_points, topGroundGreen3_258_points, topGroundGreen3_259_points,
topGroundGreen3_260_points, topGroundGreen3_261_points, topGroundGreen3_262_points, topGroundGreen3_263_points, topGroundGreen3_264_points, topGroundGreen3_265_points, topGroundGreen3_266_points, topGroundGreen3_267_points, topGroundGreen3_268_points, topGroundGreen3_269_points,

];
function getGroundTopBrown3Rings() = normalizeGroundFace( GROUND_TOP_BROWN3, 82 );
function getGroundTopGreen3Rings() = normalizeGroundFace( GROUND_TOP_GREEN3, 82 );
