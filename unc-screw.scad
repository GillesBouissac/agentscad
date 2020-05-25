/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable UNC screws
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
module uncBoltPassage( p=UNC1_4() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module uncNutPassage( p=UNC1_4() ) { libNutPassage(p); }

// Hexagonal nut passage
module uncNutHexagonalPassage( p=UNC1_4() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module uncNutSquarePassage( p=UNC1_4() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Allen head
module uncBoltAllenPassage( p=UNC1_4() ) { libBoltAllenPassage(p); }

// Bolt passage Tight on head for Hexagonal head
module uncBoltHexagonalPassage( p=UNC1_4() ) { libBoltHexagonalPassage(p); }

// Bolt with Allen head
module uncBoltAllen( p=UNC1_4(), bt=true ) { libBoltAllen(p,bt); }

// Bolt with Hexagonal head
module uncBoltHexagonal( p=UNC1_4(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module uncNutHexagonal( p=UNC1_4(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module uncNutSquare( p=UNC1_4(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }



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
function UNC_N1  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(0 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N2  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(1 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N3  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(2 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N4  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(3 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N5  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(4 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N6  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(5 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(6 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N10 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(7 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC_N12 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(8 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_4  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(9 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC5_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC3_8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC7_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_2  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC9_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC5_8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC3_4  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC7_8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1    (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = uncData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_1_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_3_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC1_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC2     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(24,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC2_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(25,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC2_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(26,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC2_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(27,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC3     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(28,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC3_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(29,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC3_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(30,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC3_3_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(31,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNC4     (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = uncData(32,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);


// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
//
// Dimensions must be given in mm, use uncGuessInch for inch dimensions
//
function uncGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( UNCDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of uncGuess
function uncGuessInch ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( UNCDATA,td=inch2mm(td),tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

// Clones a screw allowing to overrides some characteristics
//
// Dimensions must be given in mm, use uncCloneInch for inch dimensions
// Both gives same result if only p is provided
//
function uncClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( UNCDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of uncClone
function uncCloneInch (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( UNCDATA,p=p,tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

function uncGetDataLength() = len(UNCDATA);
//
// Dimensions must be given in mm
//
function uncData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( UNCDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp)
;

//
// Raw data
//
// Sources:
//   https://www.engineeringtoolbox.com/unified-screw-threads-unc-unf-d_1809.html
//   https://www.engineeringtoolbox.com/hex-bolts-inches-d_2051.html
//   http://www.modelfixings.co.uk/thread_data.htm
//   https://www.marleva.net/visserie-boulonnerie/boulonnerie-americaine-vis-chc-6-pans-creux-filetage-unc/
//   https://en.wikipedia.org/wiki/Unified_Thread_Standard
//   http://www.accuratescrew.com/asm-technical-info/socket-cap-screw-data/
//   https://www.westfieldfasteners.co.uk/A2_ScrewBolt_HexHd_UNCoarse0.5000_THRpart.html
//   https://www.westfieldfasteners.co.uk/UNC.html
//
// WARNING: For reading convenience and comparison to standards, dimensions are given in inch.
//          They are converted to mm because the library units are millimeters
//   PITCH: UNC (Unified National Coarse) pitch value
//   TD:    Thread external Diameter
//   TL:    Thread Length default value
//   HDP:   Head Diameter Passage enough for any tool
//   HLP:   Head Length Passage default value
//   AHD:   Allen Head Diameter
//   AHL:   Allen Head Length
//   ATS:   Allen Tool Size
//   HHL:   Hexagonal Head Length
//   HTS:   Hexagonal Tool Size

//| Name        | PITCH  |   TD  |   TL  |  HDP  |  HLP  |  AHD  |  AHL  |  ATS  |   HHL |  HTS  |
UNCDATA_INCH = [
// idx=0
  [ "UNC #1"    ,   1/64 , 0.073 ,   1/4 , undef , undef , 0.118 , 0.073 ,  1/16 , undef , undef ],
  [ "UNC #2"    ,   1/56 , 0.086 ,   1/4 , undef , undef , 0.140 , 0.086 ,  5/64 , undef , undef ],
  [ "UNC #3"    ,   1/48 , 0.099 ,   1/4 , undef , undef , 0.161 , 0.099 ,  5/64 , undef , undef ],
  [ "UNC #4"    ,   1/40 , 0.112 ,   1/4 , undef , undef , 0.183 , 0.112 ,  3/32 , undef , undef ],
  [ "UNC #5"    ,   1/40 ,  1/8  ,  5/16 , undef , undef , 0.205 ,  1/8  ,  3/32 , undef , undef ],
  [ "UNC #6"    ,   1/32 , 0.138 ,  5/16 , undef , undef , 0.226 , 0.138 ,  7/64 , undef , undef ],
  [ "UNC #8"    ,   1/32 , 0.164 ,  5/16 , undef , undef , 0.270 , 0.164 ,  9/64 , undef , undef ],
  [ "UNC #10"   ,   1/24 , 0.190 ,   3/8 , undef , undef , 0.312 , 0.190 ,  5/32 , undef , undef ],
  [ "UNC #12"   ,   1/24 ,  7/32 ,   3/8 , undef , undef , 0.343 ,  7/32 ,  5/32 , undef , undef ],
  [ "UNC 1/4"   ,   1/20 ,  1/4  ,   3/8 , undef , undef , 0.375 ,  1/4  ,  3/16 , 0.188 ,  7/16 ],
// idx=10
  [ "UNC 5/16"  ,   1/18 ,  5/16 ,   1/2 , undef , undef , 0.469 ,  5/16 ,  1/4  , 0.235 ,  1/2  ],
  [ "UNC 3/8"   ,   1/16 ,  3/8  ,   1/2 , undef , undef ,  9/16 ,  3/8  ,  5/16 , 0.268 ,  9/16 ],
  [ "UNC 7/16"  ,   1/14 ,  7/16 ,   3/4 , undef , undef ,  5/8  ,  7/16 ,  3/8  , 0.316 ,  5/8  ],
  [ "UNC 1/2"   ,   1/13 ,  1/2  ,   3/4 , undef , undef ,  3/4  ,  1/2  ,  3/8  , 0.364 ,  3/4  ],
  [ "UNC 9/16"  ,   1/12 ,  9/16 ,   1   , undef , undef ,  7/8  ,  9/16 ,  7/16 , 0.394 ,  7/8  ],
  [ "UNC 5/8"   ,   1/11 ,  5/8  ,   1   , undef , undef , 15/16 ,  5/8  ,  1/2  , 0.444 , 15/16 ],
  [ "UNC 3/4"   ,   1/10 ,  3/4  ,   5/4 , undef , undef ,  9/8  ,  3/4  ,  5/8  , 0.524 ,  9/8  ],
  [ "UNC 7/8"   ,   1/9  ,  7/8  ,   5/4 , undef , undef , 21/16 ,  7/8  ,  3/4  , 0.604 , 21/16 ],
  [ "UNC 1"     ,   1/8  ,  1    ,   3/2 , undef , undef ,  3/2  ,  1    ,  3/4  , 0.700 ,  3/2  ],
  [ "UNC 1 1/8" ,   1/7  ,  9/8  ,   3/2 , undef , undef , 27/16 ,  9/8  ,  7/8  , 0.780 , 27/16 ],
// idx=20
  [ "UNC 1 1/4" ,   1/7  ,  5/4  ,   2   , undef , undef , 15/8  ,  5/4  ,  1    , 0.876 , 15/8  ],
  [ "UNC 1 3/8" ,   1/6  , 11/8  ,   2   , undef , undef , 33/16 , 11/8  ,  9/8  , 0.940 , 33/16 ],
  [ "UNC 1 1/2" ,   1/6  ,  3/2  ,   5/2 , undef , undef ,  9/4  ,  3/2  ,  5/4  , 1.036 ,  9/4  ],
  [ "UNC 1 3/4" ,   1/5  ,  7/4  ,   5/2 , undef , undef , 21/8  ,  7/4  ,  5/4  , undef , 21/8  ],
  [ "UNC 2"     ,   2/9  ,  2    ,   3   , undef , undef ,  3    ,  2    ,  3/2  , undef ,  3    ],
  [ "UNC 2 1/4" ,   2/9  ,  9/4  ,   3   , undef , undef , 27/8  ,  9/4  ,  7/4  , undef , 27/8  ],
  [ "UNC 2 1/2" ,   1/4  ,  5/2  ,   7/2 , undef , undef , 15/4  ,  5/2  ,  2    , undef , 15/4  ],
  [ "UNC 2 3/4" ,   1/4  , 11/4  ,   7/2 , undef , undef , 33/8  , 11/4  ,  9/4  , undef , 33/8  ],
  [ "UNC 3"     ,   1/4  ,  3    ,   4   , undef , undef ,  9/2  ,  3    ,  9/4  , undef ,  9/2  ],
  [ "UNC 3 1/4" ,   1/4  , 13/4  ,   4   , undef , undef , 39/8  , 13/4  ,  5/2  , undef , 39/8  ],
// idx=30
  [ "UNC 3 1/2" ,   1/4  ,  7/2  ,   5   , undef , undef , 21/4  ,  7/2  , 11/4  , undef , 21/4  ],
  [ "UNC 3 3/4" ,   1/4  , 15/4  ,   5   , undef , undef , 45/8  , 15/4  ,  3    , undef , 45/8  ],
  [ "UNC 4"     ,   1/4  ,  4    ,   6   , undef , undef ,  6    ,  4    , 13/4  , undef ,  6    ],
];
UNCDATA = [ for ( d=UNCDATA_INCH ) inch2mm(d) ];

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
uncBoltHexagonal( UNC4(), $fn=100 );
translate([0,0,+screwGetThreadL(UNC4())] )
    color( "silver", 0.5 )
    uncNutHexagonal( UNC4(), $fn=100 );
translate([100,0]) {
    color( "gold" )
        uncBoltAllen( UNC9_16(), $fn=100 );
    color( "silver", 0.5 )
        uncNutSquare( UNC9_16(), $fn=100 );
}

echo( "uncGuessInch(   1/8   ): expected 'UNC #5': ",  screwGetName(uncGuessInch(1/8)) ) ;
echo( "uncGuessInch(  -1/8   ): expected 'UNC #5': ",  screwGetName(uncGuessInch(-1/8)) ) ;
echo( "uncGuessInch(  -0.080 ): expected 'UNC #1': ",  screwGetName(uncGuessInch(-0.080)) ) ;
echo( "uncGuessInch(   0.080 ): expected 'UNC #2': ",  screwGetName(uncGuessInch(0.080)) ) ;
echo( "uncGuessInch(   0     ): expected 'UNC #1': ",  screwGetName(uncGuessInch(0)) ) ;
echo( "uncGuessInch( 100     ): expected undef:",      screwGetName(uncGuessInch(100)) ) ;
echo( "uncGuessInch(-100     ): expected 'UNC 4':",    screwGetName(uncGuessInch(-100)) ) ;

