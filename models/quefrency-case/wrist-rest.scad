
include <./screws.scad>
include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module wrist_rest() {
  difference() {
    union() {
      // Bottom
      linear_extrude(wrist_rest_bottom_thickness)
          rect(wrist_rest_size, rounding = wrist_pillow_rounding);

      // Border
      up(wrist_rest_bottom_thickness) linear_extrude(wrist_rest_border_height)
          shell2d(-wrist_rest_border_thickness)
              rect(wrist_rest_size, rounding = wrist_pillow_rounding);
    }

    leg_screw_holes();
  }
}

module wrist_rest_bottom_2d() {
  difference() {
    // wrist_rest_leg_holes();
  }
}

module wrist_rest_leg_holes() {
  x_diff = wrist_rest_size.x / 2 - leg_hole_diameter / 2 - leg_hole_margin;
  y_diff = wrist_rest_size.y / 2 - leg_hole_diameter / 2 - leg_hole_margin;
  back(y_diff) {
    left(x_diff) circle(d = leg_hole_diameter);
    right(x_diff) circle(d = leg_hole_diameter);
  }
  fwd(y_diff) {
    left(x_diff) circle(d = leg_hole_diameter);
    right(x_diff) circle(d = leg_hole_diameter);
  }
}

module leg_screw_holes() {
  x_diff = wrist_rest_size.x / 2 - leg_hole_diameter / 2 - leg_hole_margin;
  y_diff = wrist_rest_size.y / 2 - leg_hole_diameter / 2 - leg_hole_margin;
  back(y_diff) {
    left(x_diff) leg_screw_hole();
    right(x_diff) leg_screw_hole();
  }
  fwd(y_diff) {
    left(x_diff) leg_screw_hole();
    right(x_diff) leg_screw_hole();
  }
}

wrist_rest();
