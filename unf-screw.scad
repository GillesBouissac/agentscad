/*
 * Copyright (c) 2019, Gilles Bouissac
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 3D printable UNF screws taking into account printer precision
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
module unfBoltPassage( p=UNF1_4() ) { libBoltPassage(p); }

// Nut passage loose on head to fit any type of nut
module unfNutPassage( p=UNF1_4() ) { libNutPassage(p); }

// Hexagonal nut passage
module unfNutHexagonalPassage( p=UNF1_4() ) { libNutHexagonalPassage(p); }

// Hexagonal nut passage
module unfNutSquarePassage( p=UNF1_4() ) { libNutSquarePassage(p); }

// Bolt passage Tight on head for Allen head
module unfBoltAllenPassage( p=UNF1_4() ) { libBoltAllenPassage(p); }

// Bolt passage Tight on head for Hexagonal head
module unfBoltHexagonalPassage( p=UNF1_4() ) { libBoltHexagonalPassage(p); }

// Bolt with Allen head
module unfBoltAllen( p=UNF1_4(), bt=true ) { libBoltAllen(p,bt); }

// Bolt with Hexagonal head
module unfBoltHexagonal( p=UNF1_4(), bt=true, bb=true ) { libBoltHexagonal(p,bt,bb); }

// Hexagonal nut
module unfNutHexagonal( p=UNF1_4(), bt=true, bb=true ) { libNutHexagonal(p,bt,bb); }

// Square nut
module unfNutSquare( p=UNF1_4(), bt=true, bb=true ) { libNutSquare(p,bt,bb); }



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
function UNF_N0  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(0 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N1  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(1 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N2  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(2 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N3  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(3 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N4  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(4 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N5  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(5 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N6  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(6 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(7 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N10 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(8 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF_N12 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(9 ,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1_4  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(10,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF5_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(11,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF3_8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(12,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF7_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(13,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1_2  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(14,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF9_16 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(15,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF5_8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(16,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF3_4  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(17,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF7_8  (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(18,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1    (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef)  = unfData(19,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1_1_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = unfData(20,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1_1_4 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = unfData(21,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1_3_8 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = unfData(22,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);
function UNF1_1_2 (tl=undef,tlp=undef,ahl=undef,hhl=undef,hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) = unfData(23,tl,tlp,ahl,hhl,hlp,tdp,ahd,hhd,hdp);


// Guess what is the better standard thread from the given one
//   if td>0: will pick the first screw larger than the given value
//   if td<0: will pick the first screw smaller than the given value
//
// Dimensions must be given in mm, use unfGuessInch for inch dimensions
//
function unfGuess ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( UNFDATA,td=td,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of unfGuess
function unfGuessInch ( td, tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwGuess( UNFDATA,td=inch2mm(td),tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

// Clones a screw allowing to overrides some characteristics
//
// Dimensions must be given in mm, use unfCloneInch for inch dimensions
// Both gives same result if only p is provided
//
function unfClone (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( UNFDATA,p=p,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp);

// Inch version of unfClone
function unfCloneInch (p,tl=undef,tlp=undef, ahl=undef, hhl=undef, hlp=undef,tdp=undef,ahd=undef,hhd=undef,hdp=undef) =
    screwClone( UNFDATA,p=p,tl=inch2mm(tl),tlp=inch2mm(tlp),ahl=inch2mm(ahl),hhl=inch2mm(hhl),hlp=inch2mm(hlp),tdp=inch2mm(tdp),ahd=inch2mm(ahd),hhd=inch2mm(hhd),hdp=inch2mm(hdp));

function unfGetDataLength() = len(UNFDATA);
//
// Dimensions must be given in mm
//
function unfData( idx, tl=undef, tlp=undef, ahl=undef, hhl=undef, hlp=undef, tdp=undef, ahd=undef, hhd=undef, hdp=undef ) = 
    libScrewDataCompletion( UNFDATA,idx,n=undef,p=undef,tl=tl,tlp=tlp,ahl=ahl,hhl=hhl,hlp=hlp,tdp=tdp,ahd=ahd,hhd=hhd,hdp=hdp)
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
//   https://www.westfieldfasteners.co.uk/A2_ScrewBolt_HexHd_UNFoarse0.5000_THRpart.html
//   https://www.westfieldfasteners.co.uk/UNF.html
//
// WARNING: For reading convenience and comparison to standards, dimensions are given in inch.
//          They are converted to mm because the library units are millimeters
//   PITCH: UNF (Unified National Coarse) pitch value
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
UNFDATA_INCH = [
// idx=0
  [ "UNF #0"    ,   1/80 , 0.060 ,   1/4 , undef , undef , 0.096 , 0.060 , undef , undef , undef ],
  [ "UNF #1"    ,   1/72 , 0.073 ,   1/4 , undef , undef , 0.118 , 0.073 ,  1/16 , undef , undef ],
  [ "UNF #2"    ,   1/64 , 0.086 ,   1/4 , undef , undef , 0.140 , 0.086 ,  5/64 , undef , undef ],
  [ "UNF #3"    ,   1/56 , 0.099 ,   1/4 , undef , undef , 0.161 , 0.099 ,  5/64 , undef , undef ],
  [ "UNF #4"    ,   1/48 , 0.112 ,   1/4 , undef , undef , 0.183 , 0.112 ,  3/32 , undef , undef ],
  [ "UNF #5"    ,   1/44 ,  1/8  ,  5/16 , undef , undef , 0.205 ,  1/8  ,  3/32 , undef , undef ],
  [ "UNF #6"    ,   1/40 , 0.138 ,  5/16 , undef , undef , 0.226 , 0.138 ,  7/64 , undef , undef ],
  [ "UNF #8"    ,   1/36 , 0.164 ,  5/16 , undef , undef , 0.270 , 0.164 ,  9/64 , undef , undef ],
  [ "UNF #10"   ,   1/32 , 0.190 ,   3/8 , undef , undef , 0.312 , 0.190 ,  5/32 , undef , undef ],
  [ "UNF #12"   ,   1/28 ,  7/32 ,   3/8 , undef , undef , 0.343 ,  7/32 ,  5/32 , undef , undef ],
// idx=10
  [ "UNF 1/4"   ,   1/28 ,  1/4  ,   3/8 , undef , undef , 0.375 ,  1/4  ,  3/16 , 0.188 ,  7/16 ],
  [ "UNF 5/16"  ,   1/24 ,  5/16 ,   1/2 , undef , undef , 0.469 ,  5/16 ,  1/4  , 0.235 ,  1/2  ],
  [ "UNF 3/8"   ,   1/24 ,  3/8  ,   1/2 , undef , undef ,  9/16 ,  3/8  ,  5/16 , 0.268 ,  9/16 ],
  [ "UNF 7/16"  ,   1/20 ,  7/16 ,   3/4 , undef , undef ,  5/8  ,  7/16 ,  3/8  , 0.316 ,  5/8  ],
  [ "UNF 1/2"   ,   1/20 ,  1/2  ,   3/4 , undef , undef ,  3/4  ,  1/2  ,  3/8  , 0.364 ,  3/4  ],
  [ "UNF 9/16"  ,   1/18 ,  9/16 ,   1   , undef , undef ,  7/8  ,  9/16 ,  7/16 , 0.394 ,  7/8  ],
  [ "UNF 5/8"   ,   1/18 ,  5/8  ,   1   , undef , undef , 15/16 ,  5/8  ,  1/2  , 0.444 , 15/16 ],
  [ "UNF 3/4"   ,   1/16 ,  3/4  ,   5/4 , undef , undef ,  9/8  ,  3/4  ,  5/8  , 0.524 ,  9/8  ],
  [ "UNF 7/8"   ,   1/14 ,  7/8  ,   5/4 , undef , undef , 21/16 ,  7/8  ,  3/4  , 0.604 , 21/16 ],
  [ "UNF 1"     ,   1/12 ,  1    ,   3/2 , undef , undef ,  3/2  ,  1    ,  3/4  , 0.700 ,  3/2  ],
// idx=20
  [ "UNF 1 1/8" ,   1/12 ,  9/8  ,   3/2 , undef , undef , 27/16 ,  9/8  ,  7/8  , 0.780 , 27/16 ],
  [ "UNF 1 1/4" ,   1/12 ,  5/4  ,   2   , undef , undef , 15/8  ,  5/4  ,  1    , 0.876 , 15/8  ],
  [ "UNF 1 3/8" ,   1/12 , 11/8  ,   2   , undef , undef , 33/16 , 11/8  ,  9/8  , 0.940 , 33/16 ],
  [ "UNF 1 1/2" ,   1/12 ,  3/2  ,   5/2 , undef , undef ,  9/4  ,  3/2  ,  5/4  , 1.036 ,  9/4  ]
];
UNFDATA = [ for ( d=UNFDATA_INCH ) inch2mm(d) ];

// ----------------------------------------
//
//                  Showcase
//
// ----------------------------------------
unfBoltHexagonal( UNF1_1_2(), $fn=100 );
translate([0,0,+screwGetThreadL(UNF1_1_2())] )
    color( "silver", 0.5 )
    unfNutHexagonal( UNF1_1_2(), $fn=100 );
translate([100,0]) {
    color( "gold" )
        unfBoltAllen( UNF9_16(), $fn=100 );
    color( "silver", 0.5 )
        unfNutSquare( UNF9_16(), $fn=100 );
}

echo( "unfGuessInch(   1/8   ): expected 'UNF #5': ",  screwGetName(unfGuessInch(1/8)) ) ;
echo( "unfGuessInch(  -1/8   ): expected 'UNF #5': ",  screwGetName(unfGuessInch(-1/8)) ) ;
echo( "unfGuessInch(  -0.080 ): expected 'UNF #1': ",  screwGetName(unfGuessInch(-0.080)) ) ;
echo( "unfGuessInch(   0.080 ): expected 'UNF #2': ",  screwGetName(unfGuessInch(0.080)) ) ;
echo( "unfGuessInch(   0     ): expected 'UNF #1': ",  screwGetName(unfGuessInch(0)) ) ;
echo( "unfGuessInch( 100     ): expected undef:",      screwGetName(unfGuessInch(100)) ) ;
echo( "unfGuessInch(-100     ): expected 'UNF 4':",    screwGetName(unfGuessInch(-100)) ) ;

