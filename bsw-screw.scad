/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable BSW screws
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
module bswBoltPassage( p=BSW1_4() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module bswNutPassage( p=BSW1_4() ) { libNutPassage(p); }

// Hexagonal nut passage
module bswNutHexagonalPassage( p=BSW1_4() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module bswNutSquarePassage( p=BSW1_4() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Allen head
module bswBoltAllenPassage( p=BSW1_4() ) { libBoltAllenPassage(p); }

// Bolt passage Tight on head for Hexagonal head
module bswBoltHexagonalPassage( p=BSW1_4() ) { libBoltHexagonalPassage(p); }

// Bolt with Allen head
module bswBoltAllen( p=BSW1_4(), bt=true ) { libBoltAllen(p,bt); }

// Bolt with Hexagonal head
module bswBoltHexagonal( p=BSW1_4(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module bswNutHexagonal( p=BSW1_4(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module bswNutSquare( p=BSW1_4(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }



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
function BSW5_32  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(0 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW3_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(1 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW7_32  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(2 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(3,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW5_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(4,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW3_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(5,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW7_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(6,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_2   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(7,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW9_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(8,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW5_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(9,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

function BSW3_4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW7_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_1_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_3_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_5_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW1_7_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

function BSW2     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW2_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW2_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW2_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW3     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(24,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW3_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(25,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW3_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(26,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW3_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(27,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSW4     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bswData(28,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
//
// Dimensions must be given in mm, use bswGuessInch for inch dimensions
//
function bswGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( BSWDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp,prf="W");

// Inch version of bswGuess
function bswGuessInch ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( BSWDATA,td=inch2mm(td),tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

// Clones a screw allowing to overrides some characteristics
//
// Dimensions must be given in mm, use bswCloneInch for inch dimensions
// Both gives same result if only p is provided
//
function bswClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( BSWDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of bswClone
function bswCloneInch (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( BSWDATA,p=p,tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

function bswGetDataLength() = len(BSWDATA);
//
// Dimensions must be given in mm
//
function bswData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( BSWDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp,prf="W")
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
//   PITCH: BSW (Unified National Fine) pitch value
//   TD:    Thread external Diameter
//   TL:    Thread Length default value
//   HDP:   Head Diameter Passage enough for any tool
//   HLP:   Head Length Passage default value
//   AHD:   Allen Head Diameter tight, do not allow tool passage, only head
//   AHL:   Allen Head Length tight
//   ATS:   Allen Tool Size
//   HHL:   Hexagonal Head Length tight
//   HTS:   Hexagonal Tool Size

//| Name        | PITCH  |   TD  |   TL  |  HDP  |  HLP  |  AHD  |  AHL  |  ATS  |   HHL |  HTS  |
BSWDATA_INCH = [
// idx=0
  [ "BSW 5/32"  ,   1/32 ,  5/32 ,  1/4  , undef , undef , undef ,  5/32 , undef , undef , undef ],
  [ "BSW 3/16"  ,   1/24 ,  3/16 ,  1/4  , undef , undef , undef ,  3/16 , undef , undef , undef ],
  [ "BSW 7/32"  ,   1/24 ,  7/32 ,  5/16 , undef , undef , undef ,  7/32 , undef , undef , undef ],
  [ "BSW 1/4"   ,   1/20 ,  1/4  ,  3/8  , undef , undef , 0.375 ,  1/4  ,  3/16 , 0.188 ,  7/16 ],
  [ "BSW 5/16"  ,   1/18 ,  5/16 ,  1/2  , undef , undef , 0.469 ,  5/16 ,  1/4  , 0.235 ,  1/2  ],
  [ "BSW 3/8"   ,   1/16 ,  3/8  ,  1/2  , undef , undef ,  9/16 ,  3/8  ,  5/16 , 0.268 ,  9/16 ],
  [ "BSW 7/16"  ,   1/14 ,  7/16 ,  3/4  , undef , undef ,  5/8  ,  7/16 ,  3/8  , 0.316 ,  5/8  ],
  [ "BSW 1/2"   ,   1/12 ,  1/2  ,  3/4  , undef , undef ,  3/4  ,  1/2  ,  3/8  , 0.364 ,  3/4  ],
  [ "BSW 9/16"  ,   1/12 ,  9/16 ,  1    , undef , undef ,  7/8  ,  9/16 ,  7/16 , 0.394 ,  7/8  ],
  [ "BSW 5/8"   ,   1/11 ,  5/8  ,  1    , undef , undef , 15/16 ,  5/8  ,  1/2  , 0.444 , 15/16 ],
// idx=10
  [ "BSW 3/4"   ,   1/10 ,  3/4  ,  5/4  , undef , undef ,  9/8  ,  3/4  ,  5/8  , 0.524 ,  9/8  ],
  [ "BSW 7/8"   ,   1/9  ,  7/8  ,  5/4  , undef , undef , 21/16 ,  7/8  ,  3/4  , 0.604 , 21/16 ],
  [ "BSW 1"     ,   1/8  ,  1    ,  3/2  , undef , undef ,  3/2  ,  1    ,  3/4  , 0.700 ,  3/2  ],
  [ "BSW 1 1/8" ,   1/7  ,  9/8  ,  3/2  , undef , undef , 27/16 ,  9/8  ,  7/8  , 0.780 , 27/16 ],
  [ "BSW 1 1/4" ,   1/7  ,  5/4  ,  2    , undef , undef , 15/8  ,  5/4  ,  1    , 0.876 , 15/8  ],
  [ "BSW 1 3/8" ,   1/6  , 11/8  ,  2    , undef , undef , 33/16 , 11/8  ,  9/8  , 0.940 , 33/16 ],
  [ "BSW 1 1/2" ,   1/6  ,  3/2  ,  5/2  , undef , undef ,  9/4  ,  3/2  ,  5/4  , 1.036 ,  9/4  ],
  [ "BSW 1 5/8" ,   1/5  , 13/8  ,  5/2  , undef , undef , undef , 13/8  , undef , undef , undef ],
  [ "BSW 1 3/4" ,   1/5  ,  7/4  ,  5/2  , undef , undef , 21/8  ,  7/4  ,  5/4  , undef , 21/8  ],
  [ "BSW 1 7/8" ,   2/9  , 15/8  ,  3    , undef , undef , undef , 15/8  , undef , undef , undef ],
// idx=20
  [ "BSW 2"     ,   2/9  ,  2    ,  3    , undef , undef ,  3    ,  2    ,  3/2  , undef ,  3    ],
  [ "BSW 2 1/4" ,   1/4  ,  9/4  ,  3    , undef , undef , 27/8  ,  9/4  ,  7/4  , undef , 27/8  ],
  [ "BSW 2 1/2" ,   1/4  ,  5/2  ,  7/2  , undef , undef , 15/4  ,  5/2  ,  2    , undef , 15/4  ],
  [ "BSW 2 3/4" ,   2/7  , 11/4  ,  7/2  , undef , undef , 33/8  , 11/4  ,  9/4  , undef , 33/8  ],
  [ "BSW 3"     ,   2/7  ,  3    ,  4    , undef , undef ,  9/2  ,  3    ,  9/4  , undef ,  9/2  ],
  [ "BSW 3 1/4" ,   4/13 , 13/4  ,  4    , undef , undef , 39/8  , 13/4  ,  5/2  , undef , 39/8  ],
  [ "BSW 3 1/2" ,   4/13 ,  7/2  ,  5    , undef , undef , 21/4  ,  7/2  , 11/4  , undef , 21/4  ],
  [ "BSW 3 3/4" ,   1/3  , 15/4  ,  5    , undef , undef , 45/8  , 15/4  ,  3    , undef , 45/8  ],
  [ "BSW 4"     ,   1/3  ,  4    ,  6    , undef , undef ,  6    ,  4    , 13/4  , undef ,  6    ],
];
BSWDATA = [ for ( d=BSWDATA_INCH ) inch2mm(d) ];

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
bswBoltHexagonal( BSW1_1_2(), $fn=100 );
translate([0,0,+screwGetThreadL(BSW1_1_2())] )
    color( "silver", 0.5 )
    bswNutHexagonal( BSW1_1_2(), $fn=100 );
translate([100,0]) {
    color( "gold" )
        bswBoltAllen( BSW5_32(), $fn=100 );
    color( "silver", 0.5 )
        bswNutSquare( BSW5_32(), $fn=100 );
}

echo( "bswGuessInch(   9/64  ): expected 'BSW 3/16': ", screwGetName(bswGuessInch( 11/64)) ) ;
echo( "bswGuessInch(  -9/64  ): expected 'BSW 5/32': ", screwGetName(bswGuessInch(-11/64)) ) ;
echo( "bswGuessInch(  -19/32 ): expected 'BSW 9/16': ", screwGetName(bswGuessInch(-19/32)) ) ;
echo( "bswGuessInch(   19/32 ): expected 'BSW 5/8': ",  screwGetName(bswGuessInch( 19/32)) ) ;
echo( "bswGuessInch(   0     ): expected 'BSW 5/32': ", screwGetName(bswGuessInch( 0)) ) ;
echo( "bswGuessInch( 100     ): expected undef:",       screwGetName(bswGuessInch( 100)) ) ;
echo( "bswGuessInch(-100     ): expected 'BSW 1 1/2':", screwGetName(bswGuessInch(-100)) ) ;

