include <./shared.scad>
include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

angle = 7;

module wrist_rest_left_original() {
  back(32.7) right(27.8) up(39.5) rotate([ 180 + angle, 0, 0 ])
      import("original/Keebio_Iris_left_wrist_rest.stl");
}

module wrist_rest_left() {
  difference() {
    wrist_rest_left_original();

    translate(bolt_mid1) {
      rotate([ 0, 0, 180 ])
          bolt_holder(hole = false, corner = "x", mask = true);
      screw_hole(bolt_spec, l = case_h - 2, thread = !fast_render,
                 anchor = BOTTOM);
    }
    translate(bolt_mid2) {
      rotate([ 0, 0, 180 ]) bolt_holder(hole = false, mask = true);
      screw_hole(bolt_spec, l = case_h - 2, thread = !fast_render,
                 anchor = BOTTOM);
    }
    translate(bolt_mid3) {
      rotate([ 0, 0, 180 + bolt_mid3_angle ])
          bolt_holder(hole = false, mask = true);
      screw_hole(bolt_spec, l = case_h - 4, thread = !fast_render,
                 anchor = BOTTOM);
    }
    translate(bolt_b1) {
      screw_hole(bolt_spec, l = bolt_b1_h, thread = !fast_render,
                 anchor = BOTTOM);
    }
    translate(bolt_b2) {
      screw_hole(bolt_spec, l = bolt_b1_h, thread = !fast_render,
                 anchor = BOTTOM);
    }
  }
}

module wrist_rest_right() {
  back(32.7) left(277.8) up(39.5) rotate([ 180 + angle, 0, 0 ])
      import("original/Keebio_Iris_right_wrist_rest.stl");
}

wrist_rest_left();
// left_side();
