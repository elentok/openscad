include <BOSL2/std.scad>
use <../../lib/screw-hole-mask.scad>
use <../../lib/thumb-mask.scad>
$fn = 64;

width = 210;
height = 30;
depth = 30;
thickness = 3;

back_holes_offset = 3;
bottom_holes_offset = depth / 2;

module keyboard_tray_stop() {
  difference() {
    union() {
      panel();
      rotate([ -90, 0, 0 ]) panel();
    }

    // back holes
    left(width / 2 - 20) back_hole_mask();
    back_hole_mask();
    right(width / 2 - 20) back_hole_mask();

    // bottom holes
    left(width / 2 - 20) bottom_hole_mask();
    bottom_hole_mask();
    right(width / 2 - 20) bottom_hole_mask();

    // cable holes
    dist = width / 8;
    cable_hole_mask();
    left(dist) cable_hole_mask();
    left(dist * 2) cable_hole_mask();
    left(dist * 3) cable_hole_mask();
    right(dist) cable_hole_mask();
    right(dist * 2) cable_hole_mask();
    right(dist * 3) cable_hole_mask();
  }
}

module panel() {
  linear_extrude(thickness, convexity = 4)
      rect([ width, height ], rounding = [ 0, 0, height / 2, height / 2 ],
           anchor = BACK);
}

module back_hole_mask() {
  fwd(0.01) up(thickness + back_holes_offset) screw_hole_mask(
      d_screw = 4, d_screw_head = 6, l_wall = thickness + 0.02,
      l_screwdriver = 0, l_countersink = 1, axis = FWD, anchor = FWD);
}

module bottom_hole_mask() {
  down(0.01) fwd(bottom_holes_offset) screw_hole_mask(
      d_screw = 4, d_screw_head = 10, l_wall = thickness + 0.02,
      l_screwdriver = 0, l_countersink = 1, axis = DOWN, anchor = BOTTOM);
}

module cable_hole_mask() {
  back(thickness) up(height + 0.01) rotate([ 90, 0, 0 ])
      linear_extrude(thickness + 0.01) thumb_mask(5, 10, 2);
}

// // bottom
// cube([ width, depth, thickness ], anchor = BACK + BOTTOM);
//
// // back
// rotate([ 90, 0, 0 ]) linear_extrude(thickness, convexity = 4)
//     rect([ width, height ], rounding = [ height / 2, height / 2, 0, 0 ],
//          anchor = FWD);
// cube([ width, thickness, height ], anchor = BACK + BOTTOM);

keyboard_tray_stop();
