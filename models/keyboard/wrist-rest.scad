include <BOSL2/std.scad>
$fn = 64;

rounding = 5;
height = 48;
width = 100;

linear_extrude(width)
    rect([ height, height ],
         rounding = [ rounding, rounding, height / 2, height / 2 ]);
