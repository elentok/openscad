$fn=50;

use <rounded.scad>

module grip(grip_depth, object_width, object_height, thingy_depth = 30, bottom_wall_width = 3, wall_width = 2) {
    union() {
        // Horizontal Left
        translate([0, -thingy_depth/2 - object_width/2, bottom_wall_width/2])
        grip_thingy(width = grip_depth, depth = thingy_depth, height = bottom_wall_width);
      
        // Horizontal Right
        translate([0, thingy_depth/2 + object_width/2, bottom_wall_width/2])
        rotate([0,0,180])
        grip_thingy(width = grip_depth, depth = thingy_depth, height = bottom_wall_width);
        
        // Vertical Left
        translate([0, -wall_width/2 - object_width/2, object_height/2 + wall_width/2])
        rotate([90, 180, 0])
        centered_rounded_edge(width = grip_depth, depth = object_height + wall_width, height = wall_width, radius = 1.5);
        
        // Vertical right
        translate([0, wall_width/2 + object_width/2, object_height/2 + wall_width/2])
        rotate([-90, 0, 0])
        centered_rounded_edge(width = grip_depth, depth = object_height + wall_width, height = wall_width, radius = 1.5);
        
        // Bar
        translate([0, 0, wall_width/2 + object_height])
        cube([grip_depth, object_width, wall_width], center=true);
    }
}

// The part that touches the table (where the screw goes)
module grip_thingy(width, depth, height, screw_hole_diameter = 4, radius = 1.5) {
    $cone_height = 2;
    difference() {
      centered_rounded_edge(width, depth, height, radius);
      chamfered_hole(height + 0.1, screw_hole_diameter, screw_hole_diameter + 3);
    }
}

module chamfered_hole(height, hole_diameter, chamfer_diameter) {
    $chamfer_height = (chamfer_diameter - hole_diameter) / 2;
    $cylinder_height = height - $chamfer_height;
    
    translate([0, 0, -height/2])
    union() {
      // Add 0.1 to make sure the union with the chamfer is perfect
      cylinder(h = $cylinder_height + 0.1, d = hole_diameter);
    
      translate([0, 0, $cylinder_height])
      cylinder(h = $chamfer_height, d1 = hole_diameter, d2 = chamfer_diameter);
    }  
}

//grip_thingy(width = 15, depth = 30, height = 3);
grip(grip_depth = 15, object_width = 100, object_height = 30);
