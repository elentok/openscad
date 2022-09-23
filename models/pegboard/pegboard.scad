use <BOSL2/std.scad>
include <variables.scad>

module pegboard() {
  board();
  up(pb_thickness) {
    edge_spacers();
    mid_spacers();
  }
}

module board() {
  linear_extrude(pb_thickness) difference() {
    board2d();
    holes2d();
  }
}

module board2d(size = pb_board_size) { rect(size, rounding = pb_border_radius); }

module holes2d(board_size = pb_board_size, holes = pb_holes, hole_diameter = pb_hole_diameter) {
  x0 = board_size.x / 2 - pb_board_padding - pb_hole_diameter / 2;
  y0 = board_size.y / 2 - pb_board_padding - pb_hole_diameter / 2;

  for (ix = [0:holes.x - 1]) {
    for (iy = [0:holes.y - 1]) {
      x = ix * pb_hole_spacing - x0;
      y = iy * pb_hole_spacing - y0;
      translate([ x, y ]) circle(d = hole_diameter);
    }
  }
}

module edge_spacers() {
  inner_size =
      [ pb_board_width - 2 * pb_spacer_thickness, pb_board_height - 2 * pb_spacer_thickness ];
  corner_width = pb_board_width * pb_spacer_percentage;
  corner_height = pb_board_height * pb_spacer_percentage;

  linear_extrude(pb_wall_distance) difference() {
    board2d();
    rect(inner_size, rounding = pb_border_radius);
    square([ pb_board_width, pb_board_height - corner_height ], center = true);
    square([ pb_board_width - corner_width, pb_board_height ], center = true);
  }
}

module mid_spacers() {
  mid_spacer_row();
  right(pb_hole_spacing * 3) mid_spacer_row();
  left(pb_hole_spacing * 3) mid_spacer_row();
}

module mid_spacer_row() {
  mid_spacer();
  fwd(pb_hole_spacing * 3) mid_spacer();
  back(pb_hole_spacing * 3) mid_spacer();
}

module mid_spacer() {
  linear_extrude(pb_wall_distance) shell2d(thickness = -pb_mid_spacer_thickness)
      circle(d = pb_mid_spacer_diameter);
}

pegboard();
