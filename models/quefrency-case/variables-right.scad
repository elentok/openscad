include <./variables.scad>

// Right-half variables

kb_size_x = 190;

case_size_x = kb_size_x + case_kb_padding * 2;

kb_padding_by_row = [ 11, 0, 4.5, 14.5, 19.5 ];
// [ [x, width], [x,width], ...]
kb_bottom_row_spaces = [ [ 66, 6 ], [ 120, 6 ] ];
kb_bottom_row_spaces_height = 18;

// Distances of the forward screws from the right
kb_fwd_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 83, 3.8 ],
  [ 4.4 + 83 + 83, 3.8 ],
];

// Distances of the back screws from the back right
kb_back_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 49.4, 3.8 ],
  [ 4.4 + 49.4 + 22, 3.8 ],
  [ 4.4 + 49.4 + 22 + 75, 3.8 ],
  [ 4.4 + 49.4 + 22 + 75 + 24, 3.8 ],
];

case_fwd_connector = case_kb_padding + kb_fwd_screws[1].x;
case_back_connector = case_kb_padding + kb_back_screws[2].x;

case_right_screw5_dist_from_left =
    case_size_x - kb_back_screws[4].x - case_border_thickness - case_border_tolerance / 2;

case_tent_hole_center_x_offset_from_edge =
    case_right_screw5_dist_from_left + (kb_back_screws[4].x - kb_back_screws[3].x) / 2;

case_usb_hole_start_from_left = [ 24, 119 ];
