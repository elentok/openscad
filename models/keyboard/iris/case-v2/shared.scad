include <./vars.scad>
include <BOSL2/std.scad>
$fn = 64;

module bolt_holder(hole = true, corner = false, nut = false,
                   full_height = false, mask = false) {
  s = mask ? add_scalar(bolt_holder_size, bolt_holder_tolerance)
           : bolt_holder_size;
  h = full_height ? mid_layer_h : s.z;
  difference() {
    linear_extrude(h, convexity = 4) bolt_holder_2d(hole, corner, mask = mask);
    if (nut) {
      up(h - nut_h + epsilon) nut_mask();
    }
  }
}

module nut_mask() { linear_extrude(nut_h) hexagon(d = nut_d); }

module bolt_holder_2d(hole = true, corner = false, mask = false) {
  s = mask ? add_scalar(bolt_holder_size, bolt_holder_tolerance)
           : bolt_holder_size;

  if (corner == "y") {
    left((s.x - s.y) / 2) back(s.y) rotate([ 0, 0, -90 ])
        bolt_holder_side(mask);
  } else if (corner == "x") {
    right(s.y / 2 + s.x / 2) mirror([ 1, 0, 0 ]) bolt_holder_side(mask);
  } else {
    x = s.y / 2 + s.x / 2;
    left(x) bolt_holder_side(mask);
    mirror([ 1, 0, 0 ]) left(x) bolt_holder_side(mask);
  }

  difference() {
    rounding = corner ? [ s.y / 2, 0, 0, 0 ] : [ s.y / 2, s.y / 2, 0, 0 ];
    rect([ s.x, s.y ], rounding = rounding);
    if (hole) {
      bolt_hole_padding = (s.y - bolt_hole_d) / 2;
      bolt_hole_size = [ s.x - bolt_hole_padding * 2, bolt_hole_d ];
      rect(bolt_hole_size, rounding = bolt_hole_d / 2);
    }
  }
}

module bolt_holder_side(mask = false) {
  od = mask ? bolt_holder_size.y + bolt_holder_tolerance : bolt_holder_size.y;
  difference() {
    rect([ od / 2, od / 2 ], anchor = BACK + LEFT);
    circle(d = od);
  }
}
