$fn = 50;

use <../../lib/rounded.scad>
use <../../lib/shelf.scad>

module box(width, depth, height, radius, wall_width) {
  linear_extrude(height)
      rounded_rectangle_border(width, depth, radius, wall_width);

  linear_extrude(wall_width) rounded_rectangle(width, depth, radius);
}

module box_with_label(width, depth, height, radius, wall_width) {
  box(width, depth, height, radius, wall_width);

  $label_width = 60;
  $label_depth = 10;
  $label_height = 10;

  translate(
      [ -$label_width / 2, depth / 2 - $label_depth, height - $label_height ])
      shelf($label_width, $label_depth, $label_height);
}

box_with_label(width = 98, depth = 93, height = 130, radius = 5,
               wall_width = 1.2);
