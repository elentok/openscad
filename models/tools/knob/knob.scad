include <BOSL2/rounding.scad>
include <BOSL2/std.scad>
$fn = 64;

// M3
m3_nut_diameter = 6.3;
m3_nut_height = 2.6;
m3_screw_diameter = 3.4;

// the cylinder that distances the knob from the surface.

// A parametric knob
//
// Extension = the cylinder that distances the knob from the surface.
module knob(knob_height, knob_diameter, extension_height, extension_diameter,
            nut_size = "m3", knob_n = 10) {
  // TODO: support more nut sizes
  nut_diameter = m3_nut_diameter;
  nut_height = m3_nut_height;
  screw_diameter = m3_screw_diameter;

  difference() {
    union() {
      // extension
      cylinder(d = extension_diameter, h = extension_height, anchor = TOP);

      // knob
      rounded_knob(knob_diameter, knob_height, knob_n);
      // linear_extrude(knob_height) round2d(r = 2) star(
      //     n = knob_n, or = knob_diameter / 2, ir = knob_diameter / 2 * 0.8);
    }

    // nut
    up(0.01) linear_extrude(knob_height) hexagon(d = nut_diameter);

    // hole
    down(extension_height + 0.02)
        cylinder(d = screw_diameter, h = knob_height + extension_height + 0.01);
  }
}

module rounded_knob(knob_diameter, knob_height, knob_n) {
  knob_radius = knob_diameter / 2;

  star = star(n = knob_n, or = knob_radius, ir = knob_radius * 0.8);
  rounded_star = round_corners(
      star, cut = 0.5);  //, cut = flatten(repeat([ .5, 0 ], 5)), $fn = 24);
  offset_sweep(rounded_star, height = knob_height, bottom = os_circle(r = 1),
               top = os_circle(r = 3), steps = 15);
}

knob(knob_height = 6, knob_diameter = 20, extension_height = 2,
     extension_diameter = 10, nut_size = "m3");
