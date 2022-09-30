kb_left_size = [ 194, 111 ];
kb_right_size = [ 188, 111 ];
kb_height = 12.9;
kb_row_height = 19.5;

kb_padding = 7.6;

kb_right_padding_row1 = 9;
kb_right_padding_row3 = 4.5;
kb_right_padding_row4and5 = 13.5;

// Distances of the top screws from the right
kb_right_top_screws = [
  4.7,
  4.7 + 83,
  4.7 + 83 * 2,
];

// Distances of the bottom screws from the right
kb_right_bottom_screws = [
  4.7,
  4.7 + 49,
  4.7 + 49 + 22,
  4.7 + 49 + 22 + 75,
  4.7 + 49 + 22 + 75 + 24,
];

kb_screw_diameter = 2.3;

case_border_radius = 2;
case_border_thickness = 2;
case_top_thickness = 7;
case_bottom_thickness = 2;

// The height of the inner part of the keyboard
case_inner_elevation = 25;
case_x_angle = 8;  // degrees
case_y_angle = 2;  // degrees

case_left_size = [
  kb_left_size.x + case_border_thickness * 2,
  kb_left_size.y + case_border_thickness * 2,
];

case_right_size = [
  kb_right_size.x + case_border_thickness * 2,
  kb_right_size.y + case_border_thickness * 2,
];

case_top_height = kb_height / 2 + case_top_thickness;
case_bottom_height = kb_height / 2 + case_bottom_thickness;
