include <./connector.scad>
include <./screws.scad>
// include <./variables.scad>
include <./case-shared.scad>
include <./variables-right.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_top_right_right() {
  intersection() {
    case_top_right();
    case_mask(is_socket = false, connector_z_pos = TOP);
  }
}

module case_bottom_right_right() {
  intersection() {
    case_bottom_right();
    case_mask(is_socket = false, connector_z_pos = BOTTOM);
  }
}

module case_top_right_left() {
  diff(remove = "remove2", keep = "keep2") {
    case_top_right();
    tag("remove2") case_mask(is_socket = true, connector_z_pos = TOP);
  }
}

module case_bottom_right_left() {
  diff(remove = "remove2", keep = "keep2") {
    case_bottom_right();
    tag("remove2") case_mask(is_socket = true, connector_z_pos = BOTTOM);
  }
}

module case_top_right() {
  difference() {
    union() {
      // Top
      linear_extrude(case_top_thickness) case_top_right_2d();

      // Border
      h = case_top_border_height;
      down(h) linear_extrude(h) case_border();
      case_top_right_bottom_row_spaces();

      // debug_borders();
    }
    case_usb_holes();
  }
}

module case_bottom_right() {
  z = case_bottom_height + case_top_border_height;
  difference() {
    down(z) union() {
      // Bottom plate
      linear_extrude(case_bottom_thickness) case_bottom_2d();
      // Border
      up(case_bottom_thickness) linear_extrude(case_bottom_border_height) case_border();
    }

    case_usb_holes();
#case_right_bottom_leg_screw_holes();
  }
}

module case_right_bottom_leg_screw_holes() {
  x = case_size_x / 2;
  y = case_size_y / 2;
  z = -(case_height - case_top_thickness);
  translate([ x, y, z ]) leg_screw_holes([ case_size_x, case_size_y ], case_bottom_thickness,
                                         dist_from_corner = case_tent_holes_dist_from_corner);
}

module debug_borders() {
#cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
  back(case_size_y - case_to_keys)
#cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
}

module case_top_right_2d() {
  diff() {
    rect([ case_size_x, case_size_y ], rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      case_right_keys_mask();
      case_right_keys_padding_mask();
      case_screw_holes();
    }
  }
}

module case_right_keys_mask() {
  keys_size = [ kb_right_size.x - kb_padding, kb_right_size.y - kb_padding * 2 ];
  keys_offset = [ -kb_padding - case_border_thickness, (case_size_y - keys_size.y) / 2 ];
  tag("remove") translate(keys_offset) position(BOTTOM + RIGHT)
      rect(keys_size, rounding = 1, anchor = BOTTOM + RIGHT);
}

module case_right_keys_padding_mask() {
  row_count = len(kb_padding_by_row);

  for (i = [0:row_count - 1]) {
    padding = kb_padding_by_row[i];
    if (padding > 0) {
      padding_size = [ padding, kb_row_height ];
      padding_offset = [
        case_border_thickness,
        -case_border_thickness - kb_padding - kb_row_height * i,
      ];

      round_top = i > 0 && kb_padding_by_row[i - 1] < padding;
      round_bottom = i < row_count - 1 && kb_padding_by_row[i + 1] < padding;
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
  for (i = [0:len(kb_bottom_row_spaces) - 1]) {
    spaces = kb_bottom_row_spaces[i];
    x = spaces[0];
    width = spaces[1];

    translate([ x, y, 0 ]) linear_extrude(case_top_thickness) rect(
        [ width, kb_bottom_row_spaces_height ], anchor = BOTTOM + LEFT, rounding = [ 1, 1, 0, 0 ]);
  }
}

case_top_right();
case_bottom_right();
// color("yellow") case_bottom_right();
// case_top_right_left();
// case_top_right_right();
// case_top_right_2d();
// case_top_right_2d();
// #case_right_mask();
// case_bottom_right_right();
// case_bottom_right_left();
