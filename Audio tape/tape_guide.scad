/*[ center diamater ]*/
guide_inner_diameter = 10.0;  // [4 : 0.5 : 20]

/*[ additional radius at edges ]*/
guide_lip_overhang = 0.4; // [0 : 0.1 : 3]

/*[ total height ]*/
guide_height = 5.0; // [4 : 0.5 : 10]

/*[ height for tape ]*/
tape_width = 4.0; // [3 : 0.2 : 8]

/*[ non-tapered guide edge height ]*/
guide_edge_height = 0.4; // [0 : 0.1 : 1]

single_taper_height = (guide_height - tape_width) / 2.0;
single_taper_edge_height = single_taper_height + guide_edge_height;

/*[ number of faces (larger = smoother) ]*/
$fn=120; //make is smooth

edge();

cylinder(guide_height, d=guide_inner_diameter);

translate([0,0,guide_height]) mirror([0,0,1]) edge();

module edge() {   
    guide_edge_diameter = guide_inner_diameter + (2 * guide_lip_overhang);
    
    cylinder(guide_edge_height, d=guide_edge_diameter);
    translate([0,0,guide_edge_height-0.01]) 
        cylinder(single_taper_height, d1=guide_edge_diameter, d2=guide_inner_diameter);
}