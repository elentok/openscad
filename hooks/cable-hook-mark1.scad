$fn = 50;

use <../../lib/2d.scad>
use <../../lib/chamfer.scad>

module flat_hook(size, opening_height, thickness, fillet = true) {
  assert(size.x >= 2 * size.y, "Width must be at least 2x outer height");

  inner_height = size.y - 2 * thickness;
  large_ext_diameter = size.y;
  small_ext_diameter = size.y - thickness - opening_height;
  bottom_square_width = size.x - small_ext_diameter / 2 - large_ext_diameter;
  bottom_square_right = bottom_square_width + large_ext_diameter;
  middle_square_width = bottom_square_width / 5;

  // the base square need to be cropped a little so it doesn't
  // exceed from the arc
  arc_offset = thickness / 2;

  translate([ -size.x / 2, 0, 0 ]) {
    union() {
      // Base
      difference() {
        translate([ arc_offset, 0, 0 ]) {
          square([ size.x - arc_offset, thickness ]);
        }
        if (fillet) {
          translate([ size.x - thickness / 2, thickness / 2, 0 ]) {
            negative_2d_edge(thickness / 2);
          }
        }
      }

      // Large half-circle
      translate([ size.y, size.y / 2, 0 ]) { half_circle(size.y, thickness); }

      // Bottom square
      translate([ large_ext_diameter, inner_height + thickness, 0 ]) {
        square([ bottom_square_width, thickness ]);
      }

      // Small half circle
      translate([
        bottom_square_right,
        small_ext_diameter / 2 + opening_height + thickness, 0
      ]) {
        rotate([ 0, 0, 180 ]) { half_circle(small_ext_diameter, thickness); }
      }

      // Small knob to prevent cables from sliding out
      translate([
        bottom_square_right - middle_square_width, thickness + opening_height, 0
      ]) {
        union() {
          square([ middle_square_width, thickness ]);
          // fillet
          translate([ 0, thickness / 2, 0 ]) { circle(d = thickness); }
        }
      }

      // Add an arc to make it stronger
      translate([ size.y, 0, 0 ]) { arc(2 * size.y, thickness); }
    }
  }
}

module hook(size, opening_height, thickness) {
  rotate([ 90, 0, 0 ]) {
    linear_extrude(size.y, center = true) {
      flat_hook([ size.x, size.z ], opening_height, thickness, thickness);
    }
  }
}

module hook_with_screw_hole(size, opening_height, thickness) {
  hole_diameter = 4;
  hole_chamfered_diameter = 9;

  difference() {
    hook(size, opening_height, thickness);

    // Screw hole
    translate([ 0, 0, thickness / 2 ]) {
      chamfered_hole(thickness + 0.1, hole_diameter, hole_chamfered_diameter);
    }

    // Top hole (for screwdriver)
    translate([ 0, 0, size.z - thickness - 0.1 ]) {
      cylinder(d = 8, h = thickness + 0.2);
    }
  }
}

// flat_hook([ 55, 21 ], opening_height = 5, thickness = 3);

// hook_with_screw_hole([60, 20, 15],
//                      opening_height = 5, thickness = 2.5);

// mini-hook (mark 1)
// hook_with_screw_hole([40, 15, 12],
//                      opening_height = 4, thickness = 2);

// mini-hook (mark 2)
// hook([40, 20, 19.4], opening_height = 4, thickness = 2.2);

// mini-hook (mark 3)
hook_with_screw_hole([ 60, 20, 19.4 ], opening_height = 4, thickness = 2.2);
// hook([ 40, 20, 18 ], opening_height = 4, thickness = 2.2);
