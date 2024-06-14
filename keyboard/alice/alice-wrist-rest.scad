include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;
palm_rest_angle = 3;
palm_rest_rounding_side = 20;
palm_rest_rounding_top = 3;
palm_rest_z_back = 21;
// Mark 1 was 100mm, it's too long by 30mm
palm_rest_y = 80;
width = 130;
foot_d = 18;

module palm_rest() {
  difference() {
    palm_rest_base();

    down(epsilon) {
      x_back = width / 2 - foot_d / 2;
      left(x_back) fwd(foot_d / 2) screw_hole_mask();
      right(x_back) fwd(foot_d / 2) screw_hole_mask();

      y = palm_rest_y - foot_d / 2;
      x_fwd = width / 2 - palm_rest_rounding_side;
      left(x_fwd) fwd(y) screw_hole_mask();
      right(x_fwd) fwd(y) screw_hole_mask();
    }
  }
}

module screw_hole_mask() {
  screw_hole("M5", l = 8, thread = true, anchor = BOTTOM);
}

module palm_rest_base() {
  crop_back = sin(palm_rest_angle) * palm_rest_z_back;

  left(width / 2) front_half(width * 2 + epsilon)
      top_half(width * 2 + epsilon) {
    back(crop_back) rotate([ palm_rest_angle, 0, 0 ]) { palm_rest_base1(); }
  }
}

module palm_rest_base1() {
  hull() {
    cuboid([ width, 6, palm_rest_z_back ], anchor = BACK + BOTTOM + LEFT,
           chamfer = palm_rest_rounding_top, except = BOTTOM);
    // chamfer = palm_rest_rounding_top, except = [ BACK, BOTTOM ]);

    fwd(palm_rest_y - palm_rest_rounding_side) {
      cyl(r = palm_rest_rounding_side, h = palm_rest_z_back,
          chamfer2 = palm_rest_rounding_top, anchor = BOTTOM + LEFT);
      right(width)
          cyl(r = palm_rest_rounding_side, h = palm_rest_z_back,
              chamfer2 = palm_rest_rounding_top, anchor = BOTTOM + RIGHT);
    }
  }
}

palm_rest();
// palm_rest_base1();
