include <BOSL2/std.scad>
$fn = 64;

module bin(size, wall_thickness, rounding = 0, anchor = CENTER, spin = 0,
           orient = UP) {
  attachable(anchor, spin, orient, size = size) {
    inner_rounding = is_list(rounding) ? [
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
    }

    children();
  }
}
