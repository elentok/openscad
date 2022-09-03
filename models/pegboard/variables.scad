$fn = 60;

// ============================================================
// Input variables

pb_hole_diameter = 4;
pb_hole_spacing = 15;  // 25;
pb_wall_distance = 5;  // 12.7;
pb_holes_x = 10;
pb_holes_y = 10;
pb_border_radius = 10;
pb_thickness = 2.5;
pb_border_thickness = 2;
pb_border_corner_percentage = 0.3;

// ============================================================
// Calculated variables

pb_peg_diameter = pb_hole_diameter - 1;

// Allow joinig multiple boards together.
pb_board_padding = pb_hole_spacing / 2;

pb_board_width = (pb_holes_x - 1) * pb_hole_spacing + pb_hole_diameter + pb_board_padding * 2;
pb_board_height = (pb_holes_y - 1) * pb_hole_spacing + pb_hole_diameter + pb_board_padding * 2;
