include <./variables.scad>

// Right-half variables

kb_size_x = 190;
case_size_x = kb_size_x + case_kb_padding * 2;

kb_row_heights = is_quefrency ? [ 19.5, 19.5, 19.5, 19.5, 19.5 ]
                              : [ 23.3, 19.5, 19.5, 19.5, 19.5, 19.5 ];
kb_padding_by_row =
    is_quefrency ? [ 11, 0, 4.5, 14.5, 19.5 ] : [ 20, 11, 0, 4.5, 14.5, 19.5 ];

// [ [x, width], [x,width], ...]
kb_bottom_row_spaces = is_quefrency ? [ [ 66, 6 ], [ 120, 6 ] ] : [[ 66, 5 ]];
kb_bottom_row_spaces_height = 18;

// Distances of the forward screws from the right
kb_fwd_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 83, 3.8 ],
  [ 4.4 + 83 + 83, 3.8 ],
];

// Distances of the back screws from the back right
quefrency_back_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 49.4, 3.8 ],
  [ 4.4 + 49.4 + 22, 3.8 ],
  [ 4.4 + 49.4 + 22 + 75, 3.8 ],
  [ 4.4 + 49.4 + 22 + 75 + 24, 3.8 ],
];

sinc_back_screws = [
  [ 4.4, 4.4 ],
  [ 4.4 + 54.1, 3.8 ],
  [ 4.4 + 54.1 + 22, 3.8 ],
  [ 4.4 + 54.1 + 22 + 39.1, 3.8 ],
  [ 4.4 + 54.1 + 22 + 39.1 + 18.3, 3.8 ],
  [ 4.4 + 54.1 + 22 + 39.1 + 18.3 + 27.4, 3.8 ],
];

kb_back_screws = is_quefrency ? quefrency_back_screws : sinc_back_screws;

case_fwd_connector = case_kb_padding + kb_fwd_screws[1].x;
case_back_connector = case_kb_padding + kb_back_screws[2].x;

case_usb_hole_start_from_left = is_quefrency ? [ 24, 119 ] : [ 55.5, 114.5 ];
