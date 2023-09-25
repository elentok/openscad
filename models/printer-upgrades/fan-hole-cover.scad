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
screw_hole_diameter = 5.5;
thickness = 2;
nut_diameter = 8;  // m4
// The plastic area between the nut and the screw
nut_plastic_thickness = 2;

thread_tolerance = 0.6;
thread_padding = 4;
thread_pitch = round(hole_thickness / 3);

grill_padding = 7;
grill_spacer_height = 1;

module external_cover() {
  thread_outer_diameter = hole_diameter - thread_padding * 2;
  thread_inner_diameter =
      thread_outer_diameter - thread_padding * 2 - thickness * 2;
  thread_height = hole_thickness * 0.9;

  difference() {
    threaded_rod(d = thread_outer_diameter - thread_tolerance,
                 h = thread_height, pitch = thread_pitch, anchor = BOTTOM);
    down(epsilon / 2) cylinder(d = thread_inner_diameter,
                               h = thread_height + epsilon, anchor = BOTTOM);
  }

  grill_outer_diameter = thread_outer_diameter + grill_padding * 2;
  grill_border_width = (grill_outer_diameter - thread_inner_diameter) / 2;
  up(epsilon) grill(d = grill_outer_diameter, h = thickness,
                    border_width = grill_border_width, anchor = TOP);
  // external_cover_grill();
}

// module external_cover_grill() {
//   difference() {
//     circle(d = outer_diameter + 10);
//     circle(d =)
//     // cylinder(d = outer_diameter + 10, h = thickness, anchor = TOP);
//     // cylinder(d = grill_diameter )
//   }
// }

module grill(d, h, border_width = 0, line_width = 2, space = 3,
             anchor = BOTTOM) {
  outer_diameter = d;
  inner_diameter = d - border_width * 2;
  inner_radius = inner_diameter / 2;

  attachable(anchor, d = d, h = h) {
    linear_extrude(h, center = true) {
      if (border_width > 0) {
        ring2d(od = outer_diameter, id = inner_diameter);
      }

      rect([ inner_diameter + epsilon, line_width ]);
      rect([ line_width, inner_diameter + epsilon ]);
      rotate(45) rect([ inner_diameter + epsilon, line_width ]);
      rotate(-45) rect([ inner_diameter + epsilon, line_width ]);
      // rect([ line_width, inner_diameter + epsilon ]);

      // n circles
      // (n+1) * space + n * line_width = inner_radius
      // n * (space + line_width) + space = inner_radius
      // n = (inner_radius - space) / (space + line_width)
      n = round((inner_radius - space) / (space + line_width));

      // after rounding we need to re-calculate the space so it's accurate
      // (n+1) * space + n * line_width = inner_radius
      // space = (inner_radius - n * line_width) / (n+1);
      space2 = (inner_radius - n * line_width) / (n + 1);

      for (i = [1:n]) {
        id = 2 * space2 * i + 2 * line_width * (i - 1);
        echo("ID", id);
        ring2d(id = id, od = id + line_width * 2);
      }
    }

    children();
  }
}

module ring2d(od, id) {
  difference() {
    circle(d = od);
    circle(d = id);
  }
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

module fan_grill() {
  d = fan_size - border_width * 2;

  linear_extrude(thickness) difference() {
    rect([ fan_size, fan_size ], rounding = 4);
    circle(d = d - epsilon);

    spread_to_corners(screw_hole_center_dist) circle(d = screw_hole_diameter);
  }

  grill(d = d, h = thickness, space = 9);

  // spacers
  spread_to_corners(screw_hole_center_dist) {
    up(thickness - epsilon) linear_extrude(grill_spacer_height)
        ring2d(od = screw_hole_diameter + 2, id = screw_hole_diameter);
  }
}

module spread_to_corners(dist) {
  back(dist / 2) {
    right(dist / 2) children();
    left(dist / 2) children();
  }
  fwd(dist / 2) {
    right(dist / 2) children();
    left(dist / 2) children();
  }
}

// internal_cover_thread();
// internal_cover();
// down(50) external_cover();
// external_cover();

fan_grill();
