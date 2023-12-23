$fn = 50;

include <BOSL2/std.scad>

module disc(diameter, height) {
  linear_extrude(height, center = true) { circle(d = diameter); }
}

module rounded_disc(diameter, height, border_radius = 1) {
  assert(height > border_radius * 2, "Height must be higher than 2*border_radius");

  minkowski() {
    disc(diameter - border_radius * 2, height - border_radius * 2);
    sphere(border_radius);
  }
}

module half_rounded_disc(diameter, height, border_radius = 1) {
  intersection() {
    rounded_disc(diameter, height * 2, border_radius);
    translate([ -diameter / 2, -diameter / 2, 0 ]) { cube([ diameter, diameter, height ]); }
  }
}

module half_sphere(diameter) {
  intersection() {
    translate([ 0, 0, diameter / 4 ]) { cube([ diameter, diameter, diameter / 2 ], center = true); }

    sphere(d = diameter);
  }
}

module screw_hole_mask(h, d_screw, d_head) {
  h_head = (d_head - d_screw) / 2;
  h_screw = h - h_head;

  down(h / 2) union() {
    cylinder(d = d_screw, h = h_screw + 0.1);
    up(h_screw) cylinder(d1 = d_screw, d2 = d_head, h_head);
  }
}

// half_sphere(10);
half_rounded_disc(diameter = 85, height = 2.1);
