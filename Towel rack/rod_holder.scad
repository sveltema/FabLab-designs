height = 40;

screw_hole_dia = 3;
screw_head_dia = 4;
screw_head_spacing = screw_head_dia + 2;
screw_head_depth = 2;

pipe_inner_dia = 12;
pipe_outer_dia = 12.8;
pipe_length = 350;

pipe_separation_degrees = 3;
pipe_center_offset = 10;
pipe_support_thickness = 3;
pipe_angle = 1;

base_width = 55;
base_plate_thickness = 5;
base_plate_width = base_width;
base_plate_depth = (pipe_center_offset*2.5)+(screw_head_spacing*4);

pipe_starting_position = -(base_plate_width/2.0);


$fn = 120;

union() {
    face_off = max(height, base_plate_width);
    difference() {
        //make faces square
        centerSupport();
       translate([-pipe_starting_position - base_width/2.0 + pipe_starting_position - face_off/2, 0, 0]) 
            cube([face_off, face_off, face_off*2], true);
        translate([pipe_starting_position + base_width/2.0 - pipe_starting_position + face_off/2, 0, 0]) 
            cube([face_off, face_off, face_off*2], true);
    }
    basePlate();
    difference() {
        //make faces square
        pipeHolders();
       translate([-pipe_starting_position - base_width/2.0 + pipe_starting_position - face_off/2, 0, 0]) 
            cube([face_off, face_off, face_off*2], true);
        translate([pipe_starting_position + base_width/2.0 - pipe_starting_position + face_off/2, 0, 0]) 
            cube([face_off, face_off, face_off*2], true);
    }
//    actualPipes();
}

module centerSupport() {
    difference() {
            translate([0, 0, height/2.0 - pipe_outer_dia/2 - pipe_support_thickness]) 
                cube([base_width,(pipe_center_offset*2.5),height-2], true);
        
        actualPipes();
    }
}

module basePlate() {
    translate([0, 0, height - (pipe_outer_dia - pipe_support_thickness) ]) {
      hole_length = base_plate_thickness + 0.5;
     
        //slopes
     difference() {   
    translate([0, 0, -base_plate_thickness]) cube([base_width,(pipe_center_offset*2.5)+5, base_plate_thickness*2], true);
         
    translate([-(base_width/2.0)-1, -pipe_center_offset*2.3, -base_plate_thickness*2]) rotate([0,90,0]) cylinder(base_width+2, r=pipe_center_offset+1, true);    
    translate([-(base_width/2.0)-1, pipe_center_offset*2.3, -base_plate_thickness*2]) rotate([0,90,0]) cylinder(base_width+2, r=pipe_center_offset+1, true);    
     }


      difference() {
        //plate
        translate([0, 0, 0]) cube([base_plate_width, base_plate_depth, base_plate_thickness], true);
           
        //screw_holes
        translate([base_width/2.0 - screw_head_spacing, pipe_center_offset*2.5/2.0 + screw_head_spacing, -hole_length/2.0] ) cylinder(hole_length, d = screw_hole_dia, true);
        translate([base_width/2.0 - screw_head_spacing, -1 * (pipe_center_offset*2.5/2.0 + screw_head_spacing), -hole_length/2.0] ) cylinder(hole_length, d = screw_hole_dia, true);
        translate([-base_width/2.0 + screw_head_spacing, pipe_center_offset*2.5/2.0 + screw_head_spacing, -hole_length/2.0] ) cylinder(hole_length, d = screw_hole_dia, true);
        translate([-base_width/2.0 + screw_head_spacing, -1 * (pipe_center_offset*2.5/2.0 + screw_head_spacing), -hole_length/2.0] ) cylinder(hole_length, d = screw_hole_dia, true);
          
        //screw_head
        translate([base_width/2.0 - screw_head_spacing, pipe_center_offset*2.5/2.0 + screw_head_spacing, -hole_length/2.0] ) cylinder(screw_head_depth, d1 = screw_head_dia, d2 = screw_hole_dia, true);
        translate([base_width/2.0 - screw_head_spacing, -1 * (pipe_center_offset*2.5/2.0 + screw_head_spacing), -hole_length/2.0] ) cylinder(screw_head_depth, d1 = screw_head_dia, d2=screw_hole_dia, true);
        translate([-base_width/2.0 + screw_head_spacing, pipe_center_offset*2.5/2.0 + screw_head_spacing, -hole_length/2.0] ) cylinder(screw_head_depth, d1 = screw_head_dia, d2 = screw_hole_dia, true);
        translate([-base_width/2.0 + screw_head_spacing, -1 * (pipe_center_offset*2.5/2.0 + screw_head_spacing), -hole_length/2.0] ) cylinder(screw_head_depth, d1 = screw_head_dia, d2 = screw_hole_dia, true);
      }
    }    
}

module roundcuts_square(d,h,r) {
    intersection() {
        square([d,h], center=true);
        circle(sqrt(d*h + (d-r)*(h-r))/2);
    }
}

//pipe_holder (hollow)
module pipeHolders() {    
  translate([0, pipe_center_offset, 0]) 
    rotate([0,0,pipe_separation_degrees]) 
        translate([pipe_starting_position, 0, 0]) 
            pipe(base_width/2.0 - pipe_starting_position + 10, pipe_outer_dia+(pipe_support_thickness*2), pipe_outer_dia, true);

  translate([0, -pipe_center_offset, 0]) 
    rotate([0,0,-pipe_separation_degrees]) 
        translate([pipe_starting_position, 0, 0]) 
            pipe(base_width/2.0 -pipe_starting_position  + 10, pipe_outer_dia+(pipe_support_thickness*2), pipe_outer_dia, true);
}

module actualPipes() {
    translate([0, pipe_center_offset, 0]) rotate([0,0,pipe_separation_degrees]) translate([pipe_starting_position, 0, 0]) pipe(pipe_length, pipe_outer_dia, 0, false);
    translate([0, -pipe_center_offset, 0]) rotate([0,0,-pipe_separation_degrees]) translate([pipe_starting_position, 0, 0]) pipe(pipe_length, pipe_outer_dia, 0, false);
}

module pipe(length, outer_dia, inner_dia, isHollow) {    
    rotate([0,90+pipe_angle,0]) {
        if (isHollow) {
            difference() {
                cylinder(length,d=outer_dia, true);
                translate([0,0,pipe_support_thickness]) cylinder(length,d=inner_dia, true);
            }
        }  else {
           cylinder(length,d=outer_dia, true);
        }
    }
}