include <./notch.scad>
include <./screws.scad>
include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_top_right_right() {
  intersection() {
    case_top_right();
    case_right_mask(is_notch_socket = false);
  }
}

module case_bottom_right_right() {
  intersection() {
    case_bottom_right();
    case_right_mask(is_notch_socket = false);
  }
}

module case_top_right_left() {
  diff(remove = "remove2", keep = "keep2") {
    case_top_right();

    tag("remove2") case_right_mask(is_notch_socket = true);
  }
}

module case_right_mask(is_notch_socket) {
  size_x_offset = -kb_half_connector_width / 2 - kb_half_connector_tolerance + nothing;

  size_back = [
    case_right_back_connector + size_x_offset,
    case_right_size.y / 2 + nothing,
    case_height + nothing,
  ];

  offset_back = [
    case_right_size.x - size_back.x + nothing / 2,
    case_right_size.y / 2,  //- nothing / 2,
    -case_bottom_height - case_top_border_height - nothing / 2,
  ];

  size_fwd = [
    case_right_fwd_connector + size_x_offset,
    case_right_size.y / 2 + nothing,
    case_height + nothing,
  ];

  offset_fwd = [
    case_right_size.x - size_fwd.x + nothing / 2,
    -nothing / 2,
    -case_bottom_height - case_top_border_height - nothing / 2,
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
  difference() {
    union() {
      // Top
      linear_extrude(case_top_thickness) case_top_right_2d();

      // Border
      h = case_top_border_height;
      down(h) linear_extrude(h) case_right_border();
      case_top_right_bottom_row_spaces();

      // debug_borders();
    }
    case_right_usb_holes();
  }
}

module case_bottom_right() {
  z = case_bottom_height + case_top_border_height;
  difference() {
    down(z) union() {
      // Bottom plate
      linear_extrude(case_bottom_thickness) case_bottom_right_2d();
      // Border
      up(case_bottom_thickness) linear_extrude(case_bottom_border_height) case_right_border();
    }

    case_right_usb_holes();
    case_right_bottom_leg_screw_holes();
  }
}

module case_right_border() {
  shell2d(-case_border_thickness)
      rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT) {}
}

module case_right_usb_holes() {
  y = case_right_size.y - case_border_thickness - nothing / 2;
  z = -kb_height;
  size = [ case_usb_hole_width, case_border_thickness + nothing, case_usb_hole_height ];
  for (i = [0:len(case_usb_hole_start_from_left) - 1]) {
    x = case_usb_hole_start_from_left[i];
    tag("remove3d") translate([ x, y, z ]) cube(size);
  }
}

module case_right_bottom_leg_screw_holes() {
  x = case_right_size.x / 2;
  y = case_right_size.y / 2;
  z = -(case_height - case_top_thickness);
  translate([ x, y, z ]) leg_screw_holes(case_right_size, case_bottom_thickness);
}

module debug_borders() {
#cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
  back(case_right_size.y - case_to_keys)
#cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
}

module case_bottom_right_2d() {
  diff() {
    rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      case_top_right_screw_holes();
    }
  }
}

module case_top_right_2d() {
  diff() {
    rect(case_right_size, rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      case_top_right_keys_mask();
      case_top_right_extra_row_padding();
      case_top_right_screw_holes();
    }
  }
}

module case_top_right_keys_mask() {
  // keys mask
  keys_size = [ kb_right_size.x - kb_padding, kb_right_size.y - kb_padding * 2 ];
  keys_offset = [ -kb_padding - case_border_thickness, (case_right_size.y - keys_size.y) / 2 ];
  // kb_padding + case_border_thickness
  tag("remove") translate(keys_offset) position(BOTTOM + RIGHT)
      rect(keys_size, rounding = 1, anchor = BOTTOM + RIGHT);
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

module case_top_right_bottom_row_spaces() {
  y = case_to_keys;
  for (i = [0:len(kb_right_bottom_row_spaces) - 1]) {
    spaces = kb_right_bottom_row_spaces[i];
    x = spaces[0];
    width = spaces[1];

    translate([ x, y, 0 ]) linear_extrude(case_top_thickness)
        rect([ width, kb_right_bottom_row_spaces_height ], anchor = BOTTOM + LEFT,
             rounding = [ 1, 1, 0, 0 ]);
  }
}

module case_top_right_screw_holes() {
  for (i = [0:len(kb_right_back_screws) - 1]) {
    screw_offset = kb_right_back_screws[i];
    case_back_screw_mask(screw_offset);
  }
  for (i = [0:len(kb_right_fwd_screws) - 1]) {
    screw_offset = kb_right_fwd_screws[i];
    case_fwd_screw_mask(screw_offset);
  }
}

// case_top_right();
// color("yellow") case_bottom_right();
// case_top_right_left();
// case_top_right_right();
// case_top_right_2d();
// #case_right_mask();
case_bottom_right_right();
