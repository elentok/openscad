include <BOSL2/std.scad>
$fn = 64;

difference() {
  cube([ 20, 20, 8 ], anchor = BOTTOM);
  down(0.01) linear_extrude(2)
      text("x", halign = "center", valign = "center", size = 15);
}
