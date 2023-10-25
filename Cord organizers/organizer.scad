ring_difference = 4.0;
outer_radius = 28.0; //medium 28 ,small 22
inner_radius = outer_radius - ring_difference;
loop_width = 8.0;

bite_radius = outer_radius / 1.8;
bite_center_radius = bite_radius -ring_difference;

scale_factor = 0.5;

$fn = 60;

extrude();

module extrude() {
union() {
    translate([0,0,loop_width-0.001])  //make objects join up at edges
    for (i = [0.0:0.1:1.3]) {
       linear_extrude(sin(i*80)) 
            offset(0.0 - i)
                combined();
     }

    translate([0,0,0.001]) //make objects join up at edges
    mirror([0,0,1]) {
    for (i = [0.0:0.1:1.3]) {
      linear_extrude(sin(i*80)) 
            offset(0.0 - i) 
                combined();
            
        }
    };

    linear_extrude(loop_width) {
             combined();
    };
    
}
}


module combined() {
        
    difference () {
        union() {
           scale([1, scale_factor, 1])  difference() {
                ring(outer_radius, inner_radius);
                translate([0, inner_radius, 0]) circle(r=bite_radius);
                translate([0, -inner_radius, 0]) circle(r=bite_radius);
            }
            scale([1, scale_factor, 1]) translate([0, inner_radius, 0]) bite(bite_radius, bite_center_radius);           
            scale([1, scale_factor, 1]) translate([0, -inner_radius, 0]) bite(bite_radius, bite_center_radius);
        }
                
       //outer cleanup
        scale([1, scale_factor, 1]) difference() {
            circle(r=outer_radius * 2);
            circle(r=outer_radius);
       }
       
       //cut sharp corners
       scale([1, scale_factor, 1]) translate([0,inner_radius+inner_radius - ring_difference, 0]) circle(r= inner_radius);           
       scale([1, scale_factor, 1]) translate([0,-inner_radius-inner_radius + ring_difference, 0]) circle(r= inner_radius);           
    }
}

module ring(outer, inner) {
    difference() {
        circle(r=outer);
        circle(r=inner);
    }
 }

module bite(outer, inner) {
       difference() {
             circle(r=outer);
             circle(r=inner);
    }
}


module outset(d=1) {
	// Bug workaround for older OpenSCAD versions
	if (version_num() < 20130424) render() outset_extruded(d) child();
	else minkowski() {
		circle(r=d);
		child();
	}
}

module outset_extruded(d=1) {
   projection(cut=true) minkowski() {
        cylinder(r=d);
        linear_extrude(center=true) child();
   }
}

module inset(d=1) {
	 render() inverse() outset(d=d) inverse() child();
}

module fillet(r=1) {
	inset(d=r) render() outset(d=r) child();
}

module rounding(r=1) {
	outset(d=r) inset(d=r) child();
}

module shell(d,center=false) {
	if (center && d > 0) {
		difference() {
			outset(d=d/2) child();
			inset(d=d/2) child();
		}
	}
	if (!center && d > 0) {
		difference() {
			outset(d=d) child();
			child();
		}
	}
	if (!center && d < 0) {
		difference() {
			child();
			inset(d=-d) child();
		}
	}
	if (d == 0) child();
}


// Below are for internal use only

module inverse() {
	difference() {
		square(1e5,center=true);
		child();
	}
}

