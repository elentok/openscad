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

kb_right_padding_by_row = [ 11, 0, 4.5, 14.5, 19.5 ];
kb_right_row_count = len(kb_right_padding_by_row);
// [ [x, width], [x,width], ...]
kb_right_bottom_row_spaces = [ [ 66, 6 ], [ 120, 6 ] ];
kb_right_bottom_row_spaces_height = 18;

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

kb_screw_diameter = 2.6;

case_border_radius = 2;
case_border_thickness = 1.5;
case_border_tolerance = 0.6;
case_top_thickness = test_mode ? 1.5 : 7;
case_bottom_thickness = 1.5;
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
case_bottom_height = kb_height / 2 + case_bottom_thickness + case_vertical_tolerance;
case_top_border_height = case_top_height - case_top_thickness;
case_bottom_border_height = case_bottom_height - case_bottom_thickness;
case_height = case_top_height + case_bottom_height;

// ------------------------------------------------------------
// USB Holes
// The bottom of the USB holes is the bottom of the bottom plate.

case_usb_hole_width = 15;
case_usb_hole_height = 9;
case_usb_hole_start_from_left = [ 24, 119 ];

// ------------------------------------------------------------
// Legs

leg_hole_diameter = 10;
// Distance between the edge of the case and the edge of the leg hole.
leg_hole_margin = 10;

leg_screw_hole_diameter = 3.8;
leg_screw_head_height = 2;
leg_screw_head_diameter = 6.8;

// ------------------------------------------------------------
// Wrist Rest
wrist_pillow_size = [ 130, 82 ];
wrist_pillow_rounding = 11;
wrist_rest_border_height = 4;
wrist_rest_border_thickness = 1.5;
wrist_rest_bottom_thickness = 2;
wrist_rest_size = add_scalar(wrist_pillow_size, wrist_rest_border_thickness);

// ------------------------------------------------------------
// Notch

notch_tolerance = 0.2;
notch_socket_size = [
  kb_half_connector_width,
  kb_padding + case_border_tolerance / 2,
  case_top_thickness / 2,
];
notch_size = add_scalar(notch_socket_size, -notch_tolerance);