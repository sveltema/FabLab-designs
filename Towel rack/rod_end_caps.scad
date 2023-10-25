pipe_inner_dia = 11.0;
//pipe_outer_dia = 12.7;
pipe_outer_dia = 13.2;

end_piece_cut_size = 1;
end_piece_thickness = 3;
end_piece_edge_length = 5;

$fn = 120;

difference() {
    union() {
        cylinder(end_piece_edge_length * 2, d = pipe_inner_dia, true);
        scale([1,1,1.5])sphere(d=pipe_outer_dia);
    }
    //trim outer dia
    pipe(end_piece_edge_length*2, pipe_outer_dia, pipe_inner_dia, true);
    
    //hollow out
    pipe(end_piece_edge_length*2+0.1, pipe_inner_dia - end_piece_thickness, pipe_inner_dia - end_piece_thickness, false);
    //side cuts
    translate([0,0,end_piece_edge_length+.5]) cube([pipe_outer_dia,end_piece_cut_size,end_piece_edge_length*2+1], true);
    rotate([0,0,90]) translate([0,0,end_piece_edge_length+.5]) cube([pipe_outer_dia,end_piece_cut_size,end_piece_edge_length*2+1], true);
}

module pipe(length, outer_dia, inner_dia, isHollow) {    
        if (isHollow) {
            difference() {
                cylinder(length,d=outer_dia, true);
                translate([0,0,-1]) cylinder(length+2,d=inner_dia, true);
            }
        }  else {
           cylinder(length,d=outer_dia, true);
        }
}