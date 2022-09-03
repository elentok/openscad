include <BOSL2/std.scad>
include <variables.scad>

module mount(bar_width) {
  assert(bar_width >= pb_peg_diameter);

  mount_bar(bar_width);
  mount_top_peg();
  mount_bottom_peg();
}

module mount_bar(bar_width) {
  rotate([ 0, 90, 0 ]) linear_extrude(pb_mount_thickness, center = true)
      rect([ bar_width, pb_mount_height ], rounding = pb_mount_rounding);
}

module mount_top_peg() {
  radius = pb_wall_distance;
  right(pb_mount_thickness / 2) back(pb_peg_distance / 2 + radius) {
    rotate_extrude(angle = -90) right(radius) circle(d = pb_peg_diameter);
    right(radius) sphere(d = pb_peg_diameter);
  }
}

module mount_bottom_peg() {
  y = -pb_peg_distance / 2;
  x0 = pb_peg_radius;
  x1 = pb_thickness + pb_peg_radius;
  stroke([[x0, y, 0], [x1, y, 0], [x1 + 0.5, y - 0.5, 0]], width = pb_peg_diameter);
}

mount(bar_width = 5);
