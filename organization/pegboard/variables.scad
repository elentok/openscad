$fn = 60;

// ============================================================
// Input variables

pb_hole_diameter = 4;
// The distance between the center of each pair of adjacent holes.
pb_hole_spacing = 15;  // 25;
pb_holes_x = 10;
pb_holes_y = 10;
pb_holes = [ pb_holes_x, pb_holes_y ];
pb_border_radius = 8;
pb_thickness = 2;
// The space between the peg and the peg hole (treated as a diameter).
pb_peg_tolerance = 0.8;
pb_hook_width = 4;

// Spacers (distancing the pegboard from the wall).
pb_wall_distance = 5;
pb_spacer_thickness = 2;
// The size of the spacer as percentage of the width and height.
pb_spacer_percentage = 0.3;
pb_mid_spacer_thickness = 1;
pb_mid_spacer_diameter = 5;

// ============================================================
// Calculated variables

pb_peg_diameter = pb_hole_diameter - pb_peg_tolerance;
pb_peg_distance = pb_hole_spacing + pb_hole_diameter;
pb_peg_radius = pb_peg_diameter / 2;

// Allow joining multiple boards together.
pb_board_padding = pb_hole_spacing / 2 - pb_hole_diameter / 2;

function pb_calc_board_size(holes) = [
  (holes.x - 1) * pb_hole_spacing + pb_hole_diameter + pb_board_padding * 2,
  (holes.y - 1) * pb_hole_spacing + pb_hole_diameter + pb_board_padding * 2,
];

pb_board_size = pb_calc_board_size([ pb_holes_x, pb_holes_y ]);
pb_board_width = pb_board_size.x;
pb_board_height = pb_board_size.y;

pb_mount_height = pb_hole_spacing + pb_hole_diameter;
pb_mount_thickness = pb_thickness;
