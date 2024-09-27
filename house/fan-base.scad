include <BOSL2/std.scad>
$fn = 128;

base_d = 110;
base_thickness = 3;

fan_grip_width = 58;
space_below_rod = 18;
space_above_rod = 5;
rod_d = 11.6;
rod_tolerance = 0.4;

grip_r = space_below_rod + rod_d + space_above_rod;
grip_thickness = 5;

rod_l = fan_grip_width + grip_thickness * 2;

echo("GRIP DIAMETER", grip_r * 2);

module base() {
  cyl(d = base_d, h = base_thickness, anchor = TOP);

  x = grip_thickness / 2 + fan_grip_width / 2;
  left(x) grip();
  right(x) mirror([ -1, 0, 0 ]) grip();
}

module grip() {
  rotate([ 0, 90, 0 ]) linear_extrude(grip_thickness, convexity = 4,
                                      center = true) difference() {
    circle(r = grip_r);
    rect([ grip_r, grip_r * 2 ], anchor = LEFT);
    left(rod_d / 2 + space_below_rod) circle(d = rod_d + rod_tolerance);
  }

  grip_wedge();
}

module grip_wedge() {
  left(grip_thickness / 2) rotate([ 0, 0, 90 ]) left(grip_r / 2)
      wedge(size = [ grip_r, 10, space_below_rod * 0.8 ]);
}

module rod() { cyl(d = rod_d, h = rod_l); }

// base();
rod();
// grip();
// grip_wedge();
