pipe_inner_dia = 12.5;
pipe_outer_dia = 13.2;
end_piece_edge_length = 5;

$fn = 120;

union() {
    //part sticking out of pipe
    difference() {
        union() {
            scale([1,1,1.5])sphere(d=pipe_outer_dia);
        }
        //trim outer dia
        pipe(end_piece_edge_length*2.1, pipe_outer_dia, pipe_inner_dia, false);
    }

    //holding part inside pipe
    total_length = 7.0;    
    linear_extrude(height = total_length, center = false, twist = 120, scale = 0.8) 
        circle($fn = 6, d = pipe_inner_dia);
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