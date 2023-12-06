include <./shared.scad>
include <BOSL2/std.scad>
$fn = 64;

module magnetic_plate() {
  linear_extrude(mplate_size.z)
      rect([ mplate_size.x, mplate_size.y ], rounding = mplate_rounding);
}
