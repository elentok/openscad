include <BOSL2/std.scad>
$fn = 64;

module bin(size, wall_thickness, rounding = 0, irounding = undef,
           anchor = CENTER, spin = 0, orient = UP, strengtheners = false) {
  attachable(anchor, spin, orient, size = size) {
    inner_rounding = is_def(irounding) ? irounding : is_list(rounding) ? [
      max(0, rounding[0] - wall_thickness),
      max(0, rounding[1] - wall_thickness),
      max(0, rounding[2] - wall_thickness),
      max(0, rounding[3] - wall_thickness),
    ] : max(0, rounding - wall_thickness);

    down(size.z / 2) {
      // floor
      linear_extrude(wall_thickness, convexity = 4)
          rect(size = [ size.x, size.y ], rounding = rounding);

      // walls
      rect_tube(h = size.z, size = [ size.x, size.y ], wall = wall_thickness,
                rounding = rounding, irounding = inner_rounding);

      if (strengtheners) {
        right(size.x / 2) strengthener(4, size.y / 2);
        mirror([ 1, 0, 0 ]) right(size.x / 2) strengthener(4, size.y / 2);

        rotate([ 0, 0, 90 ]) {
          right(size.y / 2) strengthener(4, size.y / 2);
          mirror([ 1, 0, 0 ]) right(size.y / 2) strengthener(4, size.y / 2);
        }
      }
    }

    children();
  }
}

module strengthener(r, w) {
  left(r + wall_thickness) up(r + wall_thickness - 0.01) rotate([ 90, 0, 0 ])
      linear_extrude(w, center = true) difference() {
    rect([ r, r ], anchor = LEFT + BACK);
    circle(r = r);
  }
}
