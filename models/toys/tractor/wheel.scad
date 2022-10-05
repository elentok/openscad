include <./variables.scad>
include <BOSL2/std.scad>

// module wheel() { tube(h = wheel_width, od = wheel_od, id = wheel_id); }
module wheel() { rotate_extrude() wheel_cut(); }

module wheel_cut() {
  rounded_tube(h = wheel_width, od = wheel_od, id = wheel_id, rounding = wheel_rounding);
}

module rounded_tube(h, od, id, rounding) {
  size = [ (od - id) / 2, h ];
  rounding_value = rounding == "auto" ? min(size.x, size.y) * 0.25 : rounding;
  right(id / 2) rect(size, rounding = rounding_value, anchor = LEFT);
}

// wheel_cut();
wheel();

// debug
// #cylinder(d = wheel_od, h = wheel_width, center = true);
