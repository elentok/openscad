include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;

rod_diameter = 11;

// M3
screw_hole_diameter = 3.2;
screw_head_diameter = 5.6;
screw_head_height = 4;
nut_diameter = 6.2;

grip_thickness = 2;
grip_od = rod_diameter + grip_thickness * 2;
grip_id = rod_diameter;
grip_gap = 0.25 * grip_id;
grip_width = 8;

grip_lip_length = grip_od / 2;
grip_lip_total_width = grip_gap + grip_thickness * 2;
grip_lip_tolerance = 0.15;
grip_width_tolerance = 0.1;
grip_screw_hole_offset = 2;

knob_large_d = 25;
knob_small_d = 16;
knob_length = 60; // 30

echo("Grip lip total width", grip_lip_total_width);

// ============================================================
// Grip

module grip() {
  difference() {
    linear_extrude(grip_width, center = true) grip2d();
    grip_screw_hole();
  }
}

module grip_screw_hole() {
  y = grip_od / 2 + grip_thickness / 2 + grip_screw_hole_offset;
  fwd(y) rotate([ 0, 90, 0 ])
      cylinder(d = screw_hole_diameter, h = grip_lip_total_width + nothing,
               center = true);
}

module grip2d() {
  difference() {
    circle(d = grip_od);
    circle(d = grip_id);
    rect([ grip_gap, grip_od / 2 ], anchor = BACK);
  }

  grip_lip2d();
  mirror([ 1, 0, 0 ]) grip_lip2d();
}

module grip_lip2d() {
  fwd(grip_od / 2 - grip_thickness) right(grip_gap / 2)
      rect([ grip_thickness, grip_lip_length + grip_thickness ],
           rounding = [ 0, 0, 0, grip_thickness ], anchor = LEFT + BACK);
}

// ============================================================
// Knob

module knob() {
  difference() {
    bottom_half() {
      down(knob_length - knob_large_d / 2 - knob_small_d / 2) hull() {
        sphere(d = knob_large_d);
        up(knob_length - knob_large_d / 2 - knob_small_d / 2)
            sphere(d = knob_small_d);
      }
    }

    up(nothing) knob_connector_mask();
  }
}

module knob_connector_mask() {
  cube_size = [
    grip_lip_total_width - grip_lip_tolerance + nothing,
    grip_width + grip_width_tolerance,
    grip_lip_length + 3 + nothing,
  ];
  cube(cube_size, anchor = TOP);

  // Screw hole
  down(screw_hole_diameter / 2 + grip_screw_hole_offset)
      rotate([ 90, 0, 90 ]) union() {
    // screw
    cylinder(d = screw_hole_diameter, h = knob_large_d, center = true);

    // screw head
    up(knob_small_d / 2 - 1)
        cylinder(d = screw_head_diameter, h = screw_head_height);

    // nut
    down(screw_head_height + knob_small_d / 2 - 1)
        linear_extrude(screw_head_height) hexagon(d = nut_diameter);
  }
}

// ============================================================
// Demo
module demo(spacing = 5) {
  knob();
  up(grip_od + spacing) rotate([ 90, 0, 0 ]) grip();

  // screw
  color("#0000ff44") down(grip_screw_hole_offset + 3.2 / 2) rotate([ 0, 90, 0 ])
      cylinder(d = 3.2, h = 13.75, center = true);
}

// ============================================================
// Render

// grip();
knob();
// knob_connector_mask();
// demo();
