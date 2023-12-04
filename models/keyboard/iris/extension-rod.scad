include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

rod_h = 10;

d_base = 23;
d_ball = 15;

screw_d = 4.2;
screw_head_d = 10;
screw_head_h = 4;

ball_extra_height = 30;

module screwable_base() {
  difference() {
    union() {
      up(7.9 + 2 + rod_h) import("balljoint/Base_v3.stl");
      cyl(h = rod_h, d1 = d_ball, d2 = d_base, anchor = BOTTOM);
    }

    down(0.01) cyl(h = rod_h + 20, d = 4.2, anchor = BOTTOM);
    up(rod_h) cyl(h = screw_head_h, d = screw_head_d, anchor = BOTTOM);
  }
}

module extended_ball() {
  difference() {
    union() {
      down(20.9 / 2 + 1.6 - 0.01) import("balljoint/Ball_v3.stl");
      cyl(d = d_ball, h = ball_extra_height, anchor = BOTTOM);
    }
    up(ball_extra_height) screw_hole("M4", l = ball_extra_height + 0.01,
                                     anchor = TOP, thread = true);
  }
}

module extension_tube(h = 20) {
  tube(od = d_ball, id = 4.2, h = h, anchor = BOTTOM);
}

extension_tube(10);
// extended_ball();
// screwable_base();
