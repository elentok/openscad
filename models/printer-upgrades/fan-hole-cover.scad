include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;
epsilon = 0.01;

fan_adapter_height = 7;

// The size of the actual hole in the enclosure
hole_diameter = 101;
hole_thickness = 16;

border_width = 2;
fan_size = 120;
screw_hole_center_dist = 105;
screw_hole_diameter = 5;
thickness = 2;
nut_diameter = 8;  // m4
// The plastic area between the nut and the screw
nut_plastic_thickness = 2;

thread_tolerance = 0.6;
thread_padding = 4;
thread_pitch = round(hole_thickness / 3);

module external_cover() {
  outer_diameter = hole_diameter - thread_padding * 2;
  inner_diameter = outer_diameter - thread_padding * 2 - thickness * 2;
  thread_height = hole_thickness * 0.9;

  difference() {
    threaded_rod(d = outer_diameter, h = thread_height, pitch = thread_pitch,
                 anchor = BOTTOM);
    down(epsilon / 2) cylinder(d = inner_diameter, h = thread_height + epsilon,
                               anchor = BOTTOM);
  }

  cylinder(d = outer_diameter + 10, h = thickness, anchor = TOP);
}

module internal_cover() {
  internal_cover_fan_adapter();
  up(0) internal_cover_thread();
}

module internal_cover_fan_adapter() {
  top_hole_diameter = fan_size - border_width * 2;
  top_hole_radius = top_hole_diameter / 2;
  bottom_hole_diameter = hole_diameter - thread_padding * 2;
  bottom_hole_radius = bottom_hole_diameter / 2;

  difference() {
    union() {
      // bottom
      linear_extrude(thickness) difference() {
        rect([ fan_size, fan_size ], rounding = 4);
        circle(d = bottom_hole_diameter);
      }

      linear_extrude(fan_adapter_height) difference() {
        rect([ fan_size, fan_size ], rounding = 4);

        circle(d = fan_size - border_width * 2);
      }

      up(thickness) rotate_extrude() left(top_hole_radius) right_triangle([
        top_hole_radius - bottom_hole_radius, fan_adapter_height - thickness
      ]);
    }

    internal_cover_screw_holes();
  }
}

module internal_cover_thread() {
  difference() {
    cylinder(d = hole_diameter, h = hole_thickness, anchor = TOP);
    up(epsilon / 2) threaded_rod(
        d = hole_diameter - thread_padding * 2, pitch = thread_pitch,
        h = hole_thickness + epsilon, internal = true, anchor = TOP);
  }
}

module internal_cover_screw_holes() {
  down(epsilon / 2) {
    back(screw_hole_center_dist / 2) {
      left(screw_hole_center_dist / 2) internal_cover_screw_hole();
      right(screw_hole_center_dist / 2) internal_cover_screw_hole();
    }

    fwd(screw_hole_center_dist / 2) {
      left(screw_hole_center_dist / 2) internal_cover_screw_hole();
      right(screw_hole_center_dist / 2) internal_cover_screw_hole();
    }
  }
}

module internal_cover_screw_hole() {
  cylinder(d = screw_hole_diameter, h = fan_adapter_height + epsilon);
  linear_extrude(fan_adapter_height - nut_plastic_thickness)
      hexagon(d = nut_diameter);
}

// internal_cover_thread();
internal_cover();
// down(50) external_cover();
// external_cover();
