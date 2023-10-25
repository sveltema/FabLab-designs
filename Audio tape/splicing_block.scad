/*[ Overall Dimensions in mm]*/
block_x = 100; // [50 : 10 : 200]
block_y = 30; // [10 : 5 : 100]
block_z = 10; // [5 : 1 : 20]

/*[ Tape Channel in mm ]*/
tape_channel_depth = 2.0;  // [1 : 1 : 5]
tape_channel_width = 3.81; // [3.81:Cassette 1/8 inch, 6.35:Reel-to-reel 1/4 inch]

/*[ Blade width in mm ]*/
cut_width = 0.2; // [0.1 : 0.1 : 1]


block();

module block() {
    $fn = 30;
    
    difference(){
        cube([block_x, block_y, block_z], true);
        
        translate([0,0,block_z/2.0 - tape_channel_depth/2.0]) channel();
        
        //rotate and place (z translation is already handled)
        translate([-block_x/4.0 ,0,0]) cut();
        translate([0 ,0,0]) rotate([0,0,22.5] )cut();
        translate([block_x/4.0 ,0,0]) rotate([0,0,45])cut();
    }
}

module channel() {
    channel_x = block_x * 1.1;
    union() {
        //the channel
        cube([channel_x, tape_channel_width, tape_channel_depth+.01], true);
        //angled edges
        rotate([45,0,0]) translate([0,0,tape_channel_depth])
            cube([channel_x, 1.5, tape_channel_depth], true);
        rotate([-45,0,0]) translate([0,0,tape_channel_depth])
            cube([channel_x, 1.5, tape_channel_depth], true);
    }
}

module cut() {
    cut_y = block_y * 3;
    cut_z = tape_channel_depth * 1.5;
    
    tans_z = block_z /2.0 - cut_z;
   
    union() {
        //the actual thin cut channel
        translate([0,0,tans_z]) cube([cut_width, cut_y, cut_z], true);
        //the cut champfer
        scale([1,cut_y/(cut_width/2.0),1])
            hull() {
                translate([cut_width*2.0, 0, block_z /2.0]) sphere(d=cut_width/1.5, true);
                translate([-cut_width*2.0, 0,block_z /2.0]) sphere(d=cut_width/1.5, true);
                translate([0,0,tans_z]) sphere(d=cut_width, true);
            }
    }
}