include <BOSL2/std.scad>
use <../lib-old/bottom_screw_head_mask.scad>
$fn = 64;

screw_full_length = 57;
nut_and_washer_length = 9;

d1 = 60;
d2 = 28;
h1 = 20;
h2 = screw_full_length - h1;
screw_hole_d = 8.5;
washer_hole_d = 24;

echo("screw length", h1 + h2 - nut_and_washer_length);

difference() {
  union() {
    cyl(d = d1, h = h1, anchor = BOTTOM, rounding = 2);
    up(h1 - 0.01) cyl(d = d2, h = h2, anchor = BOTTOM, rounding2 = 2);
  }

  down(0.01 / 2) cyl(d = screw_hole_d, h = d1 + d2 + 0.01, anchor = BOTTOM);

  bottom_screw_head_mask(head_diameter = washer_hole_d,
                         head_height = nut_and_washer_length,
                         screw_diameter = screw_hole_d, support_height = 0.2);
  // down(0.01 / 2) cyl(d = screw_hole_d, h = d1 + d2 +
  // 0.01, anchor = BOTTOM); down(0.01 / 2)
  //     cyl(d = washer_hole_d, h = nut_and_washer_length
  //     + 0.01, anchor = BOTTOM);
}
