include <./variables.scad>
include <BOSL2/std.scad>

module bottom_lid() {
  cuboid([ base_size.x, base_size.y, wall_thickness ], anchor = TOP);

  x = base_wall_x - wall_thickness / 2;
  right(x) bottom_lid_connector(anchor = BOTTOM + RIGHT);
  left(x) bottom_lid_connector(anchor = BOTTOM + LEFT);
}

module bottom_lid_connector(anchor = CENTER, spin = 0, orient = UP) {
  attachable(anchor, spin, orient, size = bottom_lid_connector_size) {
    down(bottom_lid_connector_size.z / 2) rotate([ 0, -90, 0 ]) linear_extrude(
        bottom_lid_connector_size.x, center = true) bottom_lid_connector_2d();
    children();
  }
}
module bottom_lid_connector_2d() {
  r = bottom_lid_connector_size.y / 2;
  size_2d = [ bottom_lid_connector_size.z, bottom_lid_connector_size.y ];

  difference() {
    rect(size_2d, rounding = [ r, 0, 0, r ], anchor = LEFT);
    right(bottom_connector_hole_distance)
        circle(d = bottom_connector_lid_hole_diameter);
  }
}
