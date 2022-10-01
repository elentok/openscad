include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_top_right_right() {
  intersection() {
    case_top_right();
    case_top_right_right_mask(is_notch_socket = false);
  }
}

module case_top_right_left() {
  diff(remove = "remove2", keep = "keep2") {
    case_top_right();

    tag("remove2") case_top_right_right_mask(is_notch_socket = true);
  }
}

module case_top_right_right_mask(is_notch_socket) {
  // The notch itself must be a little smaller than the socket so it'll fit
  // properly.
  notch_size_offset = is_notch_socket ? 0 : -0.2;
  notch_mask_offset = is_notch_socket ? 0.1 : 0;

  size_x_offset = -kb_half_connector_width / 2 - kb_half_connector_tolerance + nothing;

  size_back = [
    case_right_back_connector + size_x_offset,
    case_right_size.y / 2 + nothing,
    case_top_height + nothing,
  ];

  offset_back = [
    case_right_size.x - size_back.x + nothing / 2,
    case_right_size.y / 2,  //- nothing / 2,
    -case_top_border_height - nothing / 2,
  ];

  size_fwd = [
    case_right_fwd_connector + size_x_offset,
    case_right_size.y / 2 + nothing,
    case_top_height + nothing,
  ];

  offset_fwd = [
    case_right_size.x - size_fwd.x + nothing / 2,
    -nothing / 2,
    -case_top_border_height - nothing / 2,
  ];

  notch_mask_size = is_notch_socket ? notch_socket_size : notch_size;

  translate(offset_back) cube(size_back, anchor = BOTTOM + FWD + LEFT) {
    if (is_notch_socket) {
      notch_socket(BACK);
    } else {
      notch(BACK);
    }
  };

  translate(offset_fwd) cube(size_fwd, anchor = BOTTOM + FWD + LEFT) {
    if (is_notch_socket) {
      notch_socket(FWD);
    } else {
      notch(FWD);
    }
  };
}

// pos = BACK or FWD
module notch(pos) {
  y_offset = pos == FWD ? nothing + (case_to_keys - notch_size.y)
                        : -nothing - (case_to_keys - notch_size.y);
  notch_offset = [
    nothing,
    y_offset,
    -nothing / 2 - (case_top_thickness - notch_size.z),
  ];
  translate(notch_offset) position(TOP + LEFT + pos) cube(notch_size, anchor = TOP + RIGHT + pos);
}

module notch_socket(pos) {
  y_offset = pos == FWD ? nothing + case_border_thickness : -nothing - case_border_thickness;
  notch_socket_offset = [
    nothing,
    y_offset,
    -nothing / 2 - case_top_thickness / 2,
  ];
  size = add_scalar(notch_socket_size, nothing);
  translate(notch_socket_offset) position(TOP + LEFT + pos) cube(size, anchor = TOP + RIGHT + pos);
}

module case_top_right() {
  // Top
  linear_extrude(case_top_thickness) case_top_right_2d();

  // Border
  h = case_top_border_height;
  down(h) linear_extrude(h) shell2d(-case_border_thickness)
      rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT);

  // Debug: borders
  // #cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
  //   back(case_right_size.y - case_to_keys)
  // #cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
}

module case_top_right_2d() {
  diff() {
    rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      // keys mask
      keys_size = [ kb_right_size.x - kb_padding, kb_right_size.y - kb_padding * 2 ];
      keys_offset = [ -kb_padding - case_border_thickness, (case_right_size.y - keys_size.y) / 2 ];
      // kb_padding + case_border_thickness
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
        screw_offset = kb_right_back_screws[i];
        back_screw_mask(screw_offset);
      }
      for (i = [0:len(kb_right_fwd_screws) - 1]) {
        screw_offset = kb_right_fwd_screws[i];
        fwd_screw_mask(screw_offset);
      }
    }
  }
}

module back_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) fwd(case_kb_padding + screw_offset.y)
      position(BACK + RIGHT) circle(d = kb_screw_diameter);
}

module fwd_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) back(case_kb_padding + screw_offset.y)
      position(FWD + RIGHT) circle(d = kb_screw_diameter);
}

// case_top_right();
case_top_right_left();
// case_top_right_right();
// case_top_right_2d();
// #case_top_right_right_mask();
