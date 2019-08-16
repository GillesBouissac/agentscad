# agentscad
My utilities for OpenSCAD

# Metric screws

## Panel from M1.6 to M12

![M1.6 to M12](https://github.com/GillesBouissac/agentscad/blob/master/img/screw-panel.png)

## Examples

<table>
<tr>
<th>Step</th>
<th>Code</th>
<th>Result</th>
</tr>
<tr>
<td>Some walls</td>
<td><pre>
use &lt;screw.scad&gt;
module showcaseWalls( wh1, wh2, ww=200, wp=20 ) {
    translate ( [0,wp/2,0] )  {
        color( "LightSkyBlue" )
        translate ( [0,0,-(wh2+wh1)/2] )
            cube( [ww,wp,wh2], center=true );
        color( "DodgerBlue" )
        translate ( [0,0,0] )
            cube( [ww,wp,wh1], center=true );
    }
}
showcaseWalls (3,10,15);
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-block.png" width="200"/></td>
</tr>
<tr>
<td>Passage</td>
<td><pre>
use &lt;screw.scad&gt;
$fn=100;
module showcaseWalls( wh1, wh2, ww=200, wp=20 ) {
   ...
}
screw = M3(10);
difference() {
    showcaseWalls (3,10,15);
    screwPassage  (screw,3);
}
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-passage.png" width="200"/></td>
</tr>
<tr>
<td>Allen</td>
<td><pre>
#screwAllen  (screw);
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-in-place.png" width="200"/></td>
</tr>
<tr>
<td>Hexagonal</td>
<td><pre>
#screwHexagonal  (screw);
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-in-place-hexa.png" width="200"/></td>
</tr>
<tr>
<td>Tight passage<br>allen</td>
<td><pre>
...
screw = M3(10);
difference() {
    showcaseWalls (3,10,15);
    screwAllenPassage  (screw,3);
}
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-tight-allen.png" width="200"/></td>
</tr>
<tr>
<td>Tight passage<br>hexagonal</td>
<td><pre>
...
screw = M3(10);
difference() {
    showcaseWalls (3,10,15);
    screwHexagonalPassage  (screw,3);
}
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-tight-hexa.png" width="200"/></td>
</tr>
</table>

# Hirth Joint

## Panel

![Hirth Joint panel](https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJoint.png)

## Examples

<table>
<tr>
<th>Step</th>
<th>Code</th>
<th>Result</th>
</tr>
<tr>
<td>Sinusoidal</td>
<td><pre>
use &lt;hirthJoint.scad&gt;
$fn=100;
// Sinusoidal profile
//   Radius:       10 mm
//   Nb tooth:     21
//   Tooth height: 1.2 mm
hirthJointSinus( 10, 21, 1.2 );
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJointSinus.png" width="200"/></td>
</tr>
<tr>
<td>Shoulder</td>
<td><pre>
use &lt;hirthJoint.scad&gt;
$fn=100;
// Sinusoidal profile with shoulder
//   Radius:          10 mm
//   Nb tooth:        21
//   Tooth height:    1.2 mm
//   Shoulder height: 2 mm
hirthJointSinus( 10, 21, 1.2, 2 );
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJointShoulder.png" width="200"/></td>
</tr>
<tr>
<td>Inlay</td>
<td><pre>
use &lt;hirthJoint.scad&gt;
$fn=100;
// Sinusoidal profile with shoulder and inlay
//   Radius:          10 mm
//   Nb tooth:        21
//   Tooth height:    1.2 mm
//   Shoulder height: 2 mm
//   Inlay height:    1 mm
hirthJointSinus( 10, 21, 1.2, 2, 1 );
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJointInlay.png" width="200"/></td>
</tr>
<tr>
<td>Triangle</td>
<td><pre>
use &lt;hirthJoint.scad&gt;
$fn=100;
// Triangle profile
//   Radius:          10 mm
//   Nb tooth:        21
//   Tooth height:    1.2 mm
//   Shoulder height: 1 mm
//   Inlay height:    1 mm
hirthJointTriangle( 10, 21, 1.2, 1, 1 );
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJointTriangle.png" width="200"/></td>
</tr>
<tr>
<td>Rectangle</td>
<td><pre>
use &lt;hirthJoint.scad&gt;
$fn=100;
// Rectangle profile
//   Radius:          10 mm
//   Nb tooth:        21
//   Tooth height:    1.2 mm
//   Shoulder height: 1 mm
//   Inlay height:    1 mm
hirthJointRectangle( 10, 21, 1.2, 1, 1 );
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJointRectangle.png" width="200"/></td>
</tr>
<tr>
<td>Passage</td>
<td><pre>
use &lt;hirthJoint.scad&gt;
$fn=100;
// Inlay passage
//   Radius:          10 mm
//   Inlay height:    1 mm
difference() {
    translate( [0,0,-2] )
        cylinder( r=15, h=4, center=true );
    hirthJointPassage( 10, 1 );
}
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJointPassage.png" width="200"/></td>
</tr>
</table>

