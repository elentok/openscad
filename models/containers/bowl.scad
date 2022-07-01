$fn = 64;

use <../../lib/rounded_cylinder.scad>

module bowl(h, d_top, d_bottom, thickness) {
  rounded_hollow_cylinder(h, d_top, d_bottom, thickness);
  linear_extrude(thickness) circle(d = d_bottom - thickness);
}

bowl(h = 30, d_top = 70, d_bottom = 50, thickness = 2);
