$fn = 50;

use <../../lib/rounded.scad>
use <../../lib/shelf.scad>

module box(size, radius, wall_width) {
  linear_extrude(size.z) {
    rounded_rectangle_border(size.x, size.y, radius, wall_width);
  }

  linear_extrude(wall_width) { rounded_rectangle(size.x, size.y, radius); }
}

module box_with_label(size, radius, wall_width) {
  box(size, radius, wall_width);

  label_width = 60;
  label_depth = 10;
  label_height = 10;

  translate(
      [ -label_width / 2, size.y / 2 - label_depth, size.z - label_height ]) {
    shelf([ label_width, label_depth, label_height ]);
  }
}

box_with_label([ 98, 93, 130 ], radius = 5, wall_width = 1.2);
