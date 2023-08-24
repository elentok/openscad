include <BOSL2/std.scad>
$fn = 64;

// Foot for the shelf that goes under the printer enclosure

foot_diameter = 20;
foot_height = 10;
space_above_screw_head = 1;
screw_head_height = 3;
screw_head_diameter = 7.7;
screw_body_diameter = 4;

epsilon = 0.01;

module foot() {
  difference() {
    cyl(d = foot_diameter, h = foot_height, rounding2 = 5, anchor = BOTTOM);
    screw_hole_mask();
  }
}

module screw_hole_mask() {
  h_above_head = space_above_screw_head;
  h_head = screw_head_height;
  h_body = foot_height - h_above_head - h_head;

  down(epsilon / 2) {
    cyl(d = screw_body_diameter, h = h_body, anchor = BOTTOM);
    up(h_body - epsilon / 2)
        cyl(d1 = screw_body_diameter, d2 = screw_head_diameter,
            h = h_head + epsilon, anchor = BOTTOM);
    up(h_body + h_head)
        cyl(d = screw_head_diameter, h = h_above_head + 14, anchor = BOTTOM);
  }
}

foot();
