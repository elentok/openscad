include <BOSL2/std.scad>
use <../../../lib/bottom_screw_head_mask.scad>
use <../knob/knob.scad>
$fn = 64;

epsilon = 0.01;

blade_length = 115;
blade_width = 17.83;
blade_width_with_tolerance = 20;
blade_thickness = 0.42;
blade_thickness_with_tolerance = 0.7;

blade_hole_diameter = 5.5;
blade_hole_tolerance = 0.5;
// distance from the bottom of the blade hole to the bottom of the blade.
blade_hole_dist_to_bottom = 14;

handle_screw_diameter = 3.3;
handle_screw_head_diameter = 5.8;
handle_screw_head_height = 2;
handle_support_height = 0.4;  // should match the print layer height

// For the fingers area on the handle
finger_width = 16;

padding = 4;
padding_x = 5;
rounding = 4;

// Because the blade is triangular at the end one side of the case is taller
// than the other one.
case_height_high = blade_length + padding * 2;
case_height_low = blade_length + padding - 10;
case_width = blade_width_with_tolerance + padding_x * 2;
case_thickness = blade_thickness_with_tolerance + padding * 2;

notch1_width = 10;
notch1_bottom = padding + blade_hole_dist_to_bottom / 2;
notch1_top = case_height_low - padding;

screw_cap_tolerance = 0.3;
screw_cap_size = notch1_width - screw_cap_tolerance;

notch2_outer_width = 11;
notch2_outer_height = notch1_top - notch1_bottom;
notch2_inner_width = blade_hole_diameter - blade_hole_tolerance;
notch2_inner_height =
    notch2_outer_height - (notch2_outer_width - notch2_inner_width);

module knife() {
  difference() {
    case_base();
    blade_mask();
    notch1_mask();
    notch2_mask();
    fingers_mask();
    thumb_mask();
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
  fwd(blade_thickness_with_tolerance / 2 - epsilon / 4) up(notch1_bottom)
      rotate([ 90, 0, 0 ]) {
    // inner notch
    linear_extrude(padding / 2, convexity = 4)
        back((notch2_outer_height - notch2_inner_height) / 2)
            rect([ notch2_inner_width, notch2_inner_height ],
                 rounding = notch2_inner_width / 2, anchor = FWD);

    // outer notch
    up(padding / 2 - epsilon / 2)
        linear_extrude(padding / 2 + epsilon, convexity = 4)
            rect([ notch2_outer_width, notch2_outer_height ],
                 rounding = notch2_outer_width / 2, anchor = FWD);
  }
}

module tolerance_test() {
  intersection() {
    knife();
    up(padding) cube([ case_width, case_thickness, 3 ], anchor = BOTTOM);
  }
}

// The cap that covers the screw that goes into notch1 and out of notch2.
module screw_cap() {
  base_height = padding;
  rod_height = blade_thickness_with_tolerance + padding / 3;
  difference() {
    union() {
      // base
      cube([ screw_cap_size, screw_cap_size, base_height ], anchor = BOTTOM);

      // rod
      up(padding - epsilon) cylinder(
          d = blade_hole_diameter - blade_hole_tolerance, h = rod_height);
    }

    // screw hole
    down(epsilon / 2) cylinder(d = handle_screw_diameter,
                               h = rod_height + base_height + epsilon);

    bottom_screw_head_mask(head_diameter = handle_screw_head_diameter,
                           head_height = handle_screw_head_height,
                           screw_diameter = handle_screw_diameter,
                           support_height = handle_support_height);
  }
}

module fingers_mask() {
  up(case_height_low * 0.35) left(case_width / 2 + 1) rotate([ 90, 0, 0 ])
      linear_extrude(case_thickness + epsilon, center = true)
          round2d(r = 3) for (i = [0:4]) {
    back(i * finger_width * 0.9) circle(d = finger_width, anchor = FWD + RIGHT);
  }
}

module thumb_mask() {
  up(case_height_low - finger_width * 2.5) right(case_width * 1.36)
      rotate([ 90, 0, 0 ])
          linear_extrude(case_thickness + epsilon, center = true)
              scale([ 1, 1.8, 1 ])
                  circle(d = finger_width * 2, anchor = FWD + RIGHT);
}

// fingers_mask();
// thumb_mask();
// notch2_mask();
// tolerance_test();
// knife();
screw_cap();

// knob(knob_height = 8, knob_diameter = 20, extension_height = padding,
//      extension_diameter = notch2_outer_width - 1, nut_size = "m3");
