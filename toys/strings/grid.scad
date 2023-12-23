include <BOSL2/std.scad>
$fn = 64;

x = 15;
y = 5;
space = 5;
hole_diameter = 6;
rounding = 5;
thickness = 3;

size_x = x * hole_diameter + (x + 1) * space;
size_y = y * hole_diameter + (y + 1) * space;

module board() {
  linear_extrude(thickness) difference() {
    back(space + hole_diameter / 2) left(space + hole_diameter / 2)
        rect([ size_x, size_y ], rounding = rounding, anchor = LEFT + BACK);
    holes();
  }
}

module holes() {
  for (i_x = [0:x - 1]) {
    for (i_y = [0:y - 1]) {
      fwd(i_y * (space + hole_diameter)) right(i_x * (space + hole_diameter))
          circle(d = hole_diameter);
    }
  }
}

board();
