include <BOSL2/std.scad>
$fn = 64;

cyl(d1 = 25, d2 = 23, h = 3, anchor = TOP, rounding2 = 1);
back(2) cyl(d = 7.46, h = 8, anchor = BOTTOM, chamfer2 = 1);
