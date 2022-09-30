include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_top_right_right() {
  diff(remove = "remove2", keep = "keep2") { case_top_right_2d(); }
}

module case_top_right() { linear_extrude(1.5) case_top_right_2d(); }

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
      for (i = [0:len(kb_right_bottom_screws) - 1]) {
        left(kb_right_bottom_screws[i]) bottom_screw_mask();
      }
      for (i = [0:len(kb_right_top_screws) - 1]) {
        left(kb_right_top_screws[i]) top_screw_mask();
      }
    }
  }
}

module bottom_screw_mask() {
  tag("remove") back(4.7) position(BOTTOM + RIGHT) circle(d = kb_screw_diameter);
}

module top_screw_mask() {
  tag("remove") fwd(4.7) position(TOP + RIGHT) circle(d = kb_screw_diameter);
}

case_top_right_right();
// case_top_right_2d();
