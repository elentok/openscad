include <../../../lib/screw-hole-mask.scad>
include <BOSL2/std.scad>
$fn = 64;

size = [ 100, 60, 15 ];
thickness = 3;

module extension() {
  // top
  linear_extrude(thickness) rect([ size.x, size.y - thickness ],
                                 rounding = [ 10, 10, 0, 0 ], anchor = FWD);

  back_panel();

  support_triangle();
  left(size.x / 2 - thickness / 2) support_triangle();
  right(size.x / 2 - thickness / 2) support_triangle();
}

module back_panel() {
  difference() {
    up(thickness) rotate([ 90, 0, 0 ]) linear_extrude(thickness)
        rect([ size.x, size.z ], anchor = BACK);

    left(size.x / 8) screw_mask();
    left(size.x * 3 / 8) screw_mask();
    right(size.x / 8) screw_mask();
    right(size.x * 3 / 8) screw_mask();
  }
}

module screw_mask() {
  back(0.01) down(size.z / 2 - thickness)
      screw_hole_mask(d_screw = 4.2, d_screw_head = 8, l_countersink = 1,
                      l_wall = thickness + 0.02, anchor = BACK, axis = FWD);
}

module support_triangle() {
  rotate([ 0, 89, 0 ]) linear_extrude(thickness, center = true)
      right_triangle(size = [ size.z - thickness, size.y * 0.7 ],
                     anchor = FWD + LEFT, spin = 0);
}

extension();
