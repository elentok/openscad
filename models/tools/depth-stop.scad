include <BOSL2/std.scad>
use <../../lib/screw-sizes.scad>
$fn = 64;

nut_type = "m3";
screw_head_diameter = 6.1;

id = 2.6;
d_padding = 1.5;

tolerance = 0.1;

nut_d = nut_diameter(nut_type);
nut_w = nut_width(nut_type);
nut_t = nut_thickness(nut_type);
screw_d = screw_diameter(nut_type);

h = max(nut_d, screw_head_diameter);

od = id + d_padding * 5 + nut_t * 2;

echo("Outer diameter:", od);

module depth_stop() {
  difference() {
    tube(od = od, id = id + tolerance, h = h);
    up(0.3) {
      right(d_padding + id / 2) nut_mask();
      rotate([ 0, 90, 0 ]) cyl(d = screw_d, h = od);
    }
  }
}

module nut_mask() {
  rotate([ 0, 90, 0 ]) linear_extrude(nut_t) {
    rect([ nut_d / 2, nut_w ], anchor = RIGHT);
    hexagon(d = nut_d);
  }
}

// nut_mask();
depth_stop();
