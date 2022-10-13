include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
plate_diameter = 150;
plate_height = 2;
border_thickness = 2;
border_height = 2;

pin_height = 7;
pin_diameter = 5;
pin_dist_from_center = 15;
pin_dist_from_each_other = 80;

module bowser_stand() {
  cylinder(d = plate_diameter, h = plate_height);
  up(plate_height - nothing) rotate_extrude() border_2d_cut();

  left(pin_dist_from_each_other / 2) pin();
  right(pin_dist_from_each_other / 2) pin();
}

module border_2d_cut() {
  r = border_thickness / 2;
  right(plate_diameter / 2)
      rect([ border_thickness, border_height ], rounding = [ r, r, 0, 0 ], anchor = RIGHT + FRONT);
}

module pin() {
  fwd(pin_dist_from_center) up(plate_height - nothing) cylinder(d = pin_diameter, h = pin_height);
}

bowser_stand();
