include <BOSL2/std.scad>
use <../../lib/grill.scad>
use <../../lib/screw-hole-mask.scad>
$fn = 64;

thickness = 2.5;
depth = 20;

tube_od = 112;
tube_thickness = 2.5;

id = tube_od + tube_thickness;
od = id + thickness;

module wrap_around() {
  difference() {
    union() {
      tube(od = od, id = id, h = depth + thickness, anchor = BOTTOM);
      tube(od = id, id = tube_od, h = thickness, anchor = BOTTOM);
      grill(d = tube_od, h = thickness);
    }

    up(depth / 2) rotate([ 0, 90, 0 ]) cyl(d = 4.2, h = od + 10);
    up(depth / 2) rotate([ 0, 90, 90 ]) cyl(d = 4.2, h = od + 10);
  }
}

module flat_filter() {
  padding = 15;
  id = tube_od - tube_thickness;
  od = id + padding * 2;
  difference() {
    union() {
      tube(od = od, id = id, h = thickness, anchor = BOTTOM);
      // tube(od = id, id = tube_od, h = thickness, anchor = BOTTOM);
      // tube(od = id, id = tube_od, h = thickness, anchor = BOTTOM);
      grill(d = id, h = thickness);
    }

    down(0.01 / 2) fwd(od / 2 + 2)
        cuboid([ od, padding, thickness + 0.01 ], anchor = FWD + BOTTOM);
    back(id / 2 + padding / 2) flat_filter_hole();
    rotate([ 0, 0, 20 ]) right(id / 2 + padding / 2) flat_filter_hole();
    rotate([ 0, 0, -20 ]) left(id / 2 + padding / 2) flat_filter_hole();
  }
}

module flat_filter_hole() {
  down(0.01)
      screw_hole_mask(d_screw = 4, d_screw_head = 8, l_wall = thickness + 0.02,
                      l_countersink = 1, axis = UP, anchor = BOTTOM);
}

flat_filter();
// wrap_around();
