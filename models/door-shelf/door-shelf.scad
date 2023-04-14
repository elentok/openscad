include <../../lib/bin.scad>
include <../../lib/screw-hole-mask.scad>
include <BOSL2/std.scad>
$fn = 64;

shelf_size = [ 170, 72, 70 ];
wall_thickness = 2.5;
rounding = 10;
screw_hole_diameter = 4.2;
screw_hole_distance_from_top = 15;
screw_hole_distance_from_side = 25;
support_connector_size = [ 6, 10 ];
support_connector_tolerance = 0.1;
support_radius = 40;
support_connector_distance_from_back =
    support_radius / 2 - support_connector_size.y / 2;

module shelf() {
  diff() {
    bin(shelf_size, wall_thickness, [ 0, 0, rounding, rounding ],
        anchor = BOTTOM + BACK) {
      tag("remove") down(screw_hole_distance_from_top)
          right(screw_hole_distance_from_side) position(LEFT + BACK + TOP)
              shelf_screw_hole_mask();
      tag("remove") down(screw_hole_distance_from_top)
          left(screw_hole_distance_from_side) position(RIGHT + BACK + TOP)
              shelf_screw_hole_mask();
      tag("remove") down(epsilon) fwd(support_radius / 2)
          position(BACK + BOTTOM) shelf_support_hole();
      tag("remove") left(shelf_size.x / 4) down(epsilon) fwd(support_radius / 2)
          position(BACK + BOTTOM) shelf_support_hole();
      tag("remove") right(shelf_size.x / 4) down(epsilon)
          fwd(support_radius / 2) position(BACK + BOTTOM) shelf_support_hole();
    }
  }
}

module shelf_screw_hole_mask() {
  screw_hole_mask(axis = BACK, anchor = BACK, d_screw = screw_hole_diameter,
                  l_wall = wall_thickness, l_screwdriver = shelf_size.y,
                  l_countersink = wall_thickness * 2 / 3);
}

module shelf_support_hole() {
  cuboid(
      [
        support_connector_size.x, support_connector_size.y,
        wall_thickness + epsilon * 2
      ],
      anchor = BOTTOM);
}

module support() {
  linear_extrude(support_connector_size.x - support_connector_tolerance,
                 convexity = 4) union() {
    intersection() {
      circle(r = support_radius);
      rect([ support_radius, support_radius ], anchor = BACK + LEFT);
    }

    right(support_radius / 2) rect(
        [
          support_connector_size.y - support_connector_tolerance, wall_thickness
        ],
        anchor = FWD);
  }
}

support();

// shelf();
