
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

    leg_screw_holes(wrist_rest_size, wrist_rest_bottom_thickness, screw_head_height = 0.5,
                    dist_from_corner = wrist_rest_tent_holes_dist_from_corner);
  }
}

wrist_rest();
