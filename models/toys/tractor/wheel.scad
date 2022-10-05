include <./variables.scad>
include <BOSL2/std.scad>

// module wheel() { tube(h = wheel_width, od = wheel_od, id = wheel_id); }
module wheel() { rotate_extrude() wheel_cut(); }

module wheel_cut() {
  rounded_tube(h = wheel_width, od = wheel_od, id = wheel_id, rounding = wheel_rounding);
}

module wheel_slits() {
  linear_extrude(wheel_width, center = true) wheel_slits_2d();
  // slit_angle = 360 / wheel_slits;
  // echo("WHEEL SLITS", wheel_slits);
  // for (i = [0:wheel_slits / 2 - 1]) {
  //   echo("FOR", i);
  //   rotate([ 0, 0, slit_angle * i * 2 ]) wheel_slit(slit_angle);
  // }
}

module wheel_slit(angle) {
  rotate_extrude(angle = angle) right(wheel_od / 2 - wheel_bump_height)
      rect([ wheel_bump_height * 2, wheel_width + nothing ], anchor = LEFT);
}
module wheel_slits_2d() {
  // slit_width = 360 / wheel_slits;
  // back(wheel_od / 2 - wheel_bump_height) rect([ wheel_width, wheel_bump_height * 2 ], anchor =
  // FRONT);

  // right(wheel_od / 2 - wheel_bump_height) rect([ wheel_bump_height * 2, wheel_width ], anchor =
  // LEFT);

  for (i = [0:wheel_bumps - 1]) {
    angle = i * (wheel_bump_angle + wheel_slit_angle);
    rotate([ 0, 0, angle ]) wheel_slit_2d();
  }

  // back(wheel_od / 2 - wheel_bump_height) rect([ slit_width, wheel_bump_height * 2 ], anchor =
  // FRONT);
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

// wheel_cut();
// wheel();
// wheel_bumps();
// #wheel_slits_2d();

union() {
  wheel();
#wheel_slits();
}

// debug
// #cylinder(d = wheel_od, h = wheel_width, center = true);
