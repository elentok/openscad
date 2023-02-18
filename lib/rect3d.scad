include <BOSL2/std.scad>
$fn = 64;

// Custom attachable object (cube with rounded corners).
module rect3d(size, rounding, anchor = CENTER, spin = 0, orient = UP) {
  attachable(anchor, spin, orient, size = size) {
    linear_extrude(size.z, center = true) rect(size, rounding = rounding);
    children();
  }
}
