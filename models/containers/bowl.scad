$fn = 64;

use <../../lib/rounded_cylinder.scad>

module bowl(h, d_top, d_bottom, thickness) {
  // rotate_extrude() {
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
#translate([ d_bottom / 2 - thickness / 2, thickness / 2 ])
    circle(d = thickness);
  }

  tan_alpha = (h - thickness) / (d_top / 2 - d_bottom / 2);
  delta_x = thickness / 2 * tan_alpha;
  angle = 180 - atan(tan_alpha);

  fillet_length = 10;

  fillet_radius = fillet_length / tan_alpha;

  // #polygon(
  //     [ [ 0, thickness / 2 ], [ d_bottom / 2, thickness / 2 ], [ d_bottom /
  //     2,
  // thickness * 2] ]);
  // angle = 90 + atan((d_top - d_bottom) / h);
  // fillet_length = thickness;
  % translate([ d_bottom / 2 - thickness - fillet_length - delta_x, thickness ])
          wide_angle_fillet(angle, fillet_length, fillet_radius);
}

module wide_angle_fillet(angle, length, radius) {
  // radius = length / sin(angle - 90);
  difference() {
    square([ radius, radius ]);
    translate([ 0, radius ]) circle(r = radius);
  }
}

bowl(h = 30, d_top = 160, d_bottom = 50, thickness = 2);
