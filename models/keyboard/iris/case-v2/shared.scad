include <./vars.scad>
include <BOSL2/std.scad>
$fn = 64;

module bolt_holder(hole = true, corner = false, nut = false) {
  difference() {
    linear_extrude(bolt_holder_h, convexity = 4) bolt_holder_2d(hole, corner);
    if (nut) {
      up(bolt_holder_h - nut_h + epsilon) nut_mask();
    }
  }
}

module nut_mask() { linear_extrude(nut_h) hexagon(d = nut_d); }

module bolt_holder_2d(hole = true, corner = false) {
  od = bolt_holder_d;

  if (corner == "side1") {
    rotate([ 0, 0, -90 ]) left(od) bolt_holder_side();
  } else if (corner == "side2") {
    fwd(od / 4) mirror([ 1, 0, 0 ]) left(od * 0.75) scale(0.5)
        bolt_holder_side();
  } else {
    left(od) bolt_holder_side();
    mirror([ 1, 0, 0 ]) left(od) bolt_holder_side();
  }

  difference() {
    rounding = corner ? [ od / 2, 0, 0, 0 ] : [ od / 2, od / 2, 0, 0 ];
    rect([ od, od ], rounding = rounding);
    if (hole) {
      circle(d = bolt_hole_d);
    }
  }
}

module bolt_holder_side() {
  od = bolt_holder_d;
  difference() {
    rect([ od / 2, od / 2 ], anchor = BACK + LEFT);
    circle(d = od);
  }
}
