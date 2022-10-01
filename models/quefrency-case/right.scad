include <./notch.scad>
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

      case_top_right_extra_row_padding();
      case_top_right_screw_holes();
    }
  }
}

module case_top_right_extra_row_padding() {
  for (i = [0:kb_right_row_count - 1]) {
    padding = kb_right_padding_by_row[i];
    if (padding > 0) {
      padding_size = [ padding, kb_row_height ];
      padding_offset = [
        case_border_thickness,
        -case_border_thickness - kb_padding - kb_row_height * i,
      ];

      round_top = i > 0 && kb_right_padding_by_row[i - 1] < padding;
      round_bottom = i < kb_right_row_count - 1 && kb_right_padding_by_row[i + 1] < padding;
      rounding = [
        round_top ? 1 : 0,
        0,
        0,
        round_bottom ? 1 : 0,
      ];

      tag("keep") translate(padding_offset) position(TOP + LEFT)
          rect(padding_size, anchor = TOP + LEFT, rounding = rounding);
    }
  }
}

module case_top_right_screw_holes() {
  for (i = [0:len(kb_right_back_screws) - 1]) {
    screw_offset = kb_right_back_screws[i];
    back_screw_mask(screw_offset);
  }
  for (i = [0:len(kb_right_fwd_screws) - 1]) {
    screw_offset = kb_right_fwd_screws[i];
    fwd_screw_mask(screw_offset);
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
