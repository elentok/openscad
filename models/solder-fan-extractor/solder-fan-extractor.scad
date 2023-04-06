// See README.md file

include <./base.scad>
include <./bottom-lid.scad>
include <./fan-connector.scad>
include <./variables.scad>
include <BOSL2/std.scad>

module demo(spacing) {
  color("#0fe038") base();
  color("#ca5aed") down(spacing) bottom_lid();

  color("#ffb100") up(base_size.z + spacing) {
    right(fan_connector_distance) fan_connector();
    left(fan_connector_distance) mirror([ 1, 0, 0 ]) fan_connector();
  }
}

// fan_connector();
demo(10);

// bottom_lid_connector(anchor = BOTTOM + LEFT);
// bottom_lid();

// power_switch_mask(4);
// base_wall1();
// base_wall2();
// base();
// base_bottom_lid();
// left(20) base_fan_connector_test();
// base_fan_connector_test();
// fan_connector();
// fan_connector_2d();
