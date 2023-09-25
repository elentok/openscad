include <BOSL2/std.scad>
$fn = 64;

angus_diameter = 10;

width1 = 32;   // 20
height1 = 40;  // 30

width2 = 12;
height2 = 18;

depth = 30;

top_offset = 6;

rotate([ 90, 0, 0 ]) hull() {
  linear_extrude(0.1) ellipse(d = [ width1, height1 ]);
  up(depth - 1) fwd(height2 - height1 - top_offset) rotate([ -80, 0, 0 ])
      linear_extrude(0.1) ellipse(d = [ width2, height2 ]);
}

up(4) rotate([ 50, 0, 0 ]) up(20) cylinder(d = 10, h = 35);
