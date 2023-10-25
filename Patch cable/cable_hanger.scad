// Patch Cable Hanger
// by Steven Veltema 2020

// Parameters
number_of_rows = 13;

length_from_wall = 80; //Distance Hanger protrudes from wall

cable_diameter = 5; //Diameter of patch cable wire (add affordance for easy use)
cable_plug_diameter = 11; //Diameter of patch cable plug (add affordance for easy use)
row_thickness = 2.0; //Bottom thickness of hanger row (more = stiffer)

row_end_height = 5.0; //The hight of the turned up row ends
row_end_thickness = 1.2; //The thickness of the row ends

support_width = 2.0; //The width of the row divider/sag supports
support_height = 2.0; //The height of the row divider/sag supports protrudes above rows

back_height = 20; //Height of back for attaching to wall
back_thickness = 3.2; //Thickness of hanger back (attaches to wall)
back_support_ratio = .5; //ratio of back height to support triangle
back_angle = 2.0; //add a back angle for preventing cables from slipping off end

screw_diamater = 3; //Set to 0 to remove holes
screw_head_diameter = 5; //Make slightly larger than screw head to enable easy on/off

single_row_width = cable_plug_diameter + support_width * 2;

hole_distance_from_back = cable_diameter * 3.0;
adjust_edge = 0.001; //adjustment for coincidental faces

$fn = 60;


union() {
    
    hole_modifier_first = ceil(number_of_rows / 4)-1;
    hole_modifier_last = ceil(number_of_rows / 4);
        
    for (i=[0:number_of_rows-1]) {        
        translate([i*(single_row_width-support_width), 0, 0])
            translate([single_row_width/2.0, 0, 0])  {
                row(i==0, i==number_of_rows-1, i==hole_modifier_first|| i==(number_of_rows - hole_modifier_last));
            }
    }
}


module row(is_first, is_last, add_hole) {
    difference() {
    union() {
        difference() {
                //row base
            cube([single_row_width, length_from_wall, row_thickness], true);

                //hole for cable
            translate([0,-(length_from_wall/2.0) + hole_distance_from_back, -row_thickness]) 
                    cylinder(row_thickness*2, d=cable_diameter, true);
            translate([0, hole_distance_from_back, 0]) 
                    cube([cable_diameter, length_from_wall, row_end_height*3.0], true);
            }
            
         
            //finger side supports
            translate([-single_row_width/2.0 + support_width/2.0, 0, 0]) finger_support();
            translate([single_row_width/2.0 - support_width/2.0, 0, 0]) finger_support();
            
            //finger end guard
            translate([-single_row_width/2.0 + support_width/2.0, length_from_wall/2.0, 0]) 
                end_guard(is_first);
            translate([single_row_width/2.0 - support_width/2.0, length_from_wall/2.0, 0]) 
                mirror([1,0,0])end_guard(is_last);
           
             //back
                translate([0, -length_from_wall/2.0 + back_thickness/2.0, 0]) {
                rotate([-back_angle,0,0])  {
                    difference() {
                        translate([0, 0, back_height/2.0 - row_thickness/2.0]) cube([single_row_width, back_thickness, back_height], true);
                        if (add_hole) {
                            //place screw holes
                            translate([0,-back_thickness/2.0-adjust_edge,back_height-1.5*(screw_head_diameter+screw_diamater)]) 
                                screw_hole();
                        }
                    }
               }
             }
             
         } //end union
         
         //clean off bottom
         translate([0, 0, -row_thickness+adjust_edge]) cube([single_row_width, length_from_wall, row_thickness], true);
         //clean off back
         translate([0, -length_from_wall/2.0 - back_thickness/2.0 + adjust_edge, 0]) 
            rotate([-back_angle,0,0]) 
                translate([0, 0, back_height/2.0 - row_thickness/2.0]) 
                    cube([single_row_width, back_thickness, back_height], true);
     }
}

module screw_hole() {
    rotate([-90,180,0]){
        cylinder(back_thickness*2, d=screw_head_diameter);
        hull() {
            translate([0,screw_head_diameter/2.0,0]) cylinder(back_thickness*2, d=screw_diamater);
            translate([0,screw_head_diameter,0]) cylinder(back_thickness*2, d=screw_diamater);
        }
    }
}
module end_guard(add_end) {
    end_width = (single_row_width - cable_diameter)/2.0;
    
    rotate([90,0,0])
        linear_extrude(row_end_thickness)
            resize([end_width-support_width/2.0-adjust_edge, row_end_height, 0])
                intersection() {
                    circle(d=end_width);
                    square(single_row_width);
                }
                
   if (add_end) 
        translate([-support_width/2.0,-row_end_thickness,0]) 
               cube([support_width/2.0,row_end_thickness,row_end_height]);
               
}

module finger_support() {
    //finger side supports
    translate([0, length_from_wall/2.0, row_thickness/2.0]) {        
        rotate([90,0,0]) {
            linear_extrude(length_from_wall - back_thickness + adjust_edge) {
                intersection() {
                    resize([support_width, support_height*2, 0]) circle(r = support_height*1.1);
                    translate([-support_height, 0, 0]) square([support_height*2, support_height]);
                }
            }
        }
    }
    
    triangle_size = back_height*back_support_ratio;
    
    translate([0,-length_from_wall/2.0+support_width,0])
        hull() {
            translate([0,triangle_size*2, row_thickness/2.0]) resize([support_width, support_width,support_height ])sphere(d = support_width);
            rotate([-back_angle,0,0]) translate([0,0, triangle_size]) resize([support_width, support_width,support_height ])sphere(d = support_width);
            translate([0,back_thickness-support_width,row_thickness/2.0]) resize([support_width, support_width,support_height ])sphere(d = support_width);
   }
   
 }


