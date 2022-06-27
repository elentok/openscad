module shelf(width, depth, height) {
  difference() {
    cube([ width, depth, height ]);

    translate([ width / 2, 0, -1 ]) rotate([ 90, 0, 90 ])
        cylinder(h = width + 1, r = depth, center = true);
  };

  $triangle_width = 2;

  // Left triangle
  shelf_triangle(depth, $triangle_width);

  // Right triangle
  translate([ width - $triangle_width, 0, 0 ])
      shelf_triangle(depth, $triangle_width);
}

module shelf_triangle(size, triangle_width) {
  rotate([ 90, 0, 90 ]) linear_extrude(triangle_width)
      polygon([[size, size], [0, size], [size, 0]]);
}
