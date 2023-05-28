include <BOSL2/std.scad>
$fn = 64;

length = 112;
hole_diameter = 7.55;
outer_diameter = 30;

difference() {
  cyl(d = outer_diameter, h = length, rounding = 2);
  cyl(d = hole_diameter, h = length + 0.01);
}
