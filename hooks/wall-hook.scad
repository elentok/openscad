include <BOSL2/std.scad>
// use <../../lib/chamfer.scad>
use <../lib-old/screw-hole-mask.scad>
$fn = 64;

epsilon = 0.01;
width = 20;
hanging_depth_space = 43;
wall_mount_height = 50;
wall_mount_thickness = 5;
bottom_thickness = 10;
tooth_height = 30;
tooth_thickness = 4;
rounding = 15;
rounding2 = 2;
screw_head_diameter = 8;

module hook() {
  difference() {
    rotate([ 90, 0, -90 ]) linear_extrude(width, center = true) hook2d();

    back(epsilon) up(bottom_thickness + hanging_depth_space / 2)
        screw_hole_mask(d_screw = 4, d_screw_head = screw_head_diameter,
                        l_wall = wall_mount_thickness + epsilon,
                        l_screwdriver = 0, l_countersink = 1, axis = BACK,
                        anchor = BACK + BOTTOM);
  }

  // #rotate([ 90, 0, -90 ])
  //   chamfered_hole(height = wall_mount_thickness, hole_diameter = 4.2,
  //                  chamfer_diameter = 8);
}

module hook2d() {
  round2d(rounding2) diff() {
    rect(
        [
          wall_mount_thickness + hanging_depth_space + tooth_thickness,
          wall_mount_height
        ],
        anchor = LEFT + FWD, rounding = [ 0, 0, 0, rounding ]) {
      tag("remove") right(wall_mount_thickness) back(epsilon)
          position(LEFT + BACK) rect(
              [ hanging_depth_space, wall_mount_height - bottom_thickness ],
              anchor = LEFT + BACK,
              rounding =
                  [ 0, 0, hanging_depth_space / 2, hanging_depth_space / 2 ]);

      tag("remove") translate([ epsilon / 2, epsilon / 2 ])
          position(RIGHT + BACK) rect(
              [
                tooth_thickness + epsilon,
                wall_mount_height - bottom_thickness - tooth_height +
                epsilon
              ],
              anchor = RIGHT + BACK);
    }
  }
}

hook();

// dd = 40;
// #fwd(hanging_depth_space / 2 + wall_mount_thickness)
// up(dd / 2 + bottom_thickness) rotate([ 0, 90, 0 ]) cyl(d = dd, h = 100);
