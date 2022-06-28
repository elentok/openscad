$fn = 50;

use <../../lib/rsquare.scad>
use <../../lib/shelf.scad>

module box(size, radius, wall_width) {
  linear_extrude(size.z) { rsquare_shell(size.x, size.y, radius, wall_width); }

  linear_extrude(wall_width) { rsquare(size.x, size.y, radius); }
}

module box_with_label(size, radius, wall_width) {
  label_size = [ 60, 10, 10 ];

  box(size, radius, wall_width);

  x = -label_size.x / 2;
  y = size.y / 2 - label_size.y;
  z = size.z - label_size.z;
  translate([ x, y, z ]) shelf(label_size);
}

box_with_label([ 98, 93, 130 ], radius = 5, wall_width = 1.2);
