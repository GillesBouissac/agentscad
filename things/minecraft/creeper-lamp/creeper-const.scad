/*
 * Copyright (c) 2021, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Minecraft Creeper Lamp - constants
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

SHADER_T = 1.2;

CGREEN1 = "#005500";
CGREEN2 = "#00d400";
CGREEN3 = "#66ff00";
CBROWN1 = "#784212";
CBROWN2 = "#b7950b";
CBROWN3 = "#fad7a0";
CGREY   = "#b3b3b3";
CBLACK  = "#202020";

HEAD_W = 120;
HEAD_L = HEAD_W;
HEAD_H = HEAD_W;

WALL_THIN = 2;
WALL_THICK = 4;

LED_RING_D = 50;

PLUG_D = 10.5;

SPRING_DEXT = 20;
SPRING_DINT = SPRING_DEXT-2*1.2;
SPRING_PD = LED_RING_D-2*WALL_THICK;
SPRING_L = 50;
SPRING_GAP = 10;
SPRING_GRIP_H = (SPRING_L-SPRING_GAP)/2;

BODY_H = 56;
BODY_L = 64;
BODY_W = 32;
BODY_BDH = 16;
BODY_HDH = 10;

FOOT_H = 24;
FOOT_L = 32;
FOOT_W = 24;

GROUND_H = 32;
GROUND_L = 136;
GROUND_W = 136;

FOOT_BH = GROUND_H;
BODY_BH = FOOT_BH+BODY_BDH;
HEAD_BH = BODY_BH+BODY_H-BODY_HDH;

LED_RING_H = HEAD_W/2;

BEVEL = 0.6;

// Head face selector
FACE_ALL = 0;
FACE_FRONT = 1;
FACE_RIGHT = 2;
FACE_BACK = 3;
FACE_LEFT = 4;
FACE_TOP = 5;
