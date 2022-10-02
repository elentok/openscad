
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

module leg_screw_hole() {
  // In the wrist rest I don't need the screw head to go all the way in.
  screw_head_height = 0.5;
  screw_body_height = wrist_rest_bottom_thickness - screw_head_height;

  down(nothing / 2) union() {
    // screw body
    cylinder(d = leg_screw_hole_diameter, h = screw_body_height + nothing);
    // screw head
    up(screw_body_height) cylinder(d = leg_screw_head_diameter, h = screw_head_height + nothing);
  }
}

wrist_rest();
