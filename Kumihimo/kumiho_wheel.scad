
diameter = 100;
center_diameter = 30;
slot_width = 1.5;
slot_top_diameter = 5;
slots = 32;
slot_depth = 10;

$fn = 30;

difference() {
    # circle(d = diameter);

    circle(d = center_diameter);

    step = 360/slots;
    for(i = [0:step:360]) {
        rotate([0,0,i]) slot();
    }
}

projection(cut = true);

 module slot() {
     translate([diameter/2.0,0,0]) {
        polygon([[0,2*slot_width], [0,-slot_width*2],[-slot_depth/2, 0]]);
        circle(d = slot_top_diameter);
        translate([-slot_depth, -slot_width/2.0, 0]) square([slot_depth,slot_width]);
     }
 }
