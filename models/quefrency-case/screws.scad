
include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module leg_screw_hole() {
  // In the wrist rest I don't need the screw head to go all the way in.
  screw_head_height = 0.5;
  screw_body_height = wrist_rest_bottom_thickness - screw_head_height;

  down(nothing / 2) union() {
    // screw body
    cylinder(d = leg_screw_hole_diameter, h = screw_body_height + nothing);
    // screw head
    up(screw_body_height) cylinder(d = leg_screw_head_diameter, h = screw_head_height + nothing);
  }
}
