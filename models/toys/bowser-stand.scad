include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
diameter = 140;
height = 4;
border_thickness = 2;
border_height = 3;

module bowser_stand() {
  up(height - nothing) rotate_extrude() border_2d_cut();  // cylinder(d = diameter, h = height);
  // border_2d_cut();  // cylinder(d = diameter, h = height);
}

module border_2d_cut() {
  r = border_thickness / 2;
  right(diameter / 2)
      rect([ border_thickness, border_height ], rounding = [ r, r, 0, 0 ], anchor = RIGHT + FRONT);
}

bowser_stand();
