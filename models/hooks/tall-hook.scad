$fn = 50;

use <../../lib/rcube.scad>
use <../../lib/rounded.scad>

module tall_hook(size, thickness, inner_radius, opening_height = 5, latch = 8) {
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

// Mark 1:
// tall_hook([ 40, 20, 40 ], thickness = 3, inner_radius = 15, outer_radius =
// 10);

// Mark 2:
tall_hook([ 40, 20, 30 ], thickness = 3);
