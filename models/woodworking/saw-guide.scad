include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
magnet_od = 15;
magnet_h = 2.7;
screw_hole_od = 3.5;
screw_hole_h = 8.5;

module magnet_mask() {
  cylinder(d = magnet_od, h = magnet_h);
  up(magnet_h - nothing) cylinder(d = screw_hole_od, h = screw_hole_h);
}

// for test prints
module single_magnet_holder() {
  od = magnet_od + 4;
  h = magnet_h + screw_hole_h + 2;
  difference() {
    cylinder(d = od, h = h);
    down(nothing) magnet_mask();
  }
}

single_magnet_holder();
// magnet_mask();
