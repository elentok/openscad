include <BOSL2/std.scad>
$fn = 64;

d = 77;
w = 70;
h = 25;
bottom_thickness = 10;
thickness = 5;
slot_tolerance_x = 0.1;
slot_tolerance_y = 0.3;
slot_size = [ thickness + slot_tolerance_x, bottom_thickness / 2 ];

module stand_part1() {
  linear_extrude(thickness, center = true) difference() {
    part2d();
    rect(slot_size, anchor = BACK);
  }
}

module stand_part2() {
  linear_extrude(thickness, center = true) difference() {
    part2d();
    fwd(slot_size.y - slot_tolerance_y) rect(slot_size, anchor = BACK);
    fwd(bottom_thickness - slot_size.y / 2) rect(slot_size, anchor = BACK);
  }
}

module part2d() {
  fwd(bottom_thickness) round2d(r = 2) difference() {
    back(bottom_thickness) rect([ w, h ], anchor = BACK);
    circle(d = d, anchor = BACK);
  }
}

module demo() {
  color("green") stand_part1();
  rotate([ 0, 90, 0 ]) color("blue") stand_part2();
}

stand_part1();
// stand_part2();
back(30) stand_part2();
// part2d();
// demo();
