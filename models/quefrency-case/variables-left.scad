include <./variables.scad>

// Left-half variables

kb_size_x = is_quefrency ? 194 : 200;
case_size_x = kb_size_x + case_kb_padding * 2;

kb_row_heights = is_quefrency
                     ? [ 20.7, 17.5, 19.1, 20.7, 19.5 ]
                     : [ 20.7 - 1, 21.7 + 3, 19.1 - 1, 19.1, 20.7 - 0.5, 19.5 ];

kb_padding_by_row =
    is_quefrency ? [ 4.8, 14, 9.8, 0, 3.8 ]
                 : [ 0, 4.8 + 4.8, 4.8 + 14, 4.8 + 9.8, 4.8 + 0, 4.8 + 3.8 ];
;

// [ [x, width], [x,width], ...]
kb_bottom_row_spaces = [[kb_size_x - 52.7, 7.5]];
kb_bottom_row_spaces_height = kb_size_y - case_to_keys + nothing;

// Distances of the forward screws from the right
kb_fwd_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 92, 3.8 ],
  [ 4.4 + 92 + 92.2, 3.8 ],
];

// Distances of the back screws from the back right
quefrency_back_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 59, 3.8 ],
  [ 4.4 + 59 + 22, 3.8 ],
  [ 4.4 + 59 + 22 + 75.5, 3.8 ],
  [ 4.4 + 59 + 22 + 75.5 + 24, 3.8 ],
];

sinc_back_screws = [

  [ 4.4, 4.4 ],
  [ 4.4 + 59, 3.8 ],
  [ 4.4 + 59 + 22, 3.8 ],
  [ 4.4 + 59 + 22 + 63.3, 3.8 ],
  [ 4.4 + 59 + 22 + 63.3 + 18, 3.8 ],
  [ 4.4 + 59 + 22 + 63.3 + 18 + 27.4, 3.8 ],
];

kb_back_screws = is_quefrency ? quefrency_back_screws : sinc_back_screws;

case_fwd_connector = case_kb_padding + kb_fwd_screws[1].x;
case_back_connector = case_kb_padding + kb_back_screws[2].x;

case_screw5_dist_from_left = case_size_x - kb_back_screws[4].x -
                             case_border_thickness - case_border_tolerance / 2;

case_usb_hole_start_from_left = is_quefrency ? [ 18, 114 ] : [ 36, 119 ];

// Distance of the center of the reset button from the bottom-left edge of the
// left keyboard case.
reset_button_pos = is_quefrency ? [ -91, 46.2 + 3.5 ] : [ -89, 48 ];
