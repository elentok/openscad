$fn = 50;

use <3d.scad>

$magnet_outer_diameter = 14.74;
$magnet_inner_diameter = 3.78;
$magnet_depth = 2.58;

$magnet_slot_depth = 2.62;     // first print was 2.65
$magnet_slot_diameter = 14.8;  // first print was 14.9
$magnet_wall_width = 0.5;      // first print was 0.7
$magnet_removal_hole_diameter = 2;

module magnet_holder(
    width, height, depth, magnet_slot_diameter = $magnet_slot_diameter,
    magnet_slot_depth = $magnet_slot_depth,
    magnet_wall_width = $magnet_wall_width,
    magnet_removal_hole_diameter = $magnet_removal_hole_diameter) {
  assert(width > magnet_slot_diameter, "Slot must be wider than the magnet.");
  assert(height > magnet_slot_diameter, "Slot must be higher than the magnet.");
  assert(depth > magnet_slot_depth, "Slot must be deeper than the magnet.");

  difference() {
    cube([ width, height, depth ], center = true);

    $magnet_z_offset = (depth - magnet_slot_depth) / 2 - magnet_wall_width;

    // The magnet slot
    translate([ 0, 0, $magnet_z_offset ]) {
      magnet_slot(magnet_slot_diameter, magnet_slot_depth, height);
    }

    // Hole to allow removing the magnet
    translate([ 0, 0, $magnet_z_offset ]) {
      rotate([ 90, 0, 0 ]) {
        cylinder(d = magnet_removal_hole_diameter, h = height, center = true);
      }
    }
  }
}

module magnet_slot(diameter, depth, height) {
  union() {
    // The slot where the magnet should pass
    translate([ 0, height / 4, 0 ]) {
      cube([ diameter, height / 2 + 0.1, depth ], center = true);
    }

    // The magnet
    disc(diameter, depth);
  }
}

magnet_holder(22, 20, 5);
