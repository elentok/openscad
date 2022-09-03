include <BOSL2/std.scad>
include <variables.scad>

module pegboard() {
  board();
  up(pb_thickness) wall_distance();
}

module board() {
  linear_extrude(pb_thickness) difference() {
    board2d();
    holes2d();
  }
}

module board2d() { rect([ pb_board_width, pb_board_height ], rounding = pb_border_radius); }

module holes2d() {
  x0 = pb_board_width / 2 - pb_board_padding - pb_hole_diameter / 2;
  y0 = pb_board_width / 2 - pb_board_padding - pb_hole_diameter / 2;

  for (ix = [0:pb_holes_x - 1]) {
    for (iy = [0:pb_holes_y - 1]) {
      x = ix * pb_hole_spacing - x0;
      y = iy * pb_hole_spacing - y0;
      translate([ x, y ]) circle(d = pb_hole_diameter);
    }
  }
}

module wall_distance() {
  inner_size =
      [ pb_board_width - 2 * pb_border_thickness, pb_board_height - 2 * pb_border_thickness ];
  corner_width = pb_board_width * pb_border_corner_percentage;
  corner_height = pb_board_height * pb_border_corner_percentage;

  linear_extrude(pb_wall_distance) difference() {
    board2d();
    rect(inner_size, rounding = pb_border_radius);
    square([ pb_board_width, pb_board_height - corner_height ], center = true);
    square([ pb_board_width - corner_width, pb_board_height ], center = true);
  }
}

pegboard();
