include <BOSL2/std.scad>
$fn = 64;

size = "m3";

// M3
m3_nut_diameter = 6.3;
m3_nut_height = 2.6;
m3_screw_diameter = 3.4;

nut_diameter = m3_nut_diameter;
nut_height = m3_nut_height;
screw_diameter = m3_screw_diameter;

outer_diameter = 20;
knob_height = 6;

// the
extension_height = 2;
extension_diameter = 10;

module knob() {
  difference() {
    union() {
      // extension
      cylinder(d = extension_diameter, h = extension_height, anchor = TOP);

      // knob
      linear_extrude(knob_height) round2d(r = 2)
          star(n = 8, or = outer_diameter / 2, ir = outer_diameter / 2 * 0.8);
    }

    // nut
    up(0.01) linear_extrude(knob_height) hexagon(d = nut_diameter);

    // hole
    down(extension_height + 0.02)
        cylinder(d = screw_diameter, h = knob_height + extension_height + 0.01);
  }
}

knob();
