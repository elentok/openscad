include <BOSL2/std.scad>
include <../lib/screw-masks.scad>
$fn = 64;

d_hole = 11;

// the height of the part of the case that comes out of the bottom (on which the foot sits)
h_inset = 3;

// grip_size = 1;

h_hug = 2;
hug_tolerance = 0.6;

h_nut_wrapper = nut_h("m4") + h_hug + 1;

h_foot = 16;

h_total = h_foot + h_nut_wrapper;

h_screw_without_head = 11;
h_screw_head_mask = h_total - h_screw_without_head;

d_screw_hole = screw_hole_d("m4") + 0.5;

echo("Nut wrapper height", h_nut_wrapper);
echo("Total height", h_total);
echo("Screw head mask height", h_screw_head_mask);

module foot() {
  difference() {
    union() {

      difference() {
        cyl(d=28, h=h_foot, anchor=TOP, rounding1=2);
        up(0.01) cyl(d1=19, d2=26, h=h_inset, rounding1=1, rounding2=-1, anchor=TOP);
      }

      // down(h_inset) linear_extrude(h=h_inset + h_hug - hug_tolerance, convexity=4) round2d(1) hexagon(d=d_hole);
      down(h_inset) cyl(d=d_hole, h=h_inset + h_hug - hug_tolerance, anchor=BOTTOM);
    }

    up(h_hug + 0.01) cyl(d=d_screw_hole, h=h_foot + h_hug + 0.02, anchor=TOP);
    down(h_foot + 0.01) cyl(d=screw_head_d("m5"), h=h_screw_head_mask, anchor=BOTTOM, rounding1=-2, rounding2=1);
  }

  // supports
  tube(id=d_screw_hole, wall=0.2, h=h_foot, anchor=TOP);
}

module nut() {
  difference() {
    down(h_nut_wrapper) linear_extrude(h=h_nut_wrapper, convexity=4) round2d(r=2) hexagon(d=26);
    up(0.01) nut_mask("m4", anchor=TOP);
    cyl(d=d_screw_hole, h=h_nut_wrapper + 0.01, anchor=TOP);
    down(h_nut_wrapper + 0.01) cyl(d=d_hole + 0.4, h=h_hug, anchor=BOTTOM);
    // down(h_nut_wrapper + 0.01) linear_extrude(h_hug) hexagon(d=d_hole + 0.4);
  }

  // supports
  down(h_nut_wrapper) tube(id=d_screw_hole, wall=0.2, h=h_hug, anchor=BOTTOM);
}

module rect_nut() {
  difference() {
    // down(h_nut_wrapper) linear_extrude(h=h_nut_wrapper, convexity=4) round2d(r=2) hexagon(d=26);
    cuboid([26, d_hole + 2, h_nut_wrapper], anchor=TOP, rounding=1);
    up(0.01) nut_mask("m4", anchor=TOP, align_side=BACK);
    cyl(d=d_screw_hole, h=h_nut_wrapper + 0.01, anchor=TOP);
    down(h_nut_wrapper + 0.01) cyl(d=d_hole + 0.4, h=h_hug, anchor=BOTTOM);
    // down(h_nut_wrapper + 0.01) linear_extrude(h_hug) hexagon(d=d_hole + 0.4);
  }

  // supports
  down(h_nut_wrapper) tube(id=d_screw_hole, wall=0.2, h=h_hug, anchor=BOTTOM);
}

rect_nut();
// nut();
// foot();

// #cyl(d=screw_head_d("m4"), h=9, anchor=BOTTOM);
