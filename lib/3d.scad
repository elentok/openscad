module disc(diameter, depth, center = false) {
  translate([ 0, 0, center ? -depth / 2 : 0 ]) {
    linear_extrude(depth) { circle(d = diameter); }
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

half_sphere(10);
