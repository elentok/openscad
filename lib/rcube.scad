include <BOSL2/std.scad>
$fn = 64;

// Rounded cube, with different rounding for the sides and for the top and bottom
module rcube(size, rounding_sides, rounding_top = 0, rounding_bottom = 0, anchor) {
  assert(
    abs(rounding_top) + abs(rounding_bottom) <= size.z,
    "Cube must be taller than the absolute top rounding and absolute bottom rounding"
  );

  assert(
    size.x >= rounding_sides / 2,
    "Cube X-axis size must be greater or equal to twice the rounding"
  );

  assert(
    size.y >= rounding_sides / 2,
    "Cube Y-axis size must be greater or equal to twice the rounding"
  );

  x = size.x / 2 - rounding_sides;
  y = size.y / 2 - rounding_sides;
  // hull() {

  dx = size.x - rounding_sides * 2;
  dy = size.y - rounding_sides * 2;

  h_top = size.z - abs(rounding_bottom);
  h_bottom = abs(rounding_bottom);

  attachable(size=size, anchor) {
    down(size.z / 2) union() {

        // Fill X-axis between two corners
        if (dx > 0) {
          up(h_bottom) cuboid([dx, size.y, h_top], rounding=rounding_top, edges=TOP, except_edges=[LEFT, RIGHT], anchor=BOTTOM);
          cuboid([dx, size.y, h_bottom], rounding=rounding_bottom, edges=BOTTOM, except_edges=[LEFT, RIGHT], anchor=BOTTOM);
        }

        // Fill X-axis between two corners
        if (dy > 0) {
          up(h_bottom) cuboid([size.x, dy, h_top], rounding=rounding_top, edges=TOP, except_edges=[BACK, FWD], anchor=BOTTOM);
          cuboid([size.x, dy, h_bottom], rounding=rounding_bottom, edges=BOTTOM, except_edges=[BACK, FWD], anchor=BOTTOM);
        }

        // Corners
        left(x) back(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
        right(x) back(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
        left(x) fwd(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
        right(x) fwd(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
      }
    children();
  }
}

// Demo
// rcube([100, 50, 5], rounding_sides=10, rounding_top=-2, rounding_bottom=1);
// rcube([100, 50, 5], rounding_sides=10, rounding_top=3, rounding_bottom=1);
// rcube([100, 50, 5], rounding_sides=10, rounding_top=3, anchor=BOTTOM);
// rcube([100, 50, 5], rounding_sides=10, rounding_top=-2, rounding_bottom=-3);
