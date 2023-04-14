include <BOSL2/std.scad>
$fn = 64;

inner_d = 19.2;
outer_d = 22;
h = 15;

difference() {
  tube(od = outer_d, id = inner_d, h = h);
  cube([ outer_d / 2 + 0.1, outer_d / 2 + 0.1, h + 0.1 ], anchor = LEFT + BACK);
}
