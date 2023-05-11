include <BOSL2/rounding.scad>
include <BOSL2/std.scad>
$fn = 64;

bit_diameter = 7;
bit_diameter_tolerance = 0.5;
bit_length = 20;

handle_n = 10;
handle_radius = 13;
handle_height = 30;
handle_space_height = 2;
handle_space_radius = 7;
handle_top_height = 5;
handle_bottom_height = handle_height - handle_top_height - handle_space_height;
handle_top_radius = 10;

handle_notches = 6;
handle_top_notch_radius = 2.5;
handle_bottom_notch_radius = 2;
handle_small_radius = 3;

module handle() {
  difference() {
    intersection() {
      handle_base1();
      handle_base2();
    }
    bit_mask();
  }
  // handle_base();
}

module handle_base1() {
  up(handle_top_height + handle_space_height) handle_notches(
      handle_bottom_height, handle_radius, handle_top_notch_radius);
  up(handle_top_height) cylinder(r = handle_radius, h = handle_space_height);
  handle_notches(handle_top_height, handle_top_radius,
                 handle_bottom_notch_radius);
}

module handle_notches(height, radius, notch_radius) {
  notch_angle = 360 / handle_notches;
  linear_extrude(height, convexity = 4) round2d(r = 2) difference() {
    circle(r = radius);
    for (i = [1:handle_notches]) {
      angle = (i - 1) * notch_angle;
      rotate([ 0, 0, angle ]) right(radius) circle(r = notch_radius);
    }
  }
}

module handle_base1b() {
  star = star(n = handle_n, or = handle_radius, ir = handle_radius * 0.8);
  rounded_star = round_corners(
      star, cut = 0.5);  //, cut = flatten(repeat([ .5, 0 ], 5)), $fn = 24);
  offset_sweep(rounded_star, height = handle_height, bottom = os_circle(r = 1),
               top = os_circle(r = 5), steps = 15);
}

module handle_base2() { rotate_extrude() handle_base2_section_2d(); }

module handle_base2_section_2d() {
  bottom_rounding = handle_radius * 0.7;

  rect([ handle_radius - bottom_rounding, handle_height ], anchor = FWD + LEFT);
  round2d(r = 2) {
    back(handle_top_height + handle_space_height)
        rect([ handle_radius, handle_bottom_height ], anchor = FWD + LEFT,
             rounding = [ bottom_rounding, 0, 0, bottom_rounding ]);

    back(handle_top_height)
        rect([ handle_space_radius, handle_space_height ], anchor = FWD + LEFT);

    rect([ handle_top_radius, handle_top_height ], anchor = FWD + LEFT,
         rounding = [ handle_top_height / 2, 0, 0, handle_top_height / 2 ]);
  }
}

module handle_base2_section_2d_old() {
  rect([ handle_radius / 2, handle_height ], anchor = FWD + LEFT);
  round2d(r = 2) difference() {
    rect([ handle_radius, handle_height ], anchor = FWD + LEFT,
         rounding = [ handle_radius / 2, 0, 0, 0 ]);
    back(handle_small_radius + handle_top_height) right(handle_radius)
        circle(r = handle_small_radius);
  }
}

module bit_mask() {
  linear_extrude(bit_length) hexagon(d = bit_diameter + bit_diameter_tolerance);
}

// handle_base2_section_2d();
handle();
