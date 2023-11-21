include <BOSL2/std.scad>
$fn = 64;

dist_between_holes = 124;
width = 20;
hole_d = 7;
length = dist_between_holes + 3 * 2 + hole_d;
h = 2.5;

linear_extrude(h) difference() {
  rect([ length, width ], rounding = width / 2);
  left(dist_between_holes / 2) circle(d = hole_d);
  right(dist_between_holes / 2) circle(d = hole_d);
}
