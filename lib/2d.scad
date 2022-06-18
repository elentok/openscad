module arc(outer_diameter, thickness) {
  intersection() {
    half_circle(outer_diameter, thickness);

    translate([ -outer_diameter, 0, 0 ]) square(outer_diameter);
  }
}

module half_circle(outer_diameter, thickness) {
  $inner_diameter = outer_diameter - 2 * thickness;

  difference() {
    circle(d = outer_diameter);
    circle(d = $inner_diameter);

    translate([ 0, -outer_diameter / 2, 0 ]) {
      square([ outer_diameter / 2, outer_diameter ]);
    }
  }
}
