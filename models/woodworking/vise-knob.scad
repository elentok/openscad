include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;

rod_diameter = 11;

screw_hole_diameter = 4.3;

grip_thickness = 2;
grip_od = rod_diameter + grip_thickness * 2;
grip_id = rod_diameter;
grip_gap = 0.25 * grip_id;
grip_width = 8;

grip_lip_length = grip_od / 2;
grip_lip_total_width = grip_gap + grip_thickness * 2;

echo("Grip lip total width", grip_lip_total_width);

module grip() {
  difference() {
    linear_extrude(grip_width, center = true) grip2d();
    grip_screw_hole();
  }
}

module grip_screw_hole() {
  y = grip_od / 2 + grip_lip_length - screw_hole_diameter / 2 -
      grip_lip_length / 2;
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

grip();
