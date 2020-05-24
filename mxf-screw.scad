/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable metric fine screws
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Bolt passage loose on head to fit any type of head
module mxfBoltPassage( p=MF2() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module mxfNutPassage( p=MF2() ) { libNutPassage(p); }

// Hexagonal nut passage
module mxfNutHexagonalPassage( p=MF2() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module mxfNutSquarePassage( p=MF2() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Allen head
module mxfBoltAllenPassage( p=MF2() ) { libBoltAllenPassage(p); }

// Bolt passage Tight on head for Hexagonal head
module mxfBoltHexagonalPassage( p=MF2() ) { libBoltHexagonalPassage(p); }

// Bolt with Allen head
module mxfBoltAllen( p=MF2(), bt=true ) { libBoltAllen(p,bt); }

// Bolt with Hexagonal head
module mxfBoltHexagonal( p=MF2(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module mxfNutHexagonal( p=MF2(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module mxfNutSquare( p=MF2(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }

// MXF constructors
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
// Dimensions must be given in mm
//
function MF1_6 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(0 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF2   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(1 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF2_5 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(2 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF3   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(3 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(4 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF5   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(5 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF6   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(6 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(7 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF10  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(8 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF12  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(9 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF14  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF18  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF20  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF22  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF24  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF27  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF30  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF33  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF36  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF39  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF42  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF45  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF48  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF52  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(24,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF56  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(25,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF60  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(26,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function MF64  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxfData(27,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
function mxfGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( MXFDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Clones a screw allowing to overrides some characteristics
function mxfClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( MXFDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

function mxfGetDataLength() = len(MXFDATA);
function mxfData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( MXFDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp)
;

//
// Raw data
//
// Sources:
//   https://en.wikipedia.org/wiki/ISO_metric_screw_thread
//
// WARNING: Dimensions are given in mm
//   PITCH: Standard coarse pitch value
//   TD:    Thread external Diameter
//   TL:    Thread Length default value
//   HDP:   Head Diameter Passage enough for any tool
//   HLP:   Head Length Passage default value
//   AHD:   Allen Head Diameter tight, do not allow tool passage, only head
//   AHL:   Allen Head Length tight
//   ATS:   Allen Tool Size
//   HHL:   Hexagonal Head Length tight
//   HTS:   Hexagonal Tool Size
//

MXFDATA = [
//| Name   | PITCH  |  TD  |  TL  | HDP  | HLP  |  AHD  | AHL  | ATS  |  HHL | HTS |
// idx=0
  [ "MF1.6" ,   0.2  ,  1.6 ,   13 ,    5 ,  2.0 ,   3.0 ,  1.6 ,  1.5 ,  1.1 , 3.2 ],
  [ "MF2"   ,   0.25 ,    2 ,   14 ,    6 ,  2.5 ,   3.8 ,  2   ,  1.5 ,  1.4 ,   4 ],
  [ "MF2.5" ,   0.35 ,  2.5 ,   16 ,    7 ,  3.0 ,   4.5 ,  2.5 ,  2.0 ,  1.7 ,   5 ],
  [ "MF3"   ,   0.35 ,    3 ,   17 ,    8 ,  3.5 ,   5.5 ,  3   ,  2.5 ,  2.0 , 5.5 ],
  [ "MF4"   ,   0.5  ,    4 ,   20 ,   10 ,  4.5 ,   7.0 ,  4   ,  3.0 ,  2.8 ,   7 ],
  [ "MF5"   ,   0.5  ,    5 ,   22 ,   11 ,  5.5 ,   8.5 ,  5   ,  4.0 ,  3.5 ,   8 ],
  [ "MF6"   ,   0.75 ,    6 ,   24 ,   13 ,  6.5 ,  10.0 ,  6   ,  5.0 ,  4.0 ,  10 ],
  [ "MF8"   ,   1.0  ,    8 ,   28 ,   17 ,  8.5 ,  13.0 ,  8   ,  6.0 ,  5.3 ,  13 ],
  [ "MF10"  ,   1.25 ,   10 ,   32 ,   20 , 10.5 ,  16.0 , 10   ,  8.0 ,  6.4 ,  16 ],
  [ "MF12"  ,   1.5  ,   12 ,   36 ,   22 , 12.5 ,  18.0 , 12   , 10.0 ,  7.5 ,  18 ],
// idx=10
  [ "MF14"  ,   1.5  ,   14 ,   40 ,   26 , 14.5 ,  21.0 , 14   , 10.0 ,  8.8 ,  21 ],
  [ "MF16"  ,   1.5  ,   16 ,   44 ,   29 , 16.5 ,  24.0 , 16   , 14.0 , 10.0 ,  24 ],
  [ "MF18"  ,   2.0  ,   18 ,   48 ,   32 , 18.5 ,  27.0 , 18   , 14.0 , 11.5 ,  27 ],
  [ "MF20"  ,   2.0  ,   20 ,   52 ,   36 , 21.0 ,  30.0 , 20   , 17.0 , 12.5 ,  30 ],
  [ "MF22"  ,   2.0  ,   22 ,   56 ,   40 , 23.0 ,  33.0 , 22   , 17.0 , 14.0 ,  34 ],
  [ "MF24"  ,   2.0  ,   24 ,   60 ,   42 , 25.0 ,  36.0 , 24   , 19.0 , 15.0 ,  36 ],
  [ "MF27"  ,   2.0  ,   27 ,   66 ,   48 , 28.0 ,  40.0 , 27   , 19.0 , 17.0 ,  41 ],
  [ "MF30"  ,   2.0  ,   30 ,   72 ,   53 , 32.0 ,  45.0 , 30   , 22.0 , 18.7 ,  46 ],
  [ "MF33"  ,   2.0  ,   33 ,   78 ,   57 , 35.0 ,  50.0 , 33   , 24.0 , 21.0 ,  50 ],
  [ "MF36"  ,   3.0  ,   36 ,   84 ,   63 , 38.0 ,  54.0 , 36   , 27.0 , 22.5 ,  55 ],
// idx=20
  [ "MF39"  ,   3.0  ,   39 ,   90 ,   68 , 41.0 ,  58.0 , 39   , 27.0 , 25.0 ,  60 ],
  [ "MF42"  ,   3.0  ,   42 ,   96 ,   73 , 45.0 ,  63.0 , 42   , 32.0 , 26.0 ,  65 ],
  [ "MF45"  ,   3.0  ,   45 ,  102 ,   79 , 48.0 ,  67.0 , 45   , 32.0 , 28.0 ,  70 ],
  [ "MF48"  ,   3.0  ,   48 ,  108 ,   84 , 51.0 ,  72.0 , 48   , 36.0 , 30.0 ,  75 ],
  [ "MF52"  ,   4.0  ,   52 ,  116 ,   89 , 56.0 ,  78.0 , 52   , 36.0 , 33.0 ,  80 ],
  [ "MF56"  ,   4.0  ,   56 ,  122 ,   95 , 60.0 ,  84.0 , 56   , 41.0 , 35.0 ,  85 ],
  [ "MF60"  ,   4.0  ,   60 ,  130 ,  100 , 64.0 ,  90.0 , 60   , 41.0 , 38.0 ,  90 ],
  [ "MF64"  ,   4.0  ,   64 ,  138 ,  105 , 68.0 ,  96.0 , 64   , 46.0 , 40.0 ,  95 ]
];

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
mxfBoltHexagonal( MF64(), $fn=100 );
translate([0,0,+screwGetThreadL(MF64())] )
    color( "silver", 0.5 )
    mxfNutHexagonal( MF64(), $fn=100 );
translate([60,0]) {
    color( "gold" )
        mxfBoltAllen( MF1_6(), $fn=100 );
    color( "silver", 0.5 )
        mxfNutSquare( MF1_6(), $fn=100 );
}

echo( "mxfGuess(   2):    expected M2: ",   screwGetName(mxfGuess(2)) ) ;
echo( "mxfGuess(  -2):    expected M2: ",   screwGetName(mxfGuess(-2)) ) ;
echo( "mxfGuess(  -1.99): expected M1.6: ", screwGetName(mxfGuess(-1.99)) ) ;
echo( "mxfGuess(   2.1):  expected M2.5: ", screwGetName(mxfGuess(2.1)) ) ;
echo( "mxfGuess(   0):    expected M1.6: ", screwGetName(mxfGuess(0)) ) ;
echo( "mxfGuess( 100):    expected undef:", screwGetName(mxfGuess(100)) ) ;
echo( "mxfGuess(-100):    expected M64:",   screwGetName(mxfGuess(-100)) ) ;

