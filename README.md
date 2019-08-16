# agentscad
My utilities for OpenSCAD

# Hexagonal metric screws modelisation

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
<td>The walls</td>
<td><pre>
use <screw.scad>
module showcaseBlocks( wh1, wh2, ww=200, wp=20 ) {
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
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-block.png" width="100"/></td>
</tr>

<tr>
<td>Then the screw passage</td>
<td><pre>
$fn=100;
screw = M3(10);
difference() {
    showcaseWalls (3,10,15);
    screwPassage  (screw,3);
}
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-passage.png" width="100"/></td>
</tr>

<tr>
<td>Finaly the screw just for fun</td>
<td><pre>
#screwAllen  (screw,$fn=100);
</pre></td>
<td><img src="https://github.com/GillesBouissac/agentscad/blob/master/img/screw-in-place.png" width="100"/></td>
</tr>

</table>

# Hirth Joint

## Panel of all possibilities

![Hirth Joint panel](https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJoint.png)

## Examples

* Sinusoidal profile

    ```
    use <hirthJoint.scad>
    $fn=100;

    // Radius: 10 mm, Nb Tooth: 21, Tooth height: 1 mm
    hirthJointSinus( 10, 21, 1 );
    ```

* Triangle profile

    ```
    use <hirthJoint.scad>
    $fn=100;

    // Radius: 20 mm, Nb Tooth: 21, Tooth height: 1 mm, Shoulder: 2
    hirthJointTriangle( 20, 21, 1, 2 );
    ```

* Rectangle profile

    ```
    use <hirthJoint.scad>
    $fn=100;

    // Radius: 20 mm, Nb Tooth: 21, Tooth height: 1 mm, Shoulder: 2, Inlay: 3
    hirthJointRectangle( 20, 21, 1, 2, 3 );
    ```

* Passage for inlay insertion in other parts of your design

    ```
    use <hirthJoint.scad>
    $fn=100;

    RADIUS = 20;
    INLAY = 2;
    difference() {
        // The part that will receive the inlay
        translate( [0,0,-INLAY] )
            cylinder( r=2*RADIUS, h=2*INLAY, center=true );
        // Inlay passage with little margin
        #hirthJointPassage( RADIUS, INLAY );
    }
    ```



