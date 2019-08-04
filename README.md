# agentscad
My utilities for OpenSCAD

# Hexagonal metric screws modelisation

* The screw
	```
    use <screw.scad>
    $fn=100;

    screwHexa ( M4() );
	```

![M4 screw](https://github.com/GillesBouissac/agentscad/blob/master/img/M4-screw.png)

* The screwing hole
	```
    use <screw.scad>
    $fn=100;
    %screwHexa ( M4() );

    screwHole ( M4() );
	```

![M4 hole](https://github.com/GillesBouissac/agentscad/blob/master/img/M4-hole.png)

* The screw passage
	```
    $fn=100;
    color( "silver", 0.5 )
    screwHexa ( M4() );

    color( "yellow", 0.2 )
    screwPassage ( M4() );
	```

![M4 passage](https://github.com/GillesBouissac/agentscad/blob/master/img/M4-passage.png)

* Panel from M1.6 to M12

![M1.6 to M12](https://github.com/GillesBouissac/agentscad/blob/master/img/M1_6-M12_hexa.png)






