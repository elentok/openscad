$fn = 64;

// ========================================
// FAN

// distance of the edge of the hole from the edge of the fan
fan_size = 120;
fan_hole_margin = 5.3;
fan_hole_diameter = 4.3;

// ========================================
// MISC

nothing = 0.01;
wall_thickness = 2;

// ========================================
// BASE

// The base has a trapezoid-like structure, the bottom is wider than the top.
base_size_y_top = 34;
base_size_y_bottom = 56;

// The extra padding that makes the base slightly wider than the fan itself.
base_side_padding = 10;

base_size = [
  fan_size + base_side_padding * 2,
  base_size_y_bottom,
  40,
];

// The distance of the base wall from the center of the base.
base_wall_x = wall_thickness / 2 + base_size.x / 2 - 25;

// ========================================
// POWER SOCKET AND SWITCH SIZES

power_socket_width = 10.9;
power_socket_diameter = 12;

power_switch_hole_diameter = 6.3;
power_switch_nib_size = [ 3, 3 ];
power_switch_nib_dist_from_hole_center = 5.5;

// ========================================
// BASE TOP CABLE HOLES
//
// The top of the control box has two holes for the fan cable to go through
// (one on each side for flexibility).
cable_hole_size = [ 25, 9 ];
cable_hole_distance_from_wall = 5;

// ========================================
// FAN CONNECTORS

fan_connector_hole_tolerance = 0.2;
fan_connector_notch_wall = 0.6;
fan_connector_wall_thickness = 1.5;
fan_connector_tolerance = 0.3;
fan_connector_leg_space = 1;
fan_connector_leg_notch_size = 0.9;
fan_connector_screw_diameter = 2.8;
fan_connector_screw_height = 6;
fan_connector_leg_width = 4;
fan_connector_size = [
  // x:
  fan_hole_diameter + fan_connector_tolerance +
      fan_connector_wall_thickness * 2,
  // y:
  14.98,
  // z:
  fan_hole_diameter + fan_hole_margin + fan_connector_wall_thickness,
];

// Distance from the center of the base to the center of the fan connector.
fan_connector_distance = base_size.x / 2 - fan_hole_margin -
                         fan_hole_diameter / 2 - base_side_padding;

fan_connector_hole_size = [
  fan_connector_leg_width + fan_connector_hole_tolerance,
  fan_connector_size.z + fan_connector_hole_tolerance,
];

assert(fan_connector_leg_width > fan_connector_screw_diameter, "Fan adapter leg
width must be larger than the screw diameter");
assert(fan_connector_leg_width < fan_connector_size.x, "Fan adapter leg
width must be smaller than the fan adapter itself");

// ========================================
// BOTTOM LID

// The diameter of the bottom connector hole on the base itself, it's slightly
// larger so the screw passes smoothly.
bottom_connector_base_hole_diameter = 3.2;
bottom_connector_lid_hole_diameter = 2.8;

// Distance between the center of the screw hole and the bottom of the base.
bottom_connector_hole_distance = 5;

bottom_connector_wall_thickness = 3;

// The diameter of the hole for the screw in the tube.
bottom_lid_screw_tube_hole_diameter = 2.8;
bottom_lid_screw_tube_thickness = 2.8;
