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

    translate(bolt_b1) {
      rotate([ 0, 0, 180 ])
          bolt_holder(hole = false, corner = "x", mask = true);
    }
    translate(bolt_b2) rotate([ 0, 0, 180 ])
        bolt_holder(hole = false, mask = true);
    translate(bolt_b3) rotate([ 0, 0, 180 + bolt_b3_angle ])
        bolt_holder(hole = false, mask = true);
  }
}

module wrist_rest_right() {
  back(32.7) left(277.8) up(39.5) rotate([ 180 + angle, 0, 0 ])
      import("original/Keebio_Iris_right_wrist_rest.stl");
}

wrist_rest_left();
// left_side();
