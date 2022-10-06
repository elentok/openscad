// vim: foldmethod=marker

include <BOSL2/std.scad>

$fn = 64;

nothing = 0.1;

// Wheel {{{1
wheel_od = 40;
// wheel_id = 20;
wheel_width = wheel_od / 3;
wheel_thickness = wheel_od / 4;
wheel_id = wheel_od - wheel_thickness * 2;
wheel_rounding = wheel_od / 10;
// wheel_thickness = (wheel_od - wheel_id) / 2;

// Wheel Bumps {{{1

wheel_bump_rounding = 2;
wheel_bump_angle = 10;
wheel_bumps = 20;
wheel_bump_height = 1;

wheel_bumps_angle_sum = wheel_bumps * wheel_bump_angle;
wheel_slits_angle_sum = 360 - wheel_bumps_angle_sum;
wheel_slit_angle = wheel_slits_angle_sum / wheel_bumps;

// a = wheel_bump_angle
// w = wheel_bump_width
// r = wheel_od / 2
// sin(a/2) = (w/2) / (wheel_od/2)
//   => w/2 = (wheel_od/2) * sin(a/2)
//   => w = wheel_od * sin(a/2)
wheel_bump_width = wheel_od * sin(wheel_bump_angle / 2);

// Alignment Pin {{{1

alignment_pin_size = [ 2, 4, 8 ];
alignment_pin_tolerance = 0.2;
alignment_pin_socket_size = add_scalar(alignment_pin_size, alignment_pin_tolerance);
