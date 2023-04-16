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

      // cylinders to give the screws more space to latch on
      back(hole_y) {
        left(hole_x) cylinder(d = foot_od, h = foot_extender_thread_height,
                              anchor = BOTTOM);
        right(hole_x) cylinder(d = foot_od, h = foot_extender_thread_height,
                               anchor = BOTTOM);
      }
      fwd(hole_y) {
        left(hole_x) cylinder(d = foot_od, h = foot_extender_thread_height,
                              anchor = BOTTOM);
        right(hole_x) cylinder(d = foot_od, h = foot_extender_thread_height,
                               anchor = BOTTOM);
      }
    }

    down(nothing / 2) {
      back(hole_y) {
        left(hole_x) foot_thread_mask(h = foot_extender_thread_height + nothing,
                                      anchor = BOTTOM);
        right(hole_x) foot_thread_mask(
            h = foot_extender_thread_height + nothing, anchor = BOTTOM);
      }
      fwd(hole_y) {
        left(hole_x) foot_thread_mask(h = foot_extender_thread_height + nothing,
                                      anchor = BOTTOM);
        right(hole_x) foot_thread_mask(
            h = foot_extender_thread_height + nothing, anchor = BOTTOM);
      }
    }

    // leg_screw_holes(
    //     wrist_rest_size, wrist_rest_bottom_thickness, screw_head_height =
    //     0.5, x_offset_from_edge =
    //     wrist_rest_tent_hole_center_x_offset_from_edge, y_offset_from_edge =
    //     wrist_rest_tent_hole_center_y_offset_from_edge);
  }
}

wrist_rest();
