include <BOSL2/std.scad>
$fn = 64;

fan_size = 120;

// ========================================
// Control box

wall_thickness = 1.5;

// ========================================
// Fan adapter

// distance of the edge of the hole from the edge of the fan
hole_margin = 5.3;
hole_diameter = 4.3;

fan_adapter_notch_wall = 0.6;
fan_adapter_wall_thickness = 1.5;
fan_adapter_tolerance = 0.4;
fan_adapter_leg_space = 1;
fan_adapter_leg_notch_size = 0.9;

fan_adapter_size = [
  // x:
  hole_diameter + hole_margin + fan_adapter_wall_thickness,
  // y:
  hole_diameter + fan_adapter_tolerance + fan_adapter_wall_thickness * 2,
  // z:
  14.98
];

fan_adapter_hole_tolerance = 0.2;
fan_adapter_hole_size = [
  fan_adapter_leg_space + fan_adapter_wall_thickness * 2 +
      fan_adapter_hole_tolerance,
  fan_adapter_size.z + fan_adapter_hole_tolerance,
];

// The part that connects the fan to the control box (with the switch and the
// power socket).
module fan_adapter() { linear_extrude(fan_adapter_size.z) fan_adapter_2d(); }

module fan_adapter_2d() {
  r = [ fan_adapter_size.y / 2, 0, 0, fan_adapter_size.y / 2 ];
  difference() {
    rect(fan_adapter_size, rounding = r, anchor = LEFT);
    right(fan_adapter_size.x - hole_diameter / 2 - fan_adapter_wall_thickness)
        circle(d = hole_diameter);

    // notch
    notch_d = (fan_adapter_wall_thickness - fan_adapter_notch_wall) * 2;
    right(fan_adapter_size.x - fan_adapter_size.y / 2) rotate([ 0, 0, 45 ])
        right(fan_adapter_size.y / 2) circle(d = notch_d);
  }

  // leg
  fan_adapter_leg2d();
  mirror([ 0, 1, 0 ]) fan_adapter_leg2d();
}

module fan_adapter_leg2d() {
  r = fan_adapter_leg_notch_size / 2;
  back(fan_adapter_leg_space / 2) {
    rect([ wall_thickness * 2, wall_thickness ], anchor = RIGHT + FWD) {
      position(LEFT + BACK)
          rect([ fan_adapter_leg_notch_size, fan_adapter_leg_notch_size ],
               rounding = [ r, r, 0, 0 ], anchor = LEFT + FWD);
    }
  }
}

module control_box_fan_adapter_test() {
  wall_size = 1;
  outer_size = add_scalar(fan_adapter_hole_size, 12);
  inner_size = add_scalar(outer_size, -wall_size * 2);
  linear_extrude(wall_thickness) difference() {
    rect(outer_size);
    rect(fan_adapter_hole_size);
  }

  rect_tube(h = 4, isize = inner_size, wall = 1);
}

// left(20) control_box_fan_adapter_test();
control_box_fan_adapter_test();
// fan_adapter();
// fan_adapter_2d();
