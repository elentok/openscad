$fn = 50;

module rounded_cube(width, depth, height, radius) {
  minkowski() {
    cube([ width - radius * 2, depth - radius * 2, height - radius * 2 ],
         center = true);
    sphere(radius);
  }
}

module half_rounded_cube(width, depth, height, radius) {
  intersection() {
    rounded_cube(width, depth, height * 2, radius);

    translate([ -width / 2, -depth / 2, 0 ]) cube([ width, depth, height ]);
  }
}

module quarter_rounded_cube(width, depth, height, radius) {
  intersection() {
    rounded_cube(width, depth * 2, height * 2, radius);

    translate([ -width / 2, 0, 0 ]) cube([ width, depth, height ]);
  }
}

module negative_edge(width, radius) {
  difference() {
    cube([ width, radius, radius ], center = true);

    translate([ 0, radius / 2, radius / 2 ]) rotate([ 0, 90, 0 ])
        cylinder(h = width + 0.1, r = radius, center = true);
  }
}

module rounded_edge_2d(radius, anchor = CENTER, spin = 0) {
  fwd(radius / 2) right(radius / 2)
      attachable(anchor, spin, two_d = true, path = rect([ radius, radius ])) {
    difference() {
      rect([ radius, radius ], anchor = RIGHT + FWD);
      circle(r = radius);
    }
    children();
  }
}

module rounded_edge(width, depth, height, radius) {
  assert(radius <= height, "Radius must be less or equal to the height");
  union() {
    translate([ 0, radius, 0 ]) cube([ width, depth - radius, height ]);

    cube([ width, radius, height - radius ]);

    translate([ 0, radius, (height - radius) ])
        quarter_cylinder(height = width, radius = radius);
  }
}

module centered_rounded_edge(width, depth, height, radius) {
  translate([ -width / 2, -depth / 2, -height / 2 ])
      rounded_edge(width, depth, height, radius);
}

module quarter_cylinder(height, radius) {
  rotate([ 90, -90, 90 ]) rotate_extrude(angle = 90) square([ radius, height ]);
}

// cube([10,20,30]);
// rounded_cube(30, 50, 12, 5);
// half_rounded_cube(30, 50, 6, 5);
// quarter_rounded_cube(30, 25, 6, 5);
// centered_rounded_edge(100, 30, 12, 11);
// half_cylinder(30, 5);
// negative_edge(40, 5);
