include <BOSL2/std.scad>
$fn = 64;

// Rounded cube, with different rounding for the sides and for the top and bottom
module rcube(size, rounding_sides, rounding_top = 0, rounding_bottom = 0) {
  x = size.x / 2 - rounding_sides;
  y = size.y / 2 - rounding_sides;
  hull() {

    // #cuboid([size.x - rounding_sides, size.y, size.z], anchor=BOTTOM);

    left(x) back(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
    right(x) back(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
    left(x) fwd(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
    right(x) fwd(y) cyl(r=rounding_sides, rounding1=rounding_bottom, rounding2=rounding_top, h=size.z, anchor=BOTTOM);
  }
}

// Demo
rcube([100, 50, 5], rounding_sides=10, rounding_top=3, rounding_bottom=1);
