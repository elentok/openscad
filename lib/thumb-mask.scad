include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

module thumb_mask(size, rounding, anchor) {
  size_with_corners = [ size.x + rounding * 2, size.y, size.z ];

  attachable(size = size_with_corners, anchor = anchor) {
    back(size.y / 2)
        linear_extrude(size.z, convexity = 4, center = true) union() {
      right(size.x / 2)
          rounded_corner_mask_2d(radius = rounding, anchor = LEFT + BACK);
      left(size.x / 2) mirror([ 1, 0, 0 ])
          rounded_corner_mask_2d(radius = rounding, anchor = LEFT + BACK);
      rect([ size.x, size.y ], rounding = [ 0, 0, rounding, rounding ],
           anchor = BACK);
    }

    children();
  }
}

module rounded_corner_mask_2d(radius, anchor = CENTER, spin = 0) {
  fwd(radius / 2) right(radius / 2)
      attachable(anchor, spin, two_d = true, path = rect([ radius, radius ])) {
    difference() {
      rect([ radius, radius ], anchor = RIGHT + FWD);
      circle(r = radius);
    }
    children();
  }
}

thumb_mask([ 20, 10, 25 ], rounding = 5, anchor = BACK);
