include <screw-sizes.scad>

module nut_mask(type, align_side = LEFT, anchor = CENTER) {
  d = nut_d(type);
  h = nut_h(type);
  attachable(d = d, h = h, anchor) {
    linear_extrude(h, convexity = 4) hexagon(d = d, align_side = align_side);
    children();
  }
}

module screw_hole_mask(type, h, anchor) {
  cyl(d = screw_hole_d(type), h = h, anchor = anchor);
}

module screw_hole_mask2d(type) { circle(d = screw_hole_d(type)); }
