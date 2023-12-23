include <BOSL2/std.scad>
use <../../lib/screw-hole-mask.scad>
$fn = 64;

hole_dist = 55;
hole_size = 4.5;
base_size = [ 40, 75, 5 ];
rounding = 2;

thickness = 1.5;
tube_od = 10;
tube_ir = 10;

// od = the outer diameter of the tube itself
// ir = the inner radius of the angle
module angled_tube(od, ir, thickness) {
  rotate_extrude(angle = 90) translate([ od / 2 + ir, od / 2 ]) difference() {
    circle(d = od);
    circle(d = od - thickness * 2);
  }
}

// od = the outer diameter of the tube itself
// ir = the inner radius of the angle
module angled_half_tube(od, ir, thickness) {
  id = od - thickness * 2;
  rotate_extrude(angle = 90) translate([ od / 2 + ir, od / 2 ]) difference() {
    rect([ od, od ], rounding = [ od / 2, od / 2, 2, 2 ]);
    rect([ id, id ], rounding = [ id / 2, id / 2, 2, 2 ]);
  }
}

module ring(id, thickness) {
  rotate_extrude() back(thickness / 2) right(thickness / 2 + id / 2)
      circle(d = thickness);
}

module half_rod(d, l) {
  linear_extrude(l, convexity = 4)
      rect([ d, d ], rounding = [ d / 2, d / 2, 2, 2 ]);
}

module base() {
  difference() {
    down(base_size.z) top_half() cuboid(
        [ base_size.x, base_size.y, base_size.z * 2 ], rounding = rounding);

    for (x = [ -10, 10 ]) {
      right(x) {
        back(hole_dist / 2) base_screw_hole();
        fwd(hole_dist / 2) base_screw_hole();
      }
    }
  }
}

module base_screw_hole() {
  screw_hole_mask(d_screw = hole_size, d_screw_head = 10,
                  l_wall = base_size.z + 0.01, l_screwdriver = 0,
                  l_countersink = 1, axis = TOP, anchor = TOP);
}

module arm() {
  space = 20;
  d = 10;

  fillet_r = 6;
  cyl_height = 55 - space / 2;

  // half ring
  up(cyl_height) rotate([ 90, 0, 90 ]) rotate_extrude(angle = 180)
      right(d / 2 + space / 2) circle(d = d);

  // cylinders
  back(space / 2) {
    cyl(d = d, h = cyl_height, anchor = BOTTOM + FWD);
    cyl_fillet(fillet_r, cyl_d = d, anchor = BOTTOM + FWD);
  }

  fwd(space / 2) {
    cyl(d = d, h = cyl_height, anchor = BOTTOM + BACK);
    cyl_fillet(fillet_r, cyl_d = d, anchor = BOTTOM + BACK);
  }
}

module cyl_fillet(fillet_r, cyl_d, anchor) {
  attachable(d = cyl_d, h = fillet_r, anchor) {
    down(fillet_r / 2) rotate_extrude() left(fillet_r + cyl_d / 2)
        back(fillet_r) difference() {
      rect([ fillet_r, fillet_r ], anchor = BACK + LEFT);
      circle(r = fillet_r);
    }
    children();
  }
}

base();
arm();
