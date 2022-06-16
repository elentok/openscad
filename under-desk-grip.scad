$fn=50;

use <rounded.scad>

module grip(grip_depth, object_width, object_height, bottom_wall_width = 3, wall_width = 2) {
    $thingy_depth = 30;
    
    // Horizontal Left
    translate([0, -$thingy_depth/2 - object_width/2, bottom_wall_width/2])
    centered_rounded_edge(width = grip_depth, depth = $thingy_depth, height = bottom_wall_width, radius = 1.5);
  
    // Horizontal Right
    translate([0, $thingy_depth/2 + object_width/2, bottom_wall_width/2])
    rotate([0,0,180])
    centered_rounded_edge(width = grip_depth, depth = $thingy_depth, height = bottom_wall_width, radius = 1.5);
    
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

grip(grip_depth = 15, object_width = 100, object_height = 30);
