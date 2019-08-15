# agentscad
My utilities for OpenSCAD

# Hexagonal metric screws modelisation

* Panel from M1.6 to M12

![M1.6 to M12](https://github.com/GillesBouissac/agentscad/blob/master/img/M1_6-M12_hexa.png)

* Samples

** The screw

    ```
    use <screw.scad>
    $fn=100;

    screwHexa ( M4() );
    ```

** The screwing hole

    ```
    use <screw.scad>
    $fn=100;
    %screwHexa ( M4() );

    screwHole ( M4() );
    ```

** The screw passage

    ```
    $fn=100;
    color( "silver", 0.5 )
    screwHexa ( M4() );

    color( "yellow", 0.2 )
    screwPassage ( M4() );
    ```

# Hirth Joint

* Panel of all possibilities

![Hirth Joint panel](https://github.com/GillesBouissac/agentscad/blob/master/img/hirthJoint.png)

* Samples

** Sinusoidal profile

    ```
    use <hirthJoint.scad>
    $fn=100;

    // Radius: 10 mm, Nb Tooth: 21, Tooth height: 1 mm
    hirthJointSin( 10, 21, 1 );
    ```

** Triangle profile

    ```
    use <hirthJoint.scad>
    $fn=100;

    // Radius: 20 mm, Nb Tooth: 21, Tooth height: 1 mm, Shoulder: 2
    hirthJointTriangle( 20, 21, 1, 2 );
    ```

** Rectangle profile

    ```
    use <hirthJoint.scad>
    $fn=100;

    // Radius: 20 mm, Nb Tooth: 21, Tooth height: 1 mm, Shoulder: 2, Inlay: 3
    hirthJointRectangle( 20, 21, 1, 2, 3 );
    ```

** Passage for inlay insertion in other parts of your design

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



