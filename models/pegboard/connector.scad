// Helper component to connect two adjacent pegboards

use <BOSL2/std.scad>
use <pegboard.scad>
include <variables.scad>

connector_pins = [ 2, 2 ];
connector_size = pb_calc_board_size(connector_pins);

module connector() {
  linear_extrude(pb_thickness) board2d(connector_size);
  linear_extrude(pb_thickness * 3) holes2d(connector_size, connector_pins, pb_hole_diameter - 0.1);
}

connector();
