thickness = 1.6; //thickness of case, too thin and case will be weak
top_thickness = 1.6; //if using acrylic needs to be larger than acrylic to allow for lip

width = 193.0; //device outer width (x)
depth = 115.0; //device outer depth (y)
extra_play = 1.6; //amount of extra space to allow for sizing uncertanty

//distance from edge to closest protruding control surface
inset_left = 4.0;
inset_right = 4.0;
inset_bottom = 39.0;
inset_top = 4.0;

case_space_above_face = 11.0;
lip_overhang = 10.0; //amount case overhangs device

case_z_resolution = 1.0; //multiple of z extrusion height recommended
$fn = 30;

device_width = width + extra_play; //add slight amount of play between case and device (2mm?)
device_depth = depth + extra_play; //add slight amount of play between case and device

case_face_inset_left = 4.0 + extra_play/2.0;
case_face_inset_right = 4.0 + extra_play/2.0;
case_face_inset_bottom = 39.0 + extra_play/2.0;
case_face_inset_top = 4.0 + extra_play/2.0;

use_acrylic_top = "false"; // [true,false]
show_acrylic_cutplan = "false"; // [true,false]
acrylic_top_thickness = 4.0;
acrylic_top_lip = 5.0;

object_max_print_width = 120;
number_of_tabs = 2.0;
print_tab_size = 5.0;

do_split_number = -1; // -1 generates whole model

if (use_acrylic_top == "true" && show_acrylic_cutplan == "true") {
    acrylic_cut_plan();
} else {
    if (do_split_number >= 0) {
        split(do_split_number); //split into sections via print sections
    } else {
        decksaver(); //full model
    }
}
 
module acrylic_cut_plan() {
   square([device_width - case_face_inset_left - case_face_inset_right,
    device_depth - case_face_inset_bottom - case_face_inset_top]);
}

function isOdd(x) = (x % 2) == 1;
//-------------------
//split model into tabbed objects
module split(split_number) {
    used_bed_size_x = object_max_print_width - print_tab_size;
    used_bed_size_y = 2 * device_depth;
    
    full_height = case_space_above_face + lip_overhang + 2*thickness + case_z_resolution; 
  
    tab_layers = number_of_tabs + 2; //number of layers that make up the tabbed objects
    for (i = [split_number: split_number]) {
        intersection(){
            union() {
                if (do_split_number == 0) {
                    //don't indent the left side of first section
                    cube([2*print_tab_size, used_bed_size_y, full_height]);
                }
                if (used_bed_size_x * i >= (device_width + 2*thickness)) {
                    //don't indent the right side of last section
                    translate([used_bed_size_x * i - print_tab_size - 0.1, 0, 0]) 
                        cube([2*print_tab_size, used_bed_size_y, full_height]);
                }
                //offset sections
                for(j = [0:tab_layers-1]) {
                    if (!isOdd(j)) {
                        translate([used_bed_size_x * i, 0, j * full_height/tab_layers]) 
                            cube([used_bed_size_x, used_bed_size_y, full_height/tab_layers]);
                    } else {
                        translate([used_bed_size_x * i - print_tab_size, 0, j * full_height/tab_layers]) 
                            cube([used_bed_size_x, used_bed_size_y, full_height/tab_layers]);
                    }
                }
            }
          translate([thickness+0.01,thickness+0.01,lip_overhang+0.01]) decksaver();
        }
    }
}

module decksaver() {
    union() {
        overhang();
        difference() {
            top_outer_shell();
            top_shell_empty_space();
            if (use_acrylic_top == "true") {
               translate([case_face_inset_left, case_face_inset_bottom,
                case_space_above_face + top_thickness - acrylic_top_thickness + case_z_resolution + 0.01])      acrylic_cutout();       
            }
        }
    }
}

module acrylic_cutout() {
    union() {
        //lip cuout
        translate([0,0,top_thickness - acrylic_top_thickness]) 
            cube([device_width - case_face_inset_left - case_face_inset_right,
                device_depth - case_face_inset_bottom - case_face_inset_top,
                top_thickness]);
        
        //acrylic cuout    
        translate([acrylic_top_lip, acrylic_top_lip, -top_thickness]) 
            cube([device_width - case_face_inset_left - case_face_inset_right - 2 * acrylic_top_lip,
                device_depth - case_face_inset_bottom - case_face_inset_top - 2 * acrylic_top_lip,
                top_thickness*3]);
    }
}

module overhang() {
    translate([0,0,-lip_overhang])
        linear_extrude(height = lip_overhang + 0.01, center = false, convexity = 10, twist = 0) {
            difference() {
                minkowski() {
                    square([device_width,device_depth]);
                    circle(thickness);
                }
                square([device_width,device_depth]);
            }
        }
}


//top outer shell
module top_outer_shell() {
step = case_z_resolution;
    union() {
        
       //lowest piece of the top deck 
       linear_extrude(height = top_thickness, center = false, convexity = 10, twist = 0) 
        minkowski() {
            polygon([[0,0], [0,device_depth], [device_width,device_depth],[device_width,0]]);
            circle(thickness);
        }
       
        
        //remaining piece above top deck
        maxheight = case_space_above_face + top_thickness;
        for (i = [0 : step : maxheight]) {
            ival = i * 0.85; //reduce grade to eliminate need for corner supports
            let (min_x = min(ival,case_face_inset_left), 
                min_y = min(ival,case_face_inset_bottom), 
                max_x = max(device_width - ival, device_width - case_face_inset_right), 
                max_y = max(device_depth - ival, device_depth - case_face_inset_top)) {
                translate([0,0,i]) {
                    linear_extrude(height = step+0.01, center = false, convexity = 10, twist = 0) 
                     minkowski() {
                        polygon([[min_x,min_y], [min_x,max_y], [max_x,max_y],[max_x,min_y]]);
                        circle(thickness);
                    }
                }        
            }
        }
    }
}

module top_shell_empty_space() {
    translate([case_face_inset_left, case_face_inset_bottom, -0.01])
        cube([device_width - case_face_inset_left - case_face_inset_right, 
            device_depth - case_face_inset_bottom - case_face_inset_top, 
            case_space_above_face]);
}