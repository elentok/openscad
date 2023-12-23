include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

module screw_hole_mask(d_screw, d_screw_head, l_wall, l_screwdriver = 0,
                       d_screwdriver = 10, l_countersink = 0, axis = BACK,
                       anchor = CENTER, spin = 0) {
  rotate_angle = axis == FWD     ? [ 90, 0, 180 ]
                 : axis == BACK  ? [ 90, 0, 0 ]
                 : axis == RIGHT ? [ 0, 90, 0 ]
                 : axis == LEFT  ? [ 0, 90, 180 ]
                 : axis == UP    ? [ 0, 0, 0 ]
                                 : [ 0, 180, 0 ];
  l = l_wall + l_screwdriver;
  attachable(d = max(d_screw, d_screwdriver), l = l, axis = axis,
             anchor = anchor, spin = 0) {
    rotate(rotate_angle) down(l / 2) union() {
      cylinder(d = d_screw, h = l_wall + epsilon);
      if (l_countersink > 0) {
        up(l_wall - l_countersink)
            cylinder(d1 = d_screw,
                     d2 = is_def(d_screw_head) ? d_screw_head : d_screw + 4,
                     h = l_countersink + epsilon);
      }
      if (l_screwdriver > 0) {
        up(l_wall + epsilon) cylinder(d = d_screwdriver, h = l_screwdriver);
      }
    }
    children();
  }
}
