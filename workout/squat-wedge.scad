include <BOSL2/std.scad>
$fn = 64;

depth = 100;
height = 30;
width = 60;

linear_extrude(width) round2d(1) right_triangle([ depth, height ]);
// wedge([ width, depth, height ]);
