include <./variables.scad>
include <BOSL2/std.scad>

// ============================================================
// Wheel Variables
wheel_bump_rounding = 2;
wheel_bump_angle = 10;
wheel_bumps = 20;
wheel_bump_height = 1;

wheel_bumps_angle_sum = wheel_bumps * wheel_bump_angle;
wheel_slits_angle_sum = 360 - wheel_bumps_angle_sum;
wheel_slit_angle = wheel_slits_angle_sum / wheel_bumps;

// ============================================================
// Wheel Functions

function get_wheel_width(od) = od / 3;
function get_wheel_thickness(od) = od / 4;
function get_wheel_id(od) = od - get_wheel_thickness(od) * 2;
function get_wheel_rounding(od) = od / 10;

// a = wheel_bump_angle
// w = wheel_bump_width
// r = wheel_od / 2
// sin(a/2) = (w/2) / (wheel_od/2)
//   => w/2 = (wheel_od/2) * sin(a/2)
//   => w = wheel_od * sin(a/2)
function get_wheel_bump_width(od) = od * sin(wheel_bump_angle / 2);

module wheel(od, anchor, spin, orient) {
  attachable(anchor, spin, orient, d = od, l = get_wheel_width(od)) {
    union() {
      rotate_extrude() wheel_cut(od);
      wheel_bumps(od);
    }
    children();
  }
}

module wheel_cut(od) {
  rounded_tube(h = get_wheel_width(od), od = od - wheel_bump_height * 2,
               id = get_wheel_id(od), rounding = get_wheel_rounding(od));
}

module wheel_bumps(od) {
  for (i = [0:wheel_bumps - 1]) {
    rotate([ 0, 0, i * (wheel_bump_angle + wheel_slit_angle) ]) wheel_bump(od);
  }
}

module wheel_bump(od) {
  d_minus_bump = od - wheel_bump_height * 2;
  h = wheel_bump_height + get_wheel_thickness(od) / 2;
  x = d_minus_bump / 2 - h + wheel_bump_height;
  rounding = [ wheel_bump_rounding, 0, 0, wheel_bump_rounding ];
  right(x) rotate([ 90, 0, 0 ])
      linear_extrude(get_wheel_bump_width(od), center = true)
          rect([ h, get_wheel_width(od) ], rounding = rounding, anchor = LEFT);
}

module wheel_bumps_2d() {
  for (i = [0:wheel_bumps - 1]) {
    angle = i * (wheel_bump_angle + wheel_slit_angle);
    rotate([ 0, 0, angle ]) wheel_slit_2d();
  }
}

module wheel_slit_2d(od) {
  slit_size = [ wheel_bump_height * 2, get_wheel_bump_width(od) ];
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

  back(wheel_od / 2 * 1.2) rotate([ 90, 90, 0 ])
      alignment_pin(anchor = TOP + LEFT);
}

module wheel_alignment_pin_socket() {
  right(wheel_id / 2 + (wheel_thickness - alignment_pin_socket_size.x) / 2)
      alignment_pin_socket(anchor = LEFT);
}

module alignment_pin_socket(anchor) {
  cube(alignment_pin_socket_size, anchor = anchor);
}
module alignment_pin(anchor) { cube(alignment_pin_size, anchor = anchor); }

zdistribute(spacing = 20) {
  wheel(od = 40);
  wheel(od = 20);
}

// debug
// #cylinder(d = wheel_od, h = wheel_width, center = true);
