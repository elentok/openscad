include <./variables.scad>
include <BOSL2/std.scad>

// module wheel() { tube(h = wheel_width, od = wheel_od, id = wheel_id); }
module wheel() {
  rotate_extrude() wheel_cut();
  wheel_bumps();
}

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

module printable_wheel() {
  difference() {
    bottom_half() wheel();
    wheel_alignment_pin_socket();
    rotate(360 / 3) wheel_alignment_pin_socket();
    rotate(360 * 2 / 3) wheel_alignment_pin_socket();
  }

  back(wheel_od / 2 * 1.2) rotate([ 90, 90, 0 ]) alignment_pin(anchor = TOP + LEFT);
}

module wheel_alignment_pin_socket() {
  right(wheel_id / 2 + (wheel_thickness - alignment_pin_socket_size.x) / 2)
      alignment_pin_socket(anchor = LEFT);
}

module alignment_pin_socket(anchor) { cube(alignment_pin_socket_size, anchor = anchor); }
module alignment_pin(anchor) { cube(alignment_pin_size, anchor = anchor); }

wheel();
// printable_wheel();

// debug
// #cylinder(d = wheel_od, h = wheel_width, center = true);
