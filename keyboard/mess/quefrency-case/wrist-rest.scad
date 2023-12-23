include <./screws.scad>
include <./variables.scad>
include <BOSL2/std.scad>
use <./foot.scad>
$fn = 64;

module wrist_rest() {
  hole_x = wrist_rest_size.x / 2 - wrist_rest_foot_screw_dist_from_edge;
  hole_y = wrist_rest_size.y / 2 - wrist_rest_foot_screw_dist_from_edge;

  difference() {
    union() {
      // Bottom
      linear_extrude(wrist_rest_bottom_thickness, convexity = 4)
          rect(wrist_rest_size, rounding = wrist_pillow_rounding);

      // Border
      up(wrist_rest_bottom_thickness) linear_extrude(wrist_rest_border_height)
          shell2d(-wrist_rest_border_thickness)
              rect(wrist_rest_size, rounding = wrist_pillow_rounding);

      // Spacers
      wrist_rest_spacer();
      left(hole_x) wrist_rest_spacer();
      right(hole_x) wrist_rest_spacer();

      back(hole_y) {
        wrist_rest_spacer();
        left(hole_x) wrist_rest_spacer();
        right(hole_x) wrist_rest_spacer();
      }
      fwd(hole_y) {
        wrist_rest_spacer();
        left(hole_x) wrist_rest_spacer();
        right(hole_x) wrist_rest_spacer();
      }
    }

    down(nothing / 2) {
      back(hole_y) {
        left(hole_x) wrist_rest_foot_hole_and_nut();
        right(hole_x) wrist_rest_foot_hole_and_nut();
      }
      fwd(hole_y) {
        left(hole_x) wrist_rest_foot_hole_and_nut();
        right(hole_x) wrist_rest_foot_hole_and_nut();
      }
    }
  }
}

module wrist_rest_foot_hole_and_nut() {
  h = wrist_rest_bottom_thickness + wrist_rest_spacers_height;
  cylinder(d = foot_screw_hole_diameter, h = h + nothing * 2);

  up(h - wrist_rest_foot_nut_height + nothing * 2) linear_extrude(
      wrist_rest_foot_nut_height, convexity = 4) hexagon(d = foot_nut_diameter);

  echo("Wrist rest foot nut height: ", wrist_rest_foot_nut_height);
  echo("Wrist rest bottom thickness below the nut: ",
       h - wrist_rest_foot_nut_height);
}

module wrist_rest_spacer() {
  cylinder(d = wrist_rest_spacers_diameter,
           h = wrist_rest_bottom_thickness + wrist_rest_spacers_height,
           anchor = BOTTOM);
}

wrist_rest();
