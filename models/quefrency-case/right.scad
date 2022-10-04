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
    case_bottom();
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
    case_bottom();
    tag("remove2") case_mask(is_socket = true, connector_z_pos = BOTTOM);
  }
}

module case_top_right() {
  difference() {
    union() {
      // Top
      linear_extrude(case_top_thickness) case_top_2d();

      // Border
      h = case_top_border_height;
      down(h) linear_extrude(h) case_border();
      case_top_right_bottom_row_spaces();

      // debug_borders();
    }
    case_usb_holes();
  }
}

module debug_borders() {
#cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
  back(case_size_y - case_to_keys)
#cube([ 20, case_to_keys, case_top_height * 2 ], anchor = FWD + LEFT);
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
case_bottom();
// case_top_right_left();
// case_top_right_right();
// case_top_right_2d();
// #case_right_mask();
// case_bottom_right_right();
// case_bottom_right_left();
