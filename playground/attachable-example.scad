include <BOSL2/std.scad>
$fn = 64;

nothing = 0.1;

// Custom attachable object (cube with rounded corners).
module rcube(size, rounding, anchor = CENTER, spin = 0, orient = UP) {
  attachable(anchor, spin, orient, size = size) {
    linear_extrude(size.z, center = true) rect(size, rounding = rounding);
    children();
  }
}

diff() {
  rcube([ 30, 60, 20 ], rounding = 5) {
    tag("remove") up(nothing / 2) union() {
      position(TOP + LEFT) cylinder(d = 5, h = 20 + nothing, anchor = TOP + LEFT);
      position(TOP + RIGHT) cylinder(d = 5, h = 20 + nothing, anchor = TOP + RIGHT);
      position(TOP + BACK) cylinder(d = 8, h = 20 + nothing, anchor = TOP + BACK);
      position(TOP + FRONT) cylinder(d = 8, h = 20 + nothing, anchor = TOP + FRONT);
    }
  }
}
