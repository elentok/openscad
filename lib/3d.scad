$fn = 50;

module disc(diameter, height) {
  linear_extrude(height, center = true) { circle(d = diameter); }
}

module rounded_disc(diameter, height, border_radius = 1) {
  assert(height > border_radius * 2,
         "Height must be higher than 2*border_radius");

  minkowski() {
    disc(diameter - border_radius * 2, height - border_radius * 2);
    sphere(border_radius);
  }
}

module half_rounded_disc(diameter, height, border_radius = 1) {
  intersection() {
    rounded_disc(diameter, height * 2, border_radius);
    translate([ -diameter / 2, -diameter / 2, 0 ]) {
      cube([ diameter, diameter, height ]);
    }
  }
}

module half_sphere(diameter) {
  intersection() {
    translate([ 0, 0, diameter / 4 ]) {
      cube([ diameter, diameter, diameter / 2 ], center = true);
    }

    sphere(d = diameter);
  }
}

// half_sphere(10);
half_rounded_disc(diameter = 85, height = 2.1);
