include <BOSL2/std.scad>
$fn = 64;

hole_diameter = 19.2;
hole_height = 17.4;  // 20
hole_tolerance = 0.1;
side_thickness = 1.4;
top_thickness = 3;
// thickness = 2;
side_rounding = side_thickness / 2;
top_rounding = 3;  // top_thickness / 2;

// not including the thickness of the cover itself.
edge_radius = 7;

// A 2D section that will be extruded rotationally.
module cover_section(hole_diameter) {
  inner_diameter = hole_diameter - side_thickness * 2 - hole_tolerance;

  right(inner_diameter / 2) union() {
    rect([ side_thickness + edge_radius, top_thickness ],
         rounding = [ top_rounding, top_rounding, 0, 0 ],
         anchor = LEFT + BOTTOM);

    rect([ side_thickness, hole_height ],
         rounding = [ 0, 0, side_thickness / 2, side_thickness / 2 ],
         anchor = LEFT + TOP);
  }
}

module cover(hole_diameter) {
  rotate_extrude() { cover_section(hole_diameter); }
}

// cover_section(hole_diameter);

// Outer cover
cover(hole_diameter);

// Inner cover
// down(hole_height) mirror([ 0, 0, 1 ])
//     cover(hole_diameter - side_thickness * 2 - hole_tolerance);

// For debugging (to check that it fits the hole):
// #cylinder(d = hole_diameter, h = 10, center = true);
