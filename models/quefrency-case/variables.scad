include <BOSL2/std.scad>
$fn = 64;

// When set to true it makes some of the parts thinner so they print faster
test_mode = false;

nothing = 0.1;

kb_size_y = 111;
kb_left_size = [ 194, kb_size_y ];
kb_right_size = [ 190, kb_size_y ];
kb_height = test_mode ? 3 : 12.9;
kb_padding = 7.2;  // the board area that isn't covered by keys

kb_screw_diameter = 2.6;
// Instead of circular screw holes they're wider to be more flexible
// This value is added to the sides.
// For example: 2.6mm screw diameter with 2mm flexibility means the hole will be
// 2.6mm + 2*2mm = 6.6mm wide).
kb_screw_flexibility = 1;

case_border_radius = 2;
case_border_thickness = 1.5;
case_border_tolerance = 0.6;
case_top_thickness = test_mode ? 1.5 : 7;
case_bottom_thickness = 3;
case_vertical_tolerance = 0.2;

// The height of the inner part of the keyboard
case_inner_elevation = 25;
case_x_angle = 8;  // degrees
case_y_angle = 2;  // degrees

case_kb_padding = case_border_thickness + case_border_tolerance / 2;

case_to_keys = case_kb_padding + kb_padding;

case_size_y = kb_size_y + case_kb_padding * 2;
// case_left_size = [
//   kb_left_size.x + case_kb_padding * 2,
//   kb_left_size.y + case_kb_padding * 2,
// ];
//
// case_right_size = [
//   kb_right_size.x + case_kb_padding * 2,
//   kb_right_size.y + case_kb_padding * 2,
// ];

case_top_height = kb_height / 2 + case_top_thickness + case_vertical_tolerance;
case_bottom_height = kb_height / 2 + case_bottom_thickness + case_vertical_tolerance;
case_top_border_height = case_top_height - case_top_thickness;
case_bottom_border_height = case_bottom_height - case_bottom_thickness;
case_height = case_top_height + case_bottom_height;

// ------------------------------------------------------------
// USB Holes
// The bottom of the USB holes is the bottom of the bottom plate.

case_usb_hole_width = 15;
case_usb_hole_height = test_mode ? 3 : 9;

// ------------------------------------------------------------
// Legs

// This X offset value was calculated for the right half of the keyboard (so it
// doesn't interfere with the back screws, but it wasn't necessary):
//
//   case_screw5_dist_from_left =
//     case_size_x - kb_back_screws[4].x - case_border_thickness - case_border_tolerance / 2;
//
//   case_tent_hole_center_x_offset_from_edge =
//     case_screw5_dist_from_left + (kb_back_screws[4].x - kb_back_screws[3].x) / 2;
case_tent_hole_center_x_offset_from_edge = 29;
case_tent_hole_center_y_offset_from_edge = 20;
wrist_rest_tent_hole_center_x_offset_from_edge = 15;
wrist_rest_tent_hole_center_y_offset_from_edge = 15;

leg_screw_hole_diameter = 3.8;
leg_screw_head_height = 2;
leg_screw_head_diameter = 6.8;
// The flexibility to each side
leg_screw_head_flexibility = 6;

// ------------------------------------------------------------
// Wrist Rest
wrist_pillow_size = [ 132, 84 ];
wrist_pillow_rounding = 14;
wrist_rest_border_height = 4;
wrist_rest_border_thickness = 1.5;
wrist_rest_bottom_thickness = 2;
wrist_rest_size = add_scalar(wrist_pillow_size, wrist_rest_border_thickness);

// ------------------------------------------------------------
// Connector

connector_width = 10;
connector_tolerance = 0.2;
top_connector_socket_size = [
  connector_width,
  kb_padding + case_border_tolerance / 2,
  case_top_thickness / 2,
];
bottom_connector_socket_size = [
  connector_width,
  kb_padding + case_border_tolerance / 2,
  case_bottom_thickness / 2,
];

top_connector_notch_size = add_scalar(top_connector_socket_size, -connector_tolerance);
bottom_connector_notch_size = add_scalar(bottom_connector_socket_size, -connector_tolerance);

function get_connector_socket_size(z_pos) = z_pos == TOP ? top_connector_socket_size
                                                         : bottom_connector_socket_size;

function get_connector_notch_size(z_pos) = z_pos == TOP ? top_connector_notch_size
                                                        : bottom_connector_notch_size;

// ------------------------------------------------------------
// Tent

tent_height_kb_back = 35 - case_height;
tent_height_kb_front = 42 - case_height;
tent_height_wrist_rest_back = 38;
tent_height_wrist_rest_front = 33;
tent_thickness = 12;

tent_screw_hole_thickness = 2;
tent_screw_nut_diameter = 6.2;
tent_screw_nut_thickness = 2.5;
tent_screw_nut_hole_diameter = 8;

// Reset Button

// Distance of the center of the reset button from the bottom-left edge of the
// left keyboard (and hopefully also the bottom-right edge of the right keyboard).
// (edge = edge of the keyboard panel, not the case, add the border to the
// calculation).
reset_button_pos = [ -89, 46.2 ];
reset_button_hole_diameter = 7.5;
