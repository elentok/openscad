$fn = 64;

use <../../lib/rounded_cylinder.scad>

module bowl(h, d_top, d_bottom, thickness) {
  rotate_extrude() bowl_cut(h, d_top, d_bottom, thickness);
}

module bowl_cut(h, d_top, d_bottom, thickness) {
  // Side
  hull() {
    // Top edge
    translate([ d_top / 2 - thickness / 2, h - thickness / 2 ])
        circle(d = thickness);

    // Bottom edge
    translate([ d_bottom / 2 - thickness / 2, thickness / 2 ])
        circle(d = thickness);
  }

  // Bottom
  hull() {
    // Center
    square([ thickness, thickness ]);

    // External
    translate([ d_bottom / 2 - thickness / 2, thickness / 2 ])
        circle(d = thickness);
  }
}

module wide_angle_fillet(angle, length, radius) {
  // radius = length / sin(angle - 90);
  difference() {
    square([ radius, radius ]);
    translate([ 0, radius ]) circle(r = radius);
  }
}

bowl(h = 40, d_top = 90, d_bottom = 70, thickness = 1.6);
