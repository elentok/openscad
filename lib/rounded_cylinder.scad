$fn = 50;

use <rounded_square.scad>

module rounded_cylinder(h, d, r_top, r_bottom) {
  rotate_extrude(360) {
    translate([ d / 4, 0 ])
        rounded_square([ d / 2, h ], [ 0, r_top, r_bottom, 0 ]);
  }
}

rounded_cylinder(h = 50, d = 10, r_top = 5, r_bottom = 1);
