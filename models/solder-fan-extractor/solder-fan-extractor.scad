// See README.md file

include <BOSL2/std.scad>
$fn = 64;

include <./base.scad>
include <./fan-connector.scad>
include <./variables.scad>

// The control box has a bottom lid that connects with screws from the side.
bottom_lid_screw_hole_diameter = 3.2;
// Distance between the center of the screw hole and the bottom and the control
// box.
bottom_lid_screw_hole_distance = 5;

bottom_lid_screw_tube_wall_thickness = 3;

// The diameter of the hole for the screw in the tube
bottom_lid_screw_tube_hole_diameter = 2.8;
bottom_lid_screw_tube_thickness = 2.8;

// ========================================
// Fan adapter

module base_bottom_lid() {
  cuboid([ base_size.x, base_size.y, wall_thickness ], anchor = TOP);

#bottom_lid_screw_tube();
}

module bottom_lid_screw_tube() {
  size = [
    bottom_lid_screw_hole_distance + fan_connector_screw_diameter / 2 +
        wall_thickness,
    fan_connector_screw_diameter + wall_thickness * 2
  ];

  r = size.y / 2;

  difference() {
    rect(size, rounding = [ r, 0, 0, r ], anchor = LEFT);
    right(bottom_lid_screw_hole_distance)
        circle(d = fan_connector_screw_diameter);
  }
}

module demo(spacing) {
  color("#0fe038") base();
  color("#ca5aed") down(spacing) base_bottom_lid();

  color("#ffb100") up(base_size.z + spacing) {
    right(fan_connector_distance) fan_connector();
    left(fan_connector_distance) mirror([ 1, 0, 0 ]) fan_connector();
  }
}

// fan_connector();
demo(10);

// power_switch_mask(4);
// base_wall1();
// base_wall2();
// base();
// base_bottom_lid();
// left(20) base_fan_connector_test();
// base_fan_connector_test();
// fan_connector();
// fan_connector_2d();
