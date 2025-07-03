include <BOSL2/std.scad>

// Rounded rectangular mask (as a negative rounded corner)
module rounded_rect_mask(size, h, rounding) {
  cuboid([size.x, size.y, h], anchor=BOTTOM, rounding=rounding, except=[TOP, BOTTOM]);
  up(h) _negative_3d_roundover([size.x, size.y, rounding], positive_rounding=rounding);
}

module _negative_3d_roundover(size, positive_rounding = 0) {
  back(size.y / 2) left(size.x / 2) {
      _negative_3d_roundover_side(size, positive_rounding);
      fwd(size.y) mirror([0, 1, 0]) _negative_3d_roundover_side(size, positive_rounding);

      fwd(positive_rounding) mirror([0, 1, 0]) rotate([0, 0, 90]) _negative_3d_roundover_edge(size.y, size.z, positive_rounding);
      fwd(positive_rounding) right(size.x) mirror([1, 0, 0]) mirror([0, 1, 0]) rotate([0, 0, 90]) _negative_3d_roundover_edge(size.y, size.z, positive_rounding);
    }
}

module _negative_3d_roundover_side(size, positive_rounding) {
  fwd(positive_rounding) right(positive_rounding) mirror([1, 0, 0]) _negative_3d_roundover_corner(size, positive_rounding);
  fwd(positive_rounding) right(size.x - positive_rounding) _negative_3d_roundover_corner(size, positive_rounding);
  right(positive_rounding) _negative_3d_roundover_edge(size.x, size.z, positive_rounding);
}

module _negative_3d_roundover_corner(size, positive_rounding) {
  mirror([0, 0, 1]) rotate_extrude(angle=90) right(positive_rounding) mask2d_roundover(r=size.z, excess=0);
}

module _negative_3d_roundover_edge(w, h, positive_rounding) {
  rotate([0, 90, 0]) linear_extrude(w - positive_rounding * 2) mask2d_roundover(r=h, excess=0);
}
