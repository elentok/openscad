// See README.md file

include <BOSL2/std.scad>
$fn = 64;

include <./fan-connector.scad>
include <./variables.scad>

// The control box has a bottom lid that connects with screws from the side.
bottom_lid_screw_hole_diameter = 3.2;
// Distance between the center of the screw hole and the bottom and the control
// box.
bottom_lid_screw_hole_distance = 5;

bottom_lid_screw_tube_wall_thickness = 3;

// The diameter of the hole for the screw in the tube
bottom_lid_screw_tube_hole_diameter = 2.8;
bottom_lid_screw_tube_thickness = 2.8;

// ========================================
// Fan adapter

module base() {
  difference() {
    union() {
      rotate([ 90, 0, 90 ]) linear_extrude(base_size.x, center = true)
          base_2d();
      left(base_wall_x) base_wall1();
      right(base_wall_x) base_wall2();
    }

    up(base_size.z + nothing) {
      left(fan_connector_distance) fan_connector_hole_mask();
      right(fan_connector_distance) fan_connector_hole_mask();
      left(base_wall_x - cable_hole_distance_from_wall) cable_hole_mask(LEFT);
      right(base_wall_x - cable_hole_distance_from_wall) cable_hole_mask(RIGHT);
    }
  }
}

module cable_hole_mask(anchor) {
  cube([ cable_hole_size.x, cable_hole_size.y, wall_thickness + nothing * 2 ],
       anchor = TOP + anchor);
}

module fan_connector_hole_mask() {
  size = [
    fan_connector_hole_size.x,
    fan_connector_hole_size.y,
    wall_thickness + nothing * 2,
  ];
  cuboid(size, anchor = TOP);
}

module base_2d() {
  difference() {
    trapezoid(h = base_size.z, w1 = base_size_y_bottom, w2 = base_size_y_top,
              anchor = FWD);

    trapezoid(h = base_size.z - wall_thickness,
              w1 = base_size_y_bottom - wall_thickness * 2,
              w2 = base_size_y_top - wall_thickness * 2, anchor = FWD);
  }
}

module base_wall1() {
  difference() {
    base_wall();
    up(base_size.z / 2) rotate([ 0, 90, 0 ])
        power_socket_mask(wall_thickness + nothing * 2);
  }
}

module power_socket_mask(thickness) {
  linear_extrude(thickness, center = true) intersection() {
    circle(d = power_socket_diameter);
    rect([ power_socket_width, power_socket_diameter ]);
  }
}

module base_wall2() {
  difference() {
    base_wall();
    up(base_size.z / 2) rotate([ 0, 90, 0 ])
        power_switch_mask(wall_thickness + nothing * 2);
  }
}

module power_switch_mask(thickness) {
  linear_extrude(thickness, center = true) intersection() {
    circle(d = power_switch_hole_diameter);
  }

  // nibs
  up(thickness / 4) linear_extrude(thickness / 2, center = true) {
    left(power_switch_nib_dist_from_hole_center)
        rect(power_switch_nib_size, anchor = RIGHT);

    back(power_switch_nib_dist_from_hole_center)
        rect(power_switch_nib_size, anchor = FWD);
  }
}

module base_wall() {
  rotate([ 90, 0, 90 ]) linear_extrude(wall_thickness, center = true)
      difference() {
    trapezoid(h = base_size.z - nothing, w1 = base_size_y_bottom - nothing,
              w2 = base_size_y_top - nothing, anchor = FWD);

    back(bottom_lid_screw_hole_distance)
        circle(d = bottom_lid_screw_hole_diameter);
  }
}

module base_bottom_lid() {
  cuboid([ base_size.x, base_size.y, wall_thickness ], anchor = TOP);

#bottom_lid_screw_tube();
}

module bottom_lid_screw_tube() {
  size = [
    bottom_lid_screw_hole_distance + fan_connector_screw_diameter / 2 +
        wall_thickness,
    fan_connector_screw_diameter + wall_thickness * 2
  ];

  r = size.y / 2;

  difference() {
    rect(size, rounding = [ r, 0, 0, r ], anchor = LEFT);
    right(bottom_lid_screw_hole_distance)
        circle(d = fan_connector_screw_diameter);
  }
}

module demo(spacing) {
  color("#0fe038") base();
  // down(spacing) base_bottom_lid();

  color("#ffb100") up(base_size.z + spacing) {
    right(fan_connector_distance) fan_connector();
    left(fan_connector_distance) mirror([ 1, 0, 0 ]) fan_connector();
  }
}

// fan_connector();
demo(10);

// power_switch_mask(4);
// base_wall1();
// base_wall2();
// base();
// base_bottom_lid();
// left(20) base_fan_connector_test();
// base_fan_connector_test();
// fan_connector();
// fan_connector_2d();
