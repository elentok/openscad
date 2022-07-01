$fn = 64;

use <rounded_square.scad>

// ------------------------------------------------------------
// Rounded Cylinder
// ------------------------------------------------------------

module rounded_cylinder(h, d, r_top, r_bottom) {
  rotate_extrude() {
    translate([ d / 4, 0 ])
        rounded_square([ d / 2, h ], [ 0, r_top, r_bottom, 0 ]);
  }
}

// ------------------------------------------------------------
// Rounded Hollow Cylinder
// ------------------------------------------------------------

module rounded_hollow_cylinder(h, d_top, d_bottom, thickness) {
  rotate_extrude() {
    hull() {
      // Top edge
      translate([ d_top / 2 - thickness / 2, h - thickness / 2 ])
          circle(d = thickness);

      // Bottom edge
      translate([ d_bottom / 2 - thickness / 2, thickness / 2 ])
          circle(d = thickness);
    }
  }
}

// ------------------------------------------------------------
// Test
// ------------------------------------------------------------

// rounded_cylinder(h = 50, d = 10, r_top = 5, r_bottom = 0);
rounded_hollow_cylinder(h = 30, d_top = 70, d_bottom = 50, thickness = 2);
