include <BOSL2/std.scad>
// When set to true it makes some of the parts thinner so they print faster
test_mode = false;

nothing = 0.1;

kb_left_size = [ 194, 111 ];
kb_right_size = [ 190, 111 ];
kb_height = test_mode ? 3 : 12.9;
kb_row_height = 19.5;
kb_padding = 7.2;  // the board area that isn't covered by keys
kb_half_connector_width = 10;
kb_half_connector_tolerance = 0.1;

kb_right_padding_row1 = 9;
kb_right_padding_row3 = 4.5;
kb_right_padding_row4and5 = 13.5;
kb_screw_distance_from_edge = 4.4;

// Distances of the forward screws from the right
kb_right_fwd_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 83, 3.8 ],
  [ 4.4 + 83 + 83, 3.8 ],
];

// Distances of the back screws from the back right
kb_right_back_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 49.4, 3.8 ],
  [ 4.4 + 49.4 + 22, 3.8 ],
  [ 4.4 + 49.4 + 22 + 75, 3.8 ],
  [ 4.4 + 49.4 + 22 + 75 + 24, 3.8 ],
];

kb_screw_diameter = 2.5;

case_border_radius = 2;
case_border_thickness = 1.5;
case_border_tolerance = 0.6;
case_top_thickness = test_mode ? 1.5 : 7;
case_bottom_thickness = 2;
case_vertical_tolerance = 0.2;

// The height of the inner part of the keyboard
case_inner_elevation = 25;
case_x_angle = 8;  // degrees
case_y_angle = 2;  // degrees

case_kb_padding = case_border_thickness + case_border_tolerance / 2;

case_to_keys = case_kb_padding + kb_padding;

case_left_size = [
  kb_left_size.x + case_kb_padding * 2,
  kb_left_size.y + case_kb_padding * 2,
];

case_right_size = [
  kb_right_size.x + case_kb_padding * 2,
  kb_right_size.y + case_kb_padding * 2,
];

case_right_fwd_connector = case_kb_padding + kb_right_fwd_screws[1].x;
case_right_back_connector = case_kb_padding + kb_right_back_screws[2].x;

case_top_height = kb_height / 2 + case_top_thickness + case_vertical_tolerance;
case_bottom_height = kb_height / 2 + case_bottom_thickness;
case_top_border_height = case_top_height - case_top_thickness;

notch_tolerance = 0.2;
notch_socket_size = [
  kb_half_connector_width,
  kb_padding + case_border_tolerance / 2,
  case_top_thickness / 2,
];
notch_size = add_scalar(notch_socket_size, -notch_tolerance);

// notch_size_offset = 0.2;
// notch_size = add_scalar(notch_socket_size, -notch_size_offset);

// Make masks slightly larger so the diff works well.
// mask_offset = 0.2;
