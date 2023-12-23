module fan_connector() {
  difference() {
    rotate([ 90, 0, 0 ]) linear_extrude(fan_connector_size.y, center = true)
        fan_connector_2d();

    // screw hole
    down(wall_thickness + nothing) cylinder(d = fan_connector_screw_diameter,
                                            h = fan_connector_screw_height);
  }
}

module fan_connector_2d() {
  r = fan_connector_size.x / 2;
  difference() {
    union() {
      rect(fan_connector_size, rounding = [ r, r, 0, 0 ], anchor = BOTTOM);
      // leg
      rect([ fan_connector_leg_width, wall_thickness ], anchor = TOP);
    }

    fan_screw_hole_mask();
    fan_notch_mask();
  }
}

module fan_screw_hole_mask() {
  y = fan_connector_size.y - fan_hole_diameter / 2 -
      fan_connector_wall_thickness;
  back(y) circle(d = fan_hole_diameter);
}

module fan_notch_mask() {
  // The fan itself has a "notch" that gets to about 1mm from the hole, so we
  // need to cut a small piece of the fan connector to make it fit.
  d = (fan_connector_wall_thickness - fan_connector_notch_wall) * 2;
  back(fan_connector_size.y - fan_connector_size.x / 2) rotate([ 0, 0, 45 ])
      back(fan_connector_size.x / 2) circle(d = d);
}

module base_fan_connector_test() {
  wall_size = 1;
  outer_size = add_scalar(fan_connector_hole_size, 12);
  inner_size = add_scalar(outer_size, -wall_size * 2);
  linear_extrude(wall_thickness) difference() {
    rect(outer_size);
    rect(fan_connector_hole_size);
  }

  // rect_tube(h = 4, isize = inner_size, wall = 1);
}
