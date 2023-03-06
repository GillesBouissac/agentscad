/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable BSPPP screws
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>
use <agentscad/extensions.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Bolt passage loose on head to fit any type of head
module bsppBoltPassage( p=BSPP1_4() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module bsppNutPassage( p=BSPP1_4() ) { libNutPassage(p); }

// Hexagonal nut passage
module bsppNutHexagonalPassage( p=BSPP1_4() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module bsppNutSquarePassage( p=BSPP1_4() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Hexagonal head
module bsppBoltHexagonalPassage( p=BSPP1_4() ) { libBoltHexagonalPassage(p); }

// Bolt with Hexagonal head
module bsppBoltHexagonal( p=BSPP1_4(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module bsppNutHexagonal( p=BSPP1_4(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module bsppNutSquare( p=BSPP1_4(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }



// Mx constructors
//   tl:  Thread length,                    undef = use common value
//   tlp: Thread length passage,            undef = tl
//   ahl: Allen Head Length                 undef = use common value
//   hhl: Hexagonal Head Length             undef = use common value
//   hlp: Head Length Passage,              undef = use common value
//   tdp: Thread Diameter Passage,          undef = computed from td and gap()
//   ahd: Allen Head diameter,              undef = use common value
//   hhd: Hexagonal Head diameter,          undef = use standard value
//   hdp: Head Diameter Passage,            undef = use common value
//
// Dimensions must be given in mm.
//   See inch2mm() from <agentscad/extensions.scad> to convert inch values to mm before call
//
function BSPP1_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 0,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 1,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1_4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 2,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP3_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 3,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1_2   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 4,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP5_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 5,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP3_4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 6,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP7_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 7,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 8,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1_1_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData( 9,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

function BSPP1_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP1_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP2     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP2_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP2_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP2_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP3     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP3_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP4     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

function BSPP4_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP5     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP5_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSPP6     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsppData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
//
// Dimensions must be given in mm, use bsppGuessInch for inch dimensions
//
function bsppGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( BSPPDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp,prf="W");

// Inch version of bsppGuess
function bsppGuessInch ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( BSPPDATA,td=inch2mm(td),tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

// Clones a screw allowing to overrides some characteristics
//
// Dimensions must be given in mm, use bsppCloneInch for inch dimensions
// Both gives same result if only p is provided
//
function bsppClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( BSPPDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of bsppClone
function bsppCloneInch (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( BSPPDATA,p=p,tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

function bsppGetDataLength() = len(BSPPDATA);
//
// Dimensions must be given in mm
//
function bsppData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( BSPPDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp,prf="W")
;

//
// Raw data
//
// Sources:
//   https://www.fastenerdata.co.uk/whitworth
//   http://www.modelfixings.co.uk/thread_data.htm
//
// WARNING: For reading convenience and comparison to standards, dimensions are given in inch.
//          They are converted to mm because the library units are millimeters
//   PITCH: BSPP (Unified National Fine) pitch value
//   TD:    Thread external Diameter
//   TL:    Thread Length default value
//   HDP:   Head Diameter Passage enough for any tool
//   HLP:   Head Length Passage default value
//   AHD:   Allen Head Diameter tight, do not allow tool passage, only head
//   AHL:   Allen Head Length tight
//   ATS:   Allen Tool Size
//   HHL:   Hexagonal Head Length tight
//   HTS:   Hexagonal Tool Size

//| Name        |           PITCH |      TD |     TL |     HDP |     HLP |   AHD |   AHL |   ATS |   HHL |  HTS  |
BSPPDATA = [
// idx=0
  [ "BSPP 1/16"  ,   inch2mm(1/28) ,   7.723 ,  8.000 ,  16.373 ,   7.723 , undef , undef , undef ,   4.943 ,  12.000 ],
  [ "BSPP 1/8"   ,   inch2mm(1/28) ,   9.728 ,  8.000 ,  20.623 ,   9.728 , undef , undef , undef ,   6.226 ,  14.000 ],
  [ "BSPP 1/4"   ,   inch2mm(1/19) ,  13.157 , 12.000 ,  27.893 ,  13.157 , undef , undef , undef ,   8.420 ,  19.000 ],
  [ "BSPP 3/8"   ,   inch2mm(1/19) ,  16.662 , 12.800 ,  35.323 ,  16.662 , undef , undef , undef ,  10.664 ,  22.000 ],
  [ "BSPP 1/2"   ,   inch2mm(1/14) ,  20.955 , 16.400 ,  44.425 ,  20.955 , undef , undef , undef ,  13.411 ,  27.000 ],
  [ "BSPP 5/8"   ,   inch2mm(1/14) ,  22.911 , 16.400 ,  48.571 ,  22.911 , undef , undef , undef ,  14.663 ,  30.000 ],
  [ "BSPP 3/4"   ,   inch2mm(1/14) ,  26.441 , 19.000 ,  56.055 ,  26.441 , undef , undef , undef ,  16.922 ,  32.000  ],
  [ "BSPP 7/8"   ,   inch2mm(1/14) ,  30.201 , 19.000 ,  64.026 ,  30.201 , undef , undef , undef ,  19.329 ,  37.000 ],
  [ "BSPP 1"     ,   inch2mm(1/11) ,  33.249 , 20.800 ,  70.488 ,  33.249 , undef , undef , undef ,  21.279 ,  41.000 ],
  [ "BSPP 1 1/8" ,   inch2mm(1/11) ,  37.897 , 20.800 ,  80.342 ,  37.897 , undef , undef , undef ,  24.254 ,  46.000 ],
// idx=10
  [ "BSPP 1 1/4" ,   inch2mm(1/11) ,  41.910 , 25.400 ,  88.849 ,  41.910 , undef , undef , undef ,  26.822 ,  50.000 ],
  [ "BSPP 1 1/2" ,   inch2mm(1/11) ,  47.803 , 25.400 , 101.342 ,  47.803 , undef , undef , undef ,  30.594 ,  57.000 ],
  [ "BSPP 1 3/4" ,   inch2mm(1/11) ,  53.746 , 31.800 , 113.942 ,  53.746 , undef , undef , undef ,  34.397 ,  63.000 ],
  [ "BSPP 2"     ,   inch2mm(1/11) ,  59.614 , 31.800 , 126.382 ,  59.614 , undef , undef , undef ,  38.153 ,  70.000 ],
  [ "BSPP 2 1/4" ,   inch2mm(1/11) ,  65.710 , 35.000 , 139.305 ,  65.710 , undef , undef , undef ,  42.054 ,  77.000 ],
  [ "BSPP 2 1/2" ,   inch2mm(1/11) ,  75.184 , 35.000 , 159.390 ,  75.184 , undef , undef , undef ,  48.118 ,  88.000 ],
  [ "BSPP 2 3/4" ,   inch2mm(1/11) ,  81.534 , 41.200 , 172.852 ,  81.534 , undef , undef , undef ,  52.182 ,  95.000 ],
  [ "BSPP 3"     ,   inch2mm(1/11) ,  87.884 , 41.200 , 186.314 ,  87.884 , undef , undef , undef ,  56.246 , 103.000 ],
  [ "BSPP 3 1/2" ,   inch2mm(1/11) , 100.330 , 44.400 , 212.700 , 100.330 , undef , undef , undef ,  64.211 , 117.000 ],
  [ "BSPP 4"     ,   inch2mm(1/11) , 113.030 , 50.800 , 239.624 , 113.030 , undef , undef , undef ,  72.339 , 132.000 ],
// idx=20
  [ "BSPP 4 1/2" ,   inch2mm(1/11) , 125.730 , 50.800 , 266.548 , 125.730 , undef , undef , undef ,  80.467 , 147.000 ],
  [ "BSPP 5"     ,   inch2mm(1/11) , 138.430 , 57.200 , 293.472 , 138.430 , undef , undef , undef ,  88.595 , 162.000 ],
  [ "BSPP 5 1/2" ,   inch2mm(1/11) , 151.130 , 57.200 , 320.396 , 151.130 , undef , undef , undef ,  96.723 , 177.000 ],
  [ "BSPP 6"     ,   inch2mm(1/11) , 163.830 , 57.200 , 347.320 , 163.830 , undef , undef , undef , 104.851 , 192.000 ],
];

// Original pipe diameters are the value of the BSPP (Steel pipe D=1/8 for BSPP 1/8)
// Today diameters are higher
BSPPPIPES = [
// idx=0
  3,     // BSPP 1/16
  6,     // BSPP 1/8
  8,     // BSPP 1/4
  10,    // BSPP 3/8
  15,    // BSPP 1/2
  17,    // BSPP 5/8
  20,    // BSPP 3/4
  22,    // BSPP 7/8
  25,    // BSPP 1
  28,    // BSPP 1 1/8
// idx=10
  32,    // BSPP 1 1/4
  40,    // BSPP 1 1/2
  45,    // BSPP 1 3/4
  50,    // BSPP 2
  57,    // BSPP 2 1/4
  65,    // BSPP 2 1/2
  72,    // BSPP 2 3/4
  80,    // BSPP 3
  90,    // BSPP 3 1/2
  100,   // BSPP 4
// idx=20
  112,   // BSPP 4 1/2
  125,   // BSPP 5
  137,   // BSPP 5 1/2
  150,   // BSPP 6
];
function bsppGetPipeD(d) = let(idx=screwGetIdx(d)) BSPPPIPES[idx];


// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
bsppBoltHexagonal( BSPP1_1_2(), $fn=100 );
translate([0,0,+screwGetThreadL(BSPP1_1_2())] )
    color( "silver", 0.5 )
    bsppNutHexagonal( BSPP1_1_2(), $fn=100 );
translate([100,0]) {
    color( "gold" )
        bsppBoltAllen( BSPP5_32(), $fn=100 );
    color( "silver", 0.5 )
        bsppNutSquare( BSPP5_32(), $fn=100 );
}

echo( "bsppGuessInch(   9/64  ): expected 'BSPP 3/16': ", screwGetName(bsppGuessInch( 11/64)) ) ;
echo( "bsppGuessInch(  -9/64  ): expected 'BSPP 5/32': ", screwGetName(bsppGuessInch(-11/64)) ) ;
echo( "bsppGuessInch(  -19/32 ): expected 'BSPP 9/16': ", screwGetName(bsppGuessInch(-19/32)) ) ;
echo( "bsppGuessInch(   19/32 ): expected 'BSPP 5/8': ",  screwGetName(bsppGuessInch( 19/32)) ) ;
echo( "bsppGuessInch(   0     ): expected 'BSPP 1/16': ", screwGetName(bsppGuessInch( 0)) ) ;
echo( "bsppGuessInch( 100     ): expected undef:",       screwGetName(bsppGuessInch( 100)) ) ;
echo( "bsppGuessInch(-100     ): expected 'BSPP 4':",     screwGetName(bsppGuessInch(-100)) ) ;

