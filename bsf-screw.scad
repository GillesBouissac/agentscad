/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable BSF screws
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
module bsfBoltPassage( p=BSF1_4() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module bsfNutPassage( p=BSF1_4() ) { libNutPassage(p); }

// Hexagonal nut passage
module bsfNutHexagonalPassage( p=BSF1_4() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module bsfNutSquarePassage( p=BSF1_4() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Allen head
module bsfBoltAllenPassage( p=BSF1_4() ) { libBoltAllenPassage(p); }

// Bolt passage Tight on head for Hexagonal head
module bsfBoltHexagonalPassage( p=BSF1_4() ) { libBoltHexagonalPassage(p); }

// Bolt with Allen head
module bsfBoltAllen( p=BSF1_4(), bt=true ) { libBoltAllen(p,bt); }

// Bolt with Hexagonal head
module bsfBoltHexagonal( p=BSF1_4(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module bsfNutHexagonal( p=BSF1_4(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module bsfNutSquare( p=BSF1_4(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }



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
function BSF3_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(0 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF7_32  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(1 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(2,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF9_32  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(3 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF5_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(4,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF3_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(5,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF7_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(6,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_2   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(7,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF9_16  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(8,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF5_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(9,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

function BSF11_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF3_4   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF13_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF7_8   (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_1_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_3_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF1_5_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

function BSF1_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF2     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF2_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF2_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF2_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(24,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF3     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(25,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF3_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(26,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF3_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(27,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF3_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(28,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function BSF4     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = bsfData(29,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);

// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
//
// Dimensions must be given in mm, use bsfGuessInch for inch dimensions
//
function bsfGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( BSFDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp,prf="W");

// Inch version of bsfGuess
function bsfGuessInch ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( BSFDATA,td=inch2mm(td),tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

// Clones a screw allowing to overrides some characteristics
//
// Dimensions must be given in mm, use bsfCloneInch for inch dimensions
// Both gives same result if only p is provided
//
function bsfClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( BSFDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of bsfClone
function bsfCloneInch (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( BSFDATA,p=p,tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

function bsfGetDataLength() = len(BSFDATA);
//
// Dimensions must be given in mm
//
function bsfData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( BSFDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp,prf="W")
;

//
// Raw data
//
// Sources:
//   https://www.fastenerdata.co.uk/bsf
//   http://www.modelfixings.co.uk/thread_data.htm
//
// WARNING: For reading convenience and comparison to standards, dimensions are given in inch.
//          They are converted to mm because the library units are millimeters
//   PITCH: BSF (Unified National Fine) pitch value
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
BSFDATA_INCH = [
// idx=0
  [ "BSF 3/16"  ,   1/32 ,  3/16 ,  1/4  , undef , undef , undef ,  3/16 , undef , undef , undef ],
  [ "BSF 7/32"  ,   1/28 ,  7/32 ,  5/16 , undef , undef , undef ,  7/32 , undef , undef , undef ],
  [ "BSF 1/4"   ,   1/26 ,  1/4  ,  3/8  , undef , undef , 0.375 ,  1/4  ,  3/16 , 0.188 ,  7/16 ],
  [ "BSF 9/32"  ,   1/26 ,  9/32 ,  3/8  , undef , undef , undef ,  9/32 , undef , undef , undef ],
  [ "BSF 5/16"  ,   1/22 ,  5/16 ,  1/2  , undef , undef , 0.469 ,  5/16 ,  1/4  , 0.235 ,  1/2  ],
  [ "BSF 3/8"   ,   1/20 ,  3/8  ,  1/2  , undef , undef ,  9/16 ,  3/8  ,  5/16 , 0.268 ,  9/16 ],
  [ "BSF 7/16"  ,   1/18 ,  7/16 ,  3/4  , undef , undef ,  5/8  ,  7/16 ,  3/8  , 0.316 ,  5/8  ],
  [ "BSF 1/2"   ,   1/16 ,  1/2  ,  3/4  , undef , undef ,  3/4  ,  1/2  ,  3/8  , 0.364 ,  3/4  ],
  [ "BSF 9/16"  ,   1/16 ,  9/16 ,  1    , undef , undef ,  7/8  ,  9/16 ,  7/16 , 0.394 ,  7/8  ],
  [ "BSF 5/8"   ,   1/14 ,  5/8  ,  1    , undef , undef , 15/16 ,  5/8  ,  1/2  , 0.444 , 15/16 ],
// idx=10
  [ "BSF 11/16" ,   1/14 , 11/16 ,  1    , undef , undef , undef , 11/16 , undef , undef , undef ],
  [ "BSF 3/4"   ,   1/12 ,  3/4  ,  5/4  , undef , undef ,  9/8  ,  3/4  ,  5/8  , 0.524 ,  9/8  ],
  [ "BSF 13/16" ,   1/12 , 13/16 ,  5/4  , undef , undef , undef , 13/16 , undef , undef , undef ],
  [ "BSF 7/8"   ,   1/11 ,  7/8  ,  5/4  , undef , undef , 21/16 ,  7/8  ,  3/4  , 0.604 , 21/16 ],
  [ "BSF 1"     ,   1/10 ,  1    ,  3/2  , undef , undef ,  3/2  ,  1    ,  3/4  , 0.700 ,  3/2  ],
  [ "BSF 1 1/8" ,   1/9  ,  9/8  ,  3/2  , undef , undef , 27/16 ,  9/8  ,  7/8  , 0.780 , 27/16 ],
  [ "BSF 1 1/4" ,   1/9  ,  5/4  ,  2    , undef , undef , 15/8  ,  5/4  ,  1    , 0.876 , 15/8  ],
  [ "BSF 1 3/8" ,   1/8  , 11/8  ,  2    , undef , undef , 33/16 , 11/8  ,  9/8  , 0.940 , 33/16 ],
  [ "BSF 1 1/2" ,   1/8  ,  3/2  ,  5/2  , undef , undef ,  9/4  ,  3/2  ,  5/4  , 1.036 ,  9/4  ],
  [ "BSF 1 5/8" ,   1/8  , 13/8  ,  5/2  , undef , undef , undef , 13/8  , undef , undef , undef ],
// idx=20
  [ "BSF 1 3/4" ,   1/7  ,  7/4  ,  5/2  , undef , undef , 21/8  ,  7/4  ,  5/4  , undef , 21/8  ],
  [ "BSF 2"     ,   1/7  ,  2    ,  3    , undef , undef ,  3    ,  2    ,  3/2  , undef ,  3    ],
  [ "BSF 2 1/4" ,   1/6  ,  9/4  ,  3    , undef , undef , 27/8  ,  9/4  ,  7/4  , undef , 27/8  ],
  [ "BSF 2 1/2" ,   1/6  ,  5/2  ,  7/2  , undef , undef , 15/4  ,  5/2  ,  2    , undef , 15/4  ],
  [ "BSF 2 3/4" ,   1/6  , 11/4  ,  7/2  , undef , undef , 33/8  , 11/4  ,  9/4  , undef , 33/8  ],
  [ "BSF 3"     ,   1/5  ,  3    ,  4    , undef , undef ,  9/2  ,  3    ,  9/4  , undef ,  9/2  ],
  [ "BSF 3 1/4" ,   1/5  , 13/4  ,  4    , undef , undef , 39/8  , 13/4  ,  5/2  , undef , 39/8  ],
  [ "BSF 3 1/2" ,   2/9  ,  7/2  ,  5    , undef , undef , 21/4  ,  7/2  , 11/4  , undef , 21/4  ],
  [ "BSF 3 3/4" ,   2/9  , 15/4  ,  5    , undef , undef , 45/8  , 15/4  ,  3    , undef , 45/8  ],
  [ "BSF 4"     ,   2/9  ,  4    ,  6    , undef , undef ,  6    ,  4    , 13/4  , undef ,  6    ],
];
BSFDATA = [ for ( d=BSFDATA_INCH ) inch2mm(d) ];

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
bsfBoltHexagonal( BSF1_1_2(), $fn=100 );
translate([0,0,+screwGetThreadL(BSF1_1_2())] )
    color( "silver", 0.5 )
    bsfNutHexagonal( BSF1_1_2(), $fn=100 );
translate([100,0]) {
    color( "gold" )
        bsfBoltAllen( BSF3_16(), $fn=100 );
    color( "silver", 0.5 )
        bsfNutSquare( BSF3_16(), $fn=100 );
}

echo( "bsfGuessInch(   9/64  ): expected 'BSF 7/32': ", screwGetName(bsfGuessInch( 13/64)) ) ;
echo( "bsfGuessInch(  -9/64  ): expected 'BSF 3/16': ", screwGetName(bsfGuessInch(-13/64)) ) ;
echo( "bsfGuessInch(  -19/32 ): expected 'BSF 9/16': ", screwGetName(bsfGuessInch(-19/32)) ) ;
echo( "bsfGuessInch(   19/32 ): expected 'BSF 5/8': ",  screwGetName(bsfGuessInch( 19/32)) ) ;
echo( "bsfGuessInch(   0     ): expected 'BSF 3/16': ", screwGetName(bsfGuessInch( 0)) ) ;
echo( "bsfGuessInch( 100     ): expected undef:",       screwGetName(bsfGuessInch( 100)) ) ;
echo( "bsfGuessInch(-100     ): expected 'BSF 4':",     screwGetName(bsfGuessInch(-100)) ) ;

