include <BOSL2/std.scad>
$fn = 64;

blade_length = 115;
blade_width = 17.83;
blade_width_with_tolerance = 18;
blade_thickness = 0.42;
blade_thickness_with_tolerance = 0.7;

padding = 5;
rounding = 5;

// Because the blade is triangular at the end one side of the case is taller
// than the other one.
case_height1 = blade_length + padding * 2;
case_height2 = blade_length + padding * 2 - 10;
case_width = blade_width_with_tolerance + padding * 2;
case_thickness = blade_thickness_with_tolerance + padding * 2;

module knife() {
  difference() {
    case_base();
    blade_mask();
  }
}

module case_base() {
  intersection() {
    rotate([ 90, 0, 0 ]) linear_extrude(case_thickness, center = true)
        case_side_view_2d();
    linear_extrude(case_height1, convexity = 4) case_top_view_2d();
  }
}

module case_top_view_2d() {
  rect([ case_width, case_thickness ], rounding = case_thickness / 2);
}

module case_side_view_2d() {
  round2d(r = rounding) {
    fwd(rounding)
        rect([ case_width, case_height2 + rounding ], anchor = BOTTOM);
    back(case_height2) right_triangle(
        [ case_width, case_height1 - case_height2 ], anchor = BOTTOM);
  }
}

module blade_mask() {
  up(padding) cube(
      [
        blade_width_with_tolerance, blade_thickness_with_tolerance,
        case_height1
      ],
      anchor = BOTTOM);
}

module tolerance_test() {
  intersection() {
    knife();
    up(padding) cube([ case_width, case_thickness, 3 ], anchor = BOTTOM);
  }
}

// tolerance_test();
knife();
