kb_left_size = [ 194, 111 ];
kb_right_size = [ 188, 111 ];
kb_height = 12.9;
kb_row_height = 19.5;
kb_padding = 7.6;
kb_half_connector_width = 10;
kb_half_connector_tolerance = 0.1;

kb_right_padding_row1 = 9;
kb_right_padding_row3 = 4.5;
kb_right_padding_row4and5 = 13.5;

// Distances of the forward screws from the right
kb_right_fwd_screws = [
  4.7,
  4.7 + 83,
  4.7 + 83 * 2,
];

// Distances of the back screws from the right
kb_right_back_screws = [
  4.7,
  4.7 + 49,
  4.7 + 49 + 22,
  4.7 + 49 + 22 + 75,
  4.7 + 49 + 22 + 75 + 24,
];

kb_screw_diameter = 2.3;

case_border_radius = 2;
case_border_thickness = 2;
case_border_tolerance = 0.4;
case_top_thickness = 7;
case_bottom_thickness = 2;
case_vertical_tolerance = 0.2;

// The height of the inner part of the keyboard
case_inner_elevation = 25;
case_x_angle = 8;  // degrees
case_y_angle = 2;  // degrees

case_kb_padding = case_border_thickness + case_border_tolerance / 2;

case_left_size = [
  kb_left_size.x + case_kb_padding * 2,
  kb_left_size.y + case_kb_padding * 2,
];

case_right_size = [
  kb_right_size.x + case_kb_padding * 2,
  kb_right_size.y + case_kb_padding * 2,
];

case_right_fwd_connector = case_kb_padding + kb_right_fwd_screws[1];
case_right_back_connector = case_kb_padding + kb_right_back_screws[2];

case_top_height = kb_height / 2 + case_top_thickness;
case_bottom_height = kb_height / 2 + case_bottom_thickness;
case_top_border_height = case_top_height - case_top_thickness - case_vertical_tolerance;
