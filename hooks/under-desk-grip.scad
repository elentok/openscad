$fn = 50;

use <../lib-old/chamfer.scad>
use <../lib-old/rounded.scad>

module grip(grip_depth, object_width, object_height, thingy_depth = 30,
            bottom_wall_width = 3, wall_width = 1.7) {
  large_fillet_radius = 4;

  union() {
    // Horizontal Left
    translate(
        [ 0, -thingy_depth / 2 - object_width / 2, bottom_wall_width / 2 ])
        grip_thingy(width = grip_depth, depth = thingy_depth,
                    height = bottom_wall_width);

    // Horizontal Right
    translate([ 0, thingy_depth / 2 + object_width / 2, bottom_wall_width / 2 ])
        rotate([ 0, 0, 180 ])
            grip_thingy(width = grip_depth, depth = thingy_depth,
                        height = bottom_wall_width);

    // Fillet Left
    translate([
      0, -large_fillet_radius / 2 - wall_width - object_width / 2,
      large_fillet_radius / 2 +
      bottom_wall_width
    ]) rotate([ 0, 0, 180 ])
        negative_edge(width = grip_depth, radius = large_fillet_radius);

    // Fillet Right
    translate([
      0, +large_fillet_radius / 2 + wall_width + object_width / 2,
      large_fillet_radius / 2 +
      bottom_wall_width
    ]) negative_edge(width = grip_depth, radius = large_fillet_radius);

    // Vertical Left
    translate([
      0, -wall_width / 2 - object_width / 2, object_height / 2 + wall_width / 2
    ]) rotate([ 90, 180, 0 ])
        centered_rounded_edge(width = grip_depth,
                              depth = object_height + wall_width,
                              height = wall_width, radius = 1.5);

    // Vertical right
    translate([
      0, wall_width / 2 + object_width / 2, object_height / 2 + wall_width / 2
    ]) rotate([ -90, 0, 0 ])
        centered_rounded_edge(width = grip_depth,
                              depth = object_height + wall_width,
                              height = wall_width, radius = 1.5);

    // Bar
    translate([ 0, 0, wall_width / 2 + object_height ])
        cube([ grip_depth, object_width, wall_width ], center = true);
  }
}

// The part that touches the table (where the screw goes)
module grip_thingy(width, depth, height, screw_hole_diameter = 4,
                   radius = 1.5) {
  difference() {
    centered_rounded_edge(width, depth, height, radius);
    chamfered_hole(height + 0.1, screw_hole_diameter,
                   screw_hole_diameter + 4.5);
  }
}

// grip_thingy(width = 15, depth = 30, height = 3);
// grip(grip_depth = 15, object_width = 100, object_height = 30);

// 4-port USB Charger
// grip(grip_depth = 34, object_width = 59, object_height = 28);

// Type-C Charger
// grip(grip_depth = 24, object_width = 74.5, object_height = 28);

// Lighting
// grip(grip_depth = 22, object_width = 46.8, object_height = 23.5);

// Aiyima A07
// grip(grip_depth = 50, object_width = 100, object_height = 38, wall_width =
// 2);

// FX-Audio DAC-X6
// grip(grip_depth = 50, object_width = 96, object_height = 31, wall_width = 2);

// Aiyima A07 + FX-Audio DAC-X6
grip(grip_depth = 50, object_width = 100, object_height = 74, wall_width = 3);
