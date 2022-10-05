include <./variables.scad>
include <BOSL2/std.scad>

// module wheel() { tube(h = wheel_width, od = wheel_od, id = wheel_id); }
module wheel() { rotate_extrude() wheel_cut(); }

module wheel_cut() {
  rounded_tube(h = wheel_width, od = wheel_od - wheel_bump_height * 2, id = wheel_id,
               rounding = wheel_rounding);
}

module wheel_bumps() {
  for (i = [0:wheel_bumps - 1]) {
    rotate([ 0, 0, i * (wheel_bump_angle + wheel_slit_angle) ]) wheel_bump();
  }
}

module wheel_bump() {
  od = wheel_od - wheel_bump_height * 2;
  h = wheel_bump_height + wheel_thickness / 2;
  x = od / 2 - h + wheel_bump_height;
  rounding = [ wheel_bump_rounding, 0, 0, wheel_bump_rounding ];
  right(x) rotate([ 90, 0, 0 ]) linear_extrude(wheel_bump_width, center = true)
      rect([ h, wheel_width ], rounding = rounding, anchor = LEFT);
}

module wheel_bumps_2d() {
  for (i = [0:wheel_bumps - 1]) {
    angle = i * (wheel_bump_angle + wheel_slit_angle);
    rotate([ 0, 0, angle ]) wheel_slit_2d();
  }
}

module wheel_slit_2d() {
  slit_size = [ wheel_bump_height * 2, wheel_bump_width ];
  right(wheel_od / 2 - wheel_bump_height) rect(slit_size, anchor = LEFT);
}

module rounded_tube(h, od, id, rounding) {
  size = [ (od - id) / 2, h ];
  rounding_value = rounding == "auto" ? min(size.x, size.y) * 0.25 : rounding;
  right(id / 2) rect(size, rounding = rounding_value, anchor = LEFT);
}

wheel();
// wheel_bump();
wheel_bumps();

// debug
// #cylinder(d = wheel_od, h = wheel_width, center = true);
