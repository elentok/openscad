include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

blade_length = 115;
blade_width = 17.83;
blade_width_with_tolerance = 20;
blade_thickness = 0.42;
blade_thickness_with_tolerance = 0.7;

blade_hole_diameter = 5.5;
// distance from the bottom of the blade hole to the bottom of the blade.
blade_hole_dist_to_bottom = 14;

padding = 4;
rounding = 4;

// Because the blade is triangular at the end one side of the case is taller
// than the other one.
case_height_high = blade_length + padding * 2;
case_height_low = blade_length + padding * 2 - 10;
case_width = blade_width_with_tolerance + padding * 2;
case_thickness = blade_thickness_with_tolerance + padding * 2;

notch1_width = 10;
notch1_bottom = padding + blade_hole_dist_to_bottom / 2;
notch1_top = case_height_low - padding;

module knife() {
  difference() {
    case_base();
    blade_mask();
    notch1_mask();
  }
}

module case_base() {
  intersection() {
    rotate([ 90, 0, 0 ]) linear_extrude(case_thickness, center = true)
        case_side_view_2d();
    linear_extrude(case_height_high, convexity = 4) case_top_view_2d();
  }
}

module case_top_view_2d() {
  rect([ case_width, case_thickness ], rounding = case_thickness / 2);
}

module case_side_view_2d() {
  round2d(r = rounding) {
    fwd(rounding)
        rect([ case_width, case_height_low + rounding ], anchor = BOTTOM);
    back(case_height_low) right_triangle(
        [ case_width, case_height_high - case_height_low ], anchor = BOTTOM);
  }
}

module blade_mask() {
  up(padding) cube(
      [
        blade_width_with_tolerance, blade_thickness_with_tolerance,
        case_height_high
      ],
      anchor = BOTTOM);
}

module notch1_mask() {
  up(notch1_bottom) cube(
      [
        notch1_width, padding + blade_thickness_with_tolerance / 2 + epsilon,
        (notch1_top - notch1_bottom)
      ],
      anchor = BOTTOM + FWD);
}

module notch2_mask() {
  // hello
}

module tolerance_test() {
  intersection() {
    knife();
    up(padding) cube([ case_width, case_thickness, 3 ], anchor = BOTTOM);
  }
}

// tolerance_test();
knife();
