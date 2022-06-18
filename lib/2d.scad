$fn = 50;

module arc(outer_diameter, thickness) {
  intersection() {
    half_circle(outer_diameter, thickness);

    translate([ -outer_diameter / 2, 0, 0 ]) square(outer_diameter);
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

module slot(width, height) {
  $diameter = height;
  $square_width = width - $diameter;

  union() {
    translate([ -$square_width / 2, 0, 0 ]) circle(d = $diameter);

    square([ $square_width, height ], center = true);

    translate([ $square_width / 2, 0, 0 ]) circle(d = $diameter);
  }
}

module slot_border(outer_width, outer_height, thickness) {
  difference() {
    slot(outer_width, outer_height);
    slot(outer_width - 2 * thickness, outer_height - 2 * thickness);
  }
}

// linear_extrude(20) slot_border(60, 30, 3);
