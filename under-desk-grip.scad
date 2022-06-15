$fn=50;

use <rounded.scad>

module grip(grip_depth, object_width, object_height, bottom_wall_width = 3, wall_width = 2) {
    $thingy_depth = 30;
    rounded_edge(width = grip_depth, depth = $thingy_depth, height = bottom_wall_width, radius = 1.5);
  
    translate([0, 2 * $thingy_depth + object_width, 0])
    mirror([0,1,0])
    rounded_edge(width = grip_depth, depth = $thingy_depth, height = bottom_wall_width, radius = 1.5);
    
    translate([0, $thingy_depth, object_height])
    mirror([0,0,1])
    rotate([90, 0, 0])
    rounded_edge(width = grip_depth, depth = object_height, height = wall_width, radius = 1.5);
    
    translate([0, $thingy_depth + object_width, object_height])
    rotate([-90, 0, 0])
    #rounded_edge(width = grip_depth, depth = object_height, height = wall_width, radius = 1.5);
}

grip(grip_depth = 15, object_width = 100, object_height = 30);