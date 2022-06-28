// ------------------------------------------------------------
// Shelf
// ------------------------------------------------------------

module shelf(size) {
  difference() {
    cube(size);

    translate([ size.x / 2, 0, -1 ]) {
      rotate([ 90, 0, 90 ]) {
        cylinder(h = size.x + 1, r = size.y, center = true);
      }
    }
  }

  triangle_width = 2;

  // Left triangle
  shelf_triangle(size.y, triangle_width);

  // Right triangle
  translate([ size.x - triangle_width, 0, 0 ]) {
    shelf_triangle(size.y, triangle_width);
  }
}

module shelf_triangle(size, triangle_width) {
  rotate([ 90, 0, 90 ]) {
    linear_extrude(triangle_width) {
      polygon([[size, size], [0, size], [size, 0]]);
    }
  }
}
