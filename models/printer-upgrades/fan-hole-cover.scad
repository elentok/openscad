include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;
epsilon = 0.01;

internal_part_height = 10;

// The size of the actual hole in the enclosure
hole_diameter = 101;
hole_thickness = 15;  // TODO

border_width = 5;
fan_size = 120;
screw_hole_center_dist = 105;
screw_hole_diameter = 5;
thickness = 2;
nut_diameter = 7.8;  // m4
// The plastic area between the nut and the screw
nut_plastic_thickness = 2;

thread_padding = 2;
thread_pitch = round(hole_thickness / 3);

module internal_cover() {
  top_hole_diameter = fan_size - border_width * 2;
  top_hole_radius = top_hole_diameter / 2;
  bottom_hole_diameter = hole_diameter - thread_padding * 2;
  bottom_hole_radius = bottom_hole_diameter / 2;

  difference() {
    union() {
      // bottom
      linear_extrude(thickness) difference() {
        rect([ fan_size, fan_size ], rounding = 4);
        circle(d = hole_diameter);
      }

      linear_extrude(internal_part_height) difference() {
        rect([ fan_size, fan_size ], rounding = 4);

        circle(d = fan_size - border_width * 2);
      }

      up(thickness) rotate_extrude() left(top_hole_radius) right_triangle([
        top_hole_radius - bottom_hole_radius, internal_part_height - thickness
      ]);
    }

    internal_cover_screw_holes();
  }

  internal_cover_thread();
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
  cylinder(d = screw_hole_diameter, h = internal_part_height + epsilon);
  linear_extrude(internal_part_height - nut_plastic_thickness)
      hexagon(d = nut_diameter);
}

internal_cover();
