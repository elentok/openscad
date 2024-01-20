include <../../lib/bin.scad>
include <../../lib/screw-masks.scad>
// include <../../lib-old/honeycomb.scad>
include <../../lib-old/rect-grill.scad>
include <BOSL2/std.scad>
$fn = 64;

// Configurable parameters:
shelf_size = [ 170, 84, 70 ];
wall_thickness = 2.5;
rounding = 10;
// screw_hole_diameter = 4.2;
screw_hole_distance_from_top = 15;
screw_hole_distance_from_side = 25;

pattern_margin = 10;
pattern_bottom_size =
    [ shelf_size.x - pattern_margin * 2, shelf_size.y - pattern_margin * 2 ];

module shelf() {
  diff() {
    bin(shelf_size, wall_thickness, [ 0, 0, rounding, rounding ],
        irounding =
            [ 3, 3, rounding - wall_thickness, rounding - wall_thickness ],
        anchor = BOTTOM + BACK, strengtheners = true) {
      tag("remove") down(screw_hole_distance_from_top)
          right(screw_hole_distance_from_side) position(LEFT + BACK + TOP)
              shelf_screw_hole_mask();
      tag("remove") down(screw_hole_distance_from_top)
          left(screw_hole_distance_from_side) position(RIGHT + BACK + TOP)
              shelf_screw_hole_mask();

      // tag("remove") down(shelf_size.z / 2 + 0.005)
      //     left(pattern_bottom_size.x / 2) back(pattern_bottom_size.y / 2)
      //         linear_extrude(wall_thickness + 0.01) rect_grill_mask(
      //             pattern_bottom_size, holes = [ 10, 5 ], space = 5);
      //
      // tag("remove") rotate([ 0, 90, 0 ])
      //     hexagon_cyl(d = shelf_size.z / 2, h = shelf_size.x + 0.01);

      // tag("remove") left(shelf_size.z / 2) rotate([ 0, 90, 90 ])
      //     hexagon_cyl(d = shelf_size.z / 2, h = shelf_size.y + 0.01);
      //
      // tag("remove") right(shelf_size.z / 2) rotate([ 0, 90, 90 ])
      //     hexagon_cyl(d = shelf_size.z / 2, h = shelf_size.y + 0.01);
    }
  }
}

module hexagon_cyl(d, h) { linear_extrude(h, center = true) hexagon(d = d); }

module shelf_screw_hole_mask() {
  screw_hole_maskx(axis = BACK, anchor = BACK, screw_type = "m4",
                   countersink = true, l_wall = wall_thickness,
                   max_countersink_leftover = 1.5,
                   l_screwdriver = shelf_size.y);
}

shelf();
// strengthener(r = 10, w = 50);
