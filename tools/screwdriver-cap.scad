include <BOSL2/std.scad>
$fn = 64;

hex_d = 5.2;
cap_d = 8.5;
cap_h = 45;
tolerance = 0.8;

module cap() {
  difference() {
    cyl(d = cap_d, h = cap_h, anchor = BOTTOM, rounding2 = hex_d / 2,
        rounding1 = 0.5);
    down(0.01) linear_extrude(cap_h - cap_d / 2) hexagon(d = hex_d + tolerance);
  }
}

module test_tolerance() {
  intersection() {
    cap();
    cyl(d = cap_d * 1.2, h = 10);
  }
}

cap();
// test_tolerance();
