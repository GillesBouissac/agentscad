/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable metric screws taking into account printer precision
 * Author:      Gilles Bouissac
 */
use <agentscad/lib-screw.scad>

// ----------------------------------------
//
//                     API
//
// ----------------------------------------

// Bolt passage loose on head to fit any type of head
module mxBoltPassage( p=M2() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module mxNutPassage( p=M2() ) { libNutPassage(p); }

// Hexagonal nut passage
module mxNutHexagonalPassage( p=M2() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module mxNutSquarePassage( p=M2() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Allen head
module mxBoltAllenPassage( p=M2() ) { libBoltAllenPassage(p); }

// Bolt passage Tight on head for Hexagonal head
module mxBoltHexagonalPassage( p=M2() ) { libBoltHexagonalPassage(p); }

// Bolt with Allen head
module mxBoltAllen( p=M2(), bt=true ) { libBoltAllen(p,bt); }

// Bolt with Hexagonal head
module mxBoltHexagonal( p=M2(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module mxNutHexagonal( p=M2(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module mxNutSquare( p=M2(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }

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
// Dimensions must be given in mm
//
function M1_6 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(0 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M2   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(1 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M2_5 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(2 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M3   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(3 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(4 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M5   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(5 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M6   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(6 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(7 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M10  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(8 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M12  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(9 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M14  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M18  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M20  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M22  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M24  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M27  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M30  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M33  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M36  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M39  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M42  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M45  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M48  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M52  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(24,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M56  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(25,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M60  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(26,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function M64  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = mxData(27,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
function mxGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( MXDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Clones a screw allowing to overrides some characteristics
function mxClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( MXDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Data accessors on data
function mxGetIdx(s)                 = screwGetIdx(s);
function mxGetName(s)                = screwGetName(s);
function mxGetTapD(s)                = screwGetTapD(s);
function mxGetPitch(s)               = screwGetPitch(s);
function mxGetThreadD(s)             = screwGetThreadD(s);
function mxGetThreadDP(s)            = screwGetThreadDP(s);
function mxGetThreadL(s)             = screwGetThreadL(s);
function mxGetThreadLP(s)            = screwGetThreadLP(s);
function mxGetHeadDP(s)              = screwGetHeadDP(s);
function mxGetHeadLP(s)              = screwGetHeadLP(s);

function mxGetAllenHeadD(s)          = screwGetAllenHeadD(s);
function mxGetAllenHeadL(s)          = screwGetAllenHeadL(s);
function mxGetAllenToolSize(s)       = screwGetAllenToolSize(s);

function mxGetHexagonalHeadD(s)      = screwGetHexagonalHeadD(s);
function mxGetHexagonalHeadL(s)      = screwGetHexagonalHeadL(s);
function mxGetHexagonalToolSize(s)   = screwGetHexagonalToolSize(s);

function mxGetSquareHeadD(s)         = screwGetSquareHeadD(s);
function mxGetSquareHeadL(s)         = screwGetSquareHeadL(s);
function mxGetSquareToolSize(s)      = screwGetSquareToolSize(s);

function mxGetDataLength() = len(MXDATA);
function mxData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( MXDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp)
;

//
// Raw data
//
// Sources:
//   https://shop.hpceurope.com/pdf/fr/CHC.pdf
//   http://www.fasnetdirect.com/refguide/Methexblt810.pdf
//   https://i.pinimg.com/originals/fd/df/69/fddf693160da9ad999c388e9ae1e4667.jpg
//   https://en.wikipedia.org/wiki/ISO_metric_screw_thread
//   http://ballsgrinding.com/ebay/SOCKET-SCREW-CAP-HEAD-ALLEN-BOLTS-DIMENSIONS-FASTENERS-METRIC-4.jpg
//   https://www.newfastener.com/wp-content/uploads/2013/03/DIN-912.pdf
//   https://www.fastenerdata.co.uk/fasteners/nuts/square.html
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

MXDATA = [
//| Name   | PITCH  |  TD  |  TL  | HDP  | HLP  |  AHD  | AHL  | ATS  |  HHL | HTS |
// idx=0
  [ "M1.6" ,   0.35 ,  1.6 ,   13 ,    5 ,  2.0 ,   3.0 ,  1.6 ,  1.5 ,  1.1 , 3.2 ],
  [ "M2"   ,   0.4  ,    2 ,   14 ,    6 ,  2.5 ,   3.8 ,  2   ,  1.5 ,  1.4 ,   4 ],
  [ "M2.5" ,   0.45 ,  2.5 ,   16 ,    7 ,  3.0 ,   4.5 ,  2.5 ,  2.0 ,  1.7 ,   5 ],
  [ "M3"   ,   0.5  ,    3 ,   17 ,    8 ,  3.5 ,   5.5 ,  3   ,  2.5 ,  2.0 , 5.5 ],
  [ "M4"   ,   0.7  ,    4 ,   20 ,   10 ,  4.5 ,   7.0 ,  4   ,  3.0 ,  2.8 ,   7 ],
  [ "M5"   ,   0.8  ,    5 ,   22 ,   11 ,  5.5 ,   8.5 ,  5   ,  4.0 ,  3.5 ,   8 ],
  [ "M6"   ,   1.0  ,    6 ,   24 ,   13 ,  6.5 ,  10.0 ,  6   ,  5.0 ,  4.0 ,  10 ],
  [ "M8"   ,   1.25 ,    8 ,   28 ,   17 ,  8.5 ,  13.0 ,  8   ,  6.0 ,  5.3 ,  13 ],
  [ "M10"  ,   1.5  ,   10 ,   32 ,   20 , 10.5 ,  16.0 , 10   ,  8.0 ,  6.4 ,  16 ],
  [ "M12"  ,   1.75 ,   12 ,   36 ,   22 , 12.5 ,  18.0 , 12   , 10.0 ,  7.5 ,  18 ],
// idx=10
  [ "M14"  ,   2.0  ,   14 ,   40 ,   26 , 14.5 ,  21.0 , 14   , 10.0 ,  8.8 ,  21 ],
  [ "M16"  ,   2.0  ,   16 ,   44 ,   29 , 16.5 ,  24.0 , 16   , 14.0 , 10.0 ,  24 ],
  [ "M18"  ,   2.5  ,   18 ,   48 ,   32 , 18.5 ,  27.0 , 18   , 14.0 , 11.5 ,  27 ],
  [ "M20"  ,   2.5  ,   20 ,   52 ,   36 , 21.0 ,  30.0 , 20   , 17.0 , 12.5 ,  30 ],
  [ "M22"  ,   2.5  ,   22 ,   56 ,   40 , 23.0 ,  33.0 , 22   , 17.0 , 14.0 ,  34 ],
  [ "M24"  ,   3.0  ,   24 ,   60 ,   42 , 25.0 ,  36.0 , 24   , 19.0 , 15.0 ,  36 ],
  [ "M27"  ,   3.0  ,   27 ,   66 ,   48 , 28.0 ,  40.0 , 27   , 19.0 , 17.0 ,  41 ],
  [ "M30"  ,   3.5  ,   30 ,   72 ,   53 , 32.0 ,  45.0 , 30   , 22.0 , 18.7 ,  46 ],
  [ "M33"  ,   3.5  ,   33 ,   78 ,   57 , 35.0 ,  50.0 , 33   , 24.0 , 21.0 ,  50 ],
  [ "M36"  ,   4.0  ,   36 ,   84 ,   63 , 38.0 ,  54.0 , 36   , 27.0 , 22.5 ,  55 ],
// idx=20
  [ "M39"  ,   4.0  ,   39 ,   90 ,   68 , 41.0 ,  58.0 , 39   , 27.0 , 25.0 ,  60 ],
  [ "M42"  ,   4.5  ,   42 ,   96 ,   73 , 45.0 ,  63.0 , 42   , 32.0 , 26.0 ,  65 ],
  [ "M45"  ,   4.5  ,   45 ,  102 ,   79 , 48.0 ,  67.0 , 45   , 32.0 , 28.0 ,  70 ],
  [ "M48"  ,   5.0  ,   48 ,  108 ,   84 , 51.0 ,  72.0 , 48   , 36.0 , 30.0 ,  75 ],
  [ "M52"  ,   5.0  ,   52 ,  116 ,   89 , 56.0 ,  78.0 , 52   , 36.0 , 33.0 ,  80 ],
  [ "M56"  ,   5.5  ,   56 ,  122 ,   95 , 60.0 ,  84.0 , 56   , 41.0 , 35.0 ,  85 ],
  [ "M60"  ,   5.5  ,   60 ,  130 ,  100 , 64.0 ,  90.0 , 60   , 41.0 , 38.0 ,  90 ],
  [ "M64"  ,   6.0  ,   64 ,  138 ,  105 , 68.0 ,  96.0 , 64   , 46.0 , 40.0 ,  95 ]
];

// HDP extrapolation from HTS
// According to C1 (HDP) from https://shop.hpceurope.com/pdf/fr/CHC.pdf:
// And ISO Hex nut tool sizes from https://en.wikipedia.org/wiki/ISO_metric_screw_thread
// 
//  Screw:    | 1.6 | 2 | 2.5 |  3  |  4 |  5 |  6 |  8 | 10 | 12 |
//            o-----o---o-----o-----o----o----o----o----o----o----o
//  C1/HDP:   |   5 | 6 |   7 | 8   | 10 | 11 | 13 | 17 | 20 | 22 |
//  HTS(ISO): | 3.2 | 4 |   5 | 5.5 |  7 |  8 | 10 | 13 | 16 | 18 |
//  diff:     | 1.8 | 2 |   2 | 2.5 |  3 |  3 |  3 |  4 |  4 |  4 |
// 
// Extrapolation: +1 every 3 screw
// 
//  Screw:    | 14 | 16 | 18 | 20 | 22 | 24 | 27 | 30 | 33 | 36 | 39 |
//            o----o----o----o----o----o----o----o----o----o----o----o
//  diff:     |  5 |  5 |  5 |  6 |  6 |  6 |  7 |  7 |  7 |  8 |  8 |
//  HTS(ISO): | 21 | 24 | 27 | 30 | 34 | 36 | 41 | 46 | 50 | 55 | 60 |
//  C1/HDP:   | 26 | 29 | 32 | 36 | 40 | 42 | 48 | 53 | 57 | 63 | 68 |
// 
//  Screw:    | 42 | 45 | 48 | 52 | 56 |  60 |  64 |
//            o----o----o----o----o----o-----o-----o
//  diff:     |  8 |  9 |  9 |  9 | 10 |  10 |  10 |
//  HTS(ISO): | 65 | 70 | 75 | 80 | 85 |  90 |  95 |
//  C1/HDP:   | 73 | 79 | 84 | 89 | 95 | 100 | 105 |

// TL extrapolation of common thread length, just for a default value
// Just get b value from https://shop.hpceurope.com/pdf/fr/CHC.pdf:

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
mxBoltHexagonal( M64(), $fn=100 );
translate([0,0,+mxGetThreadL(M64())] )
    color( "silver", 0.5 )
    mxNutHexagonal( M64(), $fn=100 );
translate([60,0]) {
    color( "gold" )
        mxBoltAllen( M1_6(), $fn=100 );
    color( "silver", 0.5 )
        mxNutSquare( M1_6(), $fn=100 );
}

echo( "mxGuess(   2):    expected M2: ",   mxGetName(mxGuess(2)) ) ;
echo( "mxGuess(  -2):    expected M2: ",   mxGetName(mxGuess(-2)) ) ;
echo( "mxGuess(  -1.99): expected M1.6: ", mxGetName(mxGuess(-1.99)) ) ;
echo( "mxGuess(   2.1):  expected M2.5: ", mxGetName(mxGuess(2.1)) ) ;
echo( "mxGuess(   0):    expected M1.6: ", mxGetName(mxGuess(0)) ) ;
echo( "mxGuess( 100):    expected undef:", mxGetName(mxGuess(100)) ) ;
echo( "mxGuess(-100):    expected M64:",   mxGetName(mxGuess(-100)) ) ;

