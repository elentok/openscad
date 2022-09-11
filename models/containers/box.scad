$fn = 50;

use <../../lib/rounded_square.scad>
use <../../lib/shelf.scad>
include <BOSL2/std.scad>

// ------------------------------------------------------------
// Box
// ------------------------------------------------------------

module box(size, rounding = 2, thickness = 2) {
  linear_extrude(thickness) rect([ size.x, size.y ], rounding = rounding);

  linear_extrude(size.z) shell2d(-thickness, ir = rounding)
      rect([ size.x, size.y ], rounding = rounding);
}

// module box(size, radius, wall_width) {
//   linear_extrude(size.z) { rounded_shell(size, wall_width, radius); }
//
//   linear_extrude(wall_width) { rounded_square(size, radius); }
// }

// ------------------------------------------------------------
// Box with Label
// ------------------------------------------------------------

module box_with_label(size, radius, wall_width) {
  label_size = [ 60, 10, 10 ];

  box(size, radius, wall_width);

  x = -label_size.x / 2;
  y = size.y / 2 - label_size.y;
  z = size.z - label_size.z;
  translate([ x, y, z ]) shelf(label_size);
}

// ------------------------------------------------------------
// Test
// ------------------------------------------------------------

box_with_label([ 98, 93, 130 ], radius = 5, wall_width = 1.2);
