include <./variables.scad>
include <BOSL2/std.scad>

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
