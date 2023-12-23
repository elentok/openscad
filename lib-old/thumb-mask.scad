include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

module thumb_mask(width, height, rounding) {
  right(width / 2)
      rounded_corner_mask_2d(radius = rounding, anchor = LEFT + BACK);
  left(width / 2) mirror([ 1, 0, 0 ])
      rounded_corner_mask_2d(radius = rounding, anchor = LEFT + BACK);
  rect([ width, height ], rounding = [ 0, 0, rounding, rounding ],
       anchor = BACK);
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
