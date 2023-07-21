include <BOSL2/std.scad>
$fn = 64;

hole_diameter = 51;
hole_height = 20;  // 20
hole_tolerance = 0.1;
thickness = 1.4;
// thickness = 2;
rounding = thickness / 2;

// not including the thickness of the cover itself.
edge_radius = 10;

// A 2D section that will be extruded rotationally.
module cover_section(hole_diameter) {
  inner_diameter = hole_diameter - thickness * 2 - hole_tolerance;

  right(inner_diameter / 2) union() {
    rect([ thickness + edge_radius, thickness ],
         rounding = [ rounding, rounding, 0, 0 ], anchor = LEFT + BOTTOM);

    rect([ thickness, hole_height ],
         rounding = [ 0, 0, thickness / 2, thickness / 2 ],
         anchor = LEFT + TOP);
  }
}

module cover(hole_diameter) {
  rotate_extrude() { cover_section(hole_diameter); }
}

// Outer cover
cover(hole_diameter);

// Inner cover
// down(hole_height) mirror([ 0, 0, 1 ])
// cover(hole_diameter - thickness * 2 - hole_tolerance);

// For debugging (to check that it fits the hole):
// #cylinder(d = hole_diameter, h = 10, center = true);
