include <BOSL2/std.scad>
$fn = 64;

size = [ 80, 28, 3 ];

rounding = size.y / 2;
hole_diameter = 6;
hole_margin = 5;

name = "name";
font = "Arial:style=Bold";
text_size = size.y * 0.7;
text_offset = 4;

module keychain() {
  difference() {
    linear_extrude(size.z, convexity = 4, center = true) {
      diff() {
        rect([ size.x, size.y ], rounding = rounding) {
          tag("remove") right(hole_margin) position(LEFT)
              circle(d = hole_diameter, anchor = LEFT);
        };
      }
    }

    right(text_offset) up(0.01) linear_extrude(size.z / 2) round2d(r = 1) text(
        name, font = font, size = text_size, anchor = CENTER, spacing = 0.95);
  }
}

keychain();
