height = 8.0;
length = 48.0;
width = 22.0;

loop_thickness = 2.4;

round_corners = 1; // rounding corners will significantly slow STL generation, depending on loop thickness and step hight may very slighly decrease total height
rounding_step_height = 0.2; //match with planned print layer height, small values take considerably longer to generate STL
rounding = loop_thickness/3.0;
rounding_height = sin(rounding*80);

translate([0,0,rounding_height]) sizing();

module shape() {
    //width is on x axis, height on y axis
    resize([width, length, 0]) import("path.svg", center = true);
}

module main_loop_2d_shape() {    
    difference() {
        shape();
        offset(-loop_thickness)shape();        
    }
}

module extrude() {
    if (round_corners != 1) {
        //square corners
        linear_extrude(height) main_loop_2d_shape();
    } else {
        //do corner rounding
        main_loop_height = height - (2 * rounding_height);
        
         translate([0,0,main_loop_height-0.001])  //make objects join up at edges
            for (i = [0.0:rounding_step_height:rounding]) {
               linear_extrude(sin(i*80)) 
                    offset(0.0 - i)
                        main_loop_2d_shape();
             }

        translate([0,0,0.001]) //make objects join up at edges
            mirror([0,0,1]) {
                 for (i = [0.0:rounding_step_height:rounding]) {
                   linear_extrude(sin(i*80)) 
                        offset(0.0 - i)
                            main_loop_2d_shape();
                 }
            };

        linear_extrude(main_loop_height) {
                 main_loop_2d_shape();
        };
    }
}

module sizing() {
    extrude();
}