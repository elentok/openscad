include <screw-sizes.scad>

epsilon = 0.01;

module nut_mask(type, align_side = LEFT, anchor = CENTER) {
  d = nut_d(type);
  h = nut_h(type);
  attachable(d=d, h=h, anchor) {
    linear_extrude(h, convexity=4, center=true) hexagon(d=d, align_side=align_side);
    children();
  }
}

module screw_hole_mask(type, h, anchor) {
  cyl(d=screw_hole_d(type), h=h, anchor=anchor);
}

module screw_hole_mask2d(type) { circle(d=screw_hole_d(type)); }

// max_countersink_leftover: leave at least 1mm of non counterinksed wall
module screw_hole_maskx(
  screw_type,
  l_wall,
  l_screwdriver = 0,
  d_screwdriver = 10,
  countersink = false,
  max_countersink_leftover = 1,
  axis = BACK,
  anchor = CENTER,
  spin = 0
) {
  d_screw = screw_hole_d(screw_type);
  d_head = screw_head_d(screw_type);

  rotate_angle =
    axis == FWD ? [90, 0, 180]
    : axis == BACK ? [90, 0, 0]
    : axis == RIGHT ? [0, 90, 0]
    : axis == LEFT ? [0, 90, 180]
    : axis == UP ? [0, 0, 0]
    : [0, 180, 0];
  l = l_wall + l_screwdriver;
  attachable(
    d=max(d_screw, d_screwdriver), l=l, axis=axis,
    anchor=anchor, spin=0
  ) {
    rotate(rotate_angle) down(l / 2) union() {
          down(epsilon / 2) cylinder(d=d_screw, h=l_wall + epsilon);
          if (countersink) {
            h_head = screw_head_h(screw_type);
            l_countersink = min(h_head, l_wall - max_countersink_leftover);
            up(l_wall - l_countersink)
              cylinder(d1=d_screw, d2=d_head, h=l_countersink + epsilon);
          }
          if (l_screwdriver > 0) {
            up(l_wall + epsilon) cylinder(d=d_screwdriver, h=l_screwdriver);
          }
        }
    children();
  }
}
