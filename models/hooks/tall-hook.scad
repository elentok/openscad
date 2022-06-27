$fn = 50;

use <../../lib/chamfer.scad>
use <../../lib/rcube.scad>
use <../../lib/rounded.scad>

module tall_hook(size, thickness, opening_height = 5, latch = 8, inner_radius,
                 outer_radius) {
  inner_radius =
      is_undef(inner_radius) ? min(size.z / 3, size.x / 3) : inner_radius;
  outer_radius =
      is_undef(outer_radius) ? min(size.z / 4, size.x / 4) : outer_radius;

  union() {
    difference() {
      // External
      rrcube(size, [ 0, 0, outer_radius, outer_radius ]);

      // Internal
      translate([ 0, 0, 0 ]) {
        rrcube([ size.x - thickness * 2, size.y + 0.2, size.z - thickness * 2 ],
               [ inner_radius, 0, inner_radius, inner_radius ]);
      }

      translate([
        size.x / 2 - thickness / 2, 0,
        -size.z / 2 + opening_height / 2 + thickness + thickness / 2
      ]) {
        cube([ thickness + 0.2, size.y + 0.2, opening_height + thickness ],
             center = true);
      }

      translate([
        size.x / 2 - thickness / 4, 0,
        -size.z / 2 + thickness / 4 + thickness / 2
      ]) {
        rotate([ 0, -90, 0 ]) {
          rotate([ 0, 0, 90 ]) { negative_edge(size.y + 0.2, thickness / 2); }
        }
      }
    }

    translate([
      size.x / 2 - latch / 2, 0,
      -size.z / 2 - thickness / 2 + thickness + opening_height +
      thickness
    ]) {
      rrcube([ latch, size.y, thickness ],
             [ thickness / 2, thickness / 2, 0, thickness / 2 ]);
    }
  }
}

module tall_hook_with_screw_hole(size, thickness, opening_height = 5, latch = 8,
                                 inner_radius, outer_radius) {
  hole_diameter = 4;
  hole_chamfered_diameter = 9;

  difference() {
    tall_hook(size, thickness, opening_height, latch, inner_radius,
              outer_radius);

    // Screw hole
    translate([ 0, 0, -size.z / 2 + thickness / 2 ]) {
      chamfered_hole(thickness + 0.1, hole_diameter, hole_chamfered_diameter);
    }

    // Top hole (for screwdriver)
    translate([ 0, 0, size.z / 2 - thickness - 0.1 ]) {
      cylinder(d = 8, h = thickness + 0.2);
    }
  }
}

// Mark 1:
// tall_hook([ 40, 20, 40 ], thickness = 3, inner_radius = 15, outer_radius =
// 10);

// Mark 2:
// tall_hook([ 40, 20, 30 ], thickness = 3);

// Micro - Mark 1:
// tall_hook([ 30, 20, 20 ], thickness = 3);
tall_hook_with_screw_hole([ 28, 15, 20 ], thickness = 2.5);
