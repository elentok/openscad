use <BOSL2/std.scad>
include <variables.scad>

module mount(bar_width, rounding, thickness) {
  assert(bar_width >= pb_peg_diameter);

  mount_bar(bar_width, rounding, thickness);
  mount_top_peg();
  mount_bottom_peg();
}

module mount_bar(bar_width, rounding, thickness = pb_mount_thickness) {
  rounding = is_def(rounding) ? rounding : bar_width / 4;
  rotate([ 0, 90, 0 ]) linear_extrude(thickness, center = true)
      rect([ bar_width, pb_mount_height ], rounding = rounding);
}

module mount_top_peg() {
  y = pb_hole_spacing / 2;
  x0 = pb_mount_thickness / 2;
  x1 = x0 + pb_thickness;
  stroke([[x0, y, 0], [x1, y, 0], [x1 + 2, y + 2, 0]], width = pb_peg_diameter);

  // for debugging:
  // color("#00ff00") translate([ pb_thickness / 2 + pb_mount_thickness / 2, y, 0 ])
  //     cube([ pb_thickness, pb_peg_diameter, pb_peg_diameter ], center = true);
}

module mount_bottom_peg() {
  y = -pb_hole_spacing / 2;
  x0 = pb_mount_thickness / 2;
  x1 = x0 + pb_thickness;
  stroke([[x0, y, 0], [x1, y, 0], [x1 + 0.5, y - 0.7, 0]], width = pb_peg_diameter);
}

mount(bar_width = 5);
