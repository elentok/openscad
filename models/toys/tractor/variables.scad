// vim: foldmethod=marker

$fn = 64;

nothing = 0.1;

// Wheel {{{1
wheel_od = 60;
wheel_id = 38;
wheel_width = 30;
wheel_rounding = 4;
wheel_thickness = (wheel_od - wheel_id) / 2;

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
