include <BOSL2/std.scad>
$fn = 64;

rod_diameter = 7.5;
thickness = 6; // 2
bottom_thickness = 2;
height = 10; // 5

outer_d = rod_diameter + thickness;

cylinder(d = outer_d, h = bottom_thickness);
tube(od = outer_d, id = rod_diameter, h = height, anchor = BOTTOM);
