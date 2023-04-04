include <BOSL2/std.scad>
$fn = 64;

fan_size = 120;
nothing = 0.01;

// ========================================
// Control box

wall_thickness = 2;
top_width = 34;
bottom_width = 50;
bottom_height = 10;
control_box_side_padding = 10;
control_box_length = fan_size + control_box_side_padding * 2;
control_box_height = 40;
control_box_wall_z = control_box_length / 2 - 25;

// ========================================
// Fan adapter

// distance of the edge of the hole from the edge of the fan
hole_margin = 5.3;
hole_diameter = 4.3;

fan_adapter_notch_wall = 0.6;
fan_adapter_wall_thickness = 1.5;
fan_adapter_tolerance = 0.3;
fan_adapter_leg_space = 1;
fan_adapter_leg_notch_size = 0.9;
fan_adapter_screw_diameter = 2.8;
fan_adapter_screw_height = 6;

fan_adapter_leg_width = 4;

fan_adapter_size = [
  // x:
  hole_diameter + hole_margin + fan_adapter_wall_thickness,
  // y:
  hole_diameter + fan_adapter_tolerance + fan_adapter_wall_thickness * 2,
  // z:
  14.98
];

assert(fan_adapter_leg_width > fan_adapter_screw_diameter, "Fan adapter leg
width must be larger than the screw diameter");
assert(fan_adapter_leg_width < fan_adapter_size.x, "Fan adapter leg
width must be smaller than the fan adapter itself");

fan_adapter_hole_tolerance = 0.2;
fan_adapter_hole_size = [
  fan_adapter_size.z + fan_adapter_hole_tolerance,
  fan_adapter_leg_width + fan_adapter_hole_tolerance,
];

// The part that connects the fan to the control box (with the switch and the
// power socket).
module fan_adapter() {
  difference() {
    union() {
      linear_extrude(fan_adapter_size.z) fan_adapter_2d();

      // leg
      cube([ wall_thickness, fan_adapter_leg_width, fan_adapter_size.z ],
           anchor = RIGHT + BOTTOM);
    }

    // screw hole
    up(fan_adapter_size.z / 2) left(wall_thickness + nothing)
        rotate([ 0, 90, 0 ]) cylinder(d = fan_adapter_screw_diameter,
                                      h = fan_adapter_screw_height);
  }
}

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
  // fan_adapter_leg2d();
  // mirror([ 0, 1, 0 ]) fan_adapter_leg2d();
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

  // rect_tube(h = 4, isize = inner_size, wall = 1);
}

module control_box() {
  difference() {
    union() {
      // control_box_2d();
      linear_extrude(control_box_length, center = true) control_box_2d();
      up(control_box_wall_z) control_box_wall();
      down(control_box_wall_z) control_box_wall();
    }

    back(control_box_height + nothing) {
      z = control_box_length / 2 - hole_margin - hole_diameter / 2 -
          control_box_side_padding;

      up(z) fan_adapter_hole_mask();
      down(z) fan_adapter_hole_mask();
    }
  }
}

module fan_adapter_hole_mask() {
  size = [
    fan_adapter_hole_size.x,
    wall_thickness + nothing * 2,
    fan_adapter_hole_size.y,
  ];
  cuboid(size, anchor = BACK);
}

module control_box_2d() {
  difference() {
    trapezoid(h = control_box_height, w1 = bottom_width, w2 = top_width,
              anchor = FWD);

    trapezoid(h = control_box_height - wall_thickness,
              w1 = bottom_width - wall_thickness * 2,
              w2 = top_width - wall_thickness * 2, anchor = FWD);
  }
}

module control_box_wall() {
  linear_extrude(wall_thickness)
      trapezoid(h = control_box_height - nothing, w1 = bottom_width - nothing,
                w2 = top_width - nothing, anchor = FWD);
}

control_box();
// left(20) control_box_fan_adapter_test();
// control_box_fan_adapter_test();
// fan_adapter();
// fan_adapter_2d();
