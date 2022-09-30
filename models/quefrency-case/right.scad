include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_top_right_right() {
  intersection() {
    case_top_right();
    case_top_right_right_half_mask(with_connector = true);
  }
}

module case_top_right_left() {
  diff(remove = "remove2", keep = "keep2") {
    case_top_right();

    tag("remove2") case_top_right_right_half_mask();
  }
}

module case_top_right_right_half_mask(with_connector = false) {
  connector_offset = with_connector ? kb_half_connector_width / 2 : -kb_half_connector_width / 2;

  size_back = [
    case_right_back_connector + connector_offset - kb_half_connector_tolerance,
    case_right_size.y / 2, case_top_height + 0.2
  ];

  size_fwd = [
    case_right_fwd_connector + connector_offset - kb_half_connector_tolerance,
    case_right_size.y / 2, case_top_height + 0.2
  ];

  right(case_right_size.x - size_back.x) down(case_top_border_height + 0.1) back(size_back.y)
      cube(size_back, anchor = BOTTOM + FWD + LEFT);

  right(case_right_size.x - size_fwd.x) down(case_top_border_height + 0.1)
      cube(size_fwd, anchor = BOTTOM + FWD + LEFT);
}

module case_top_right() {
  // Top
  linear_extrude(case_top_thickness) case_top_right_2d();

  // Border
  h = case_top_border_height;
  down(h) linear_extrude(h) shell2d(-case_border_thickness)
      rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT);
}

module case_top_right_2d() {
  diff() {
    rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      // keys mask
      keys_size = [ kb_right_size.x - kb_padding, kb_right_size.y - kb_padding * 2 ];
      keys_offset = [ -kb_padding - case_border_thickness, kb_padding + case_border_thickness ];
      tag("remove") translate(keys_offset) position(BOTTOM + RIGHT)
          rect(keys_size, rounding = 1, anchor = BOTTOM + RIGHT);

      // extra padding for row 1
      row1_padding_size = [ kb_right_padding_row1, kb_row_height ];
      row1_padding_offset = [ case_border_thickness, -case_border_thickness - kb_padding ];
      tag("keep") translate(row1_padding_offset) position(TOP + LEFT)
          rect(row1_padding_size, anchor = TOP + LEFT, rounding = [ 0, 0, 0, 1 ]);

      // extra padding for row 3
      row3_padding_size = [ kb_right_padding_row3, kb_row_height ];
      row3_padding_offset =
          [ case_border_thickness, -case_border_thickness - kb_padding - kb_row_height * 2 ];
      tag("keep") translate(row3_padding_offset) position(TOP + LEFT)
          rect(row3_padding_size, anchor = TOP + LEFT, rounding = [ 1, 0, 0, 0 ]);

      // extra padding for row 4 + 5
      row4and5_padding_size = [ kb_right_padding_row4and5, kb_row_height * 2 ];
      row4and5_padding_offset =
          [ case_border_thickness, -case_border_thickness - kb_padding - kb_row_height * 3 ];
      tag("keep") translate(row4and5_padding_offset) position(TOP + LEFT)
          rect(row4and5_padding_size, anchor = TOP + LEFT, rounding = [ 1, 0, 0, 1 ]);

      // Screws
      for (i = [0:len(kb_right_back_screws) - 1]) {
        left(case_kb_padding + kb_right_back_screws[i]) back_screw_mask();
      }
      for (i = [0:len(kb_right_fwd_screws) - 1]) {
        left(case_kb_padding + kb_right_fwd_screws[i]) fwd_screw_mask();
      }
    }
  }
}

module back_screw_mask() {
  tag("remove") fwd(case_kb_padding + kb_screw_distance_from_edge) position(BACK + RIGHT)
      circle(d = kb_screw_diameter);
}

module fwd_screw_mask() {
  tag("remove") back(case_kb_padding + kb_screw_distance_from_edge) position(FWD + RIGHT)
      circle(d = kb_screw_diameter);
}

case_top_right_right();
// case_top_right_2d();
