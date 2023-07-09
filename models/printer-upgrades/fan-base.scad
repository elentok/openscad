include <BOSL2/std.scad>
$fn = 64;

fan_size = 140;
fan_thickness = 27.6 + 2 * 4.6;  // 3mm is the thickness of the grill
fan_hole_margin = 5.8;
fan_hole_diameter = 4.6;

// fan_size = 50;
// fan_thickness = 11.7 + 2 * 3;  // 3mm is the thickness of the grill
// fan_hole_margin = 3;
// fan_hole_diameter = 4;

base_fan_spacing = 1;

fan_holder_padding = 3;
// fan_holder_diameter = (fan_hole_diameter + fan_hole_margin + base_fan_spacing
// +
//                        fan_holder_padding) *
//                       2;

fan_holder_thickness = 3;
fan_holder_size = [
  fan_hole_diameter + fan_hole_margin * 2 + fan_holder_padding * 2,
  fan_holder_thickness,
  fan_hole_diameter + fan_hole_margin + base_fan_spacing + fan_holder_padding,
];

base_height = 3;
base_size = [
  fan_size + fan_holder_padding * 2,
  fan_thickness * 3,
];
// base_rounding = 12;
base_rounding = fan_thickness;
base_diameter = fan_size + fan_holder_padding * 2;

module fan_base() {
  linear_extrude(base_height) {
    difference() {
      rect(base_size, rounding = base_rounding);
      circle(d = min(base_size.x, base_size.y) * 0.7);
    }
  }

  up(base_height - 0.01) {
    x = fan_size / 2 - fan_hole_margin - fan_hole_diameter / 2;
    back(fan_thickness / 2) {
      left(x) fan_holder(anchor = FWD);
      right(x) fan_holder(anchor = FWD);
    }

    fwd(fan_thickness / 2) {
      left(x) fan_holder(anchor = BACK);
      right(x) fan_holder(anchor = BACK);
    }
  }
}

module fan_holder(anchor) {
  y = anchor == BACK ? fan_holder_size.y / 2 : -fan_holder_size.y / 2;
  echo(y);
  fwd(y) rotate([ 90, 0, 0 ]) linear_extrude(fan_holder_size.y, center = true)
      fan_holder_2d();
}

module fan_holder_2d() {
  r = fan_holder_size.x / 2;

  diff() {
    rect([ fan_holder_size.x, fan_holder_size.z ], rounding = [ r, r, 0, 0 ],
         anchor = FWD) {
      tag("remove") fwd(fan_holder_padding) position(BACK)
          circle(d = fan_hole_diameter, anchor = BACK);
    }
  }
}

// fan_holder(BACK);
fan_base();
