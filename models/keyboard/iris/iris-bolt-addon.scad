include <BOSL2/std.scad>
$fn = 64;

bolt_d = 7;
od = 13;
h = 12.8;

module addon() { linear_extrude(h) addon2d(); }

module addon2d() {
  left(od) side();
  mirror([ 1, 0, 0 ]) left(od) side();

  difference() {
    rect([ od, od ], rounding = [ od / 2, od / 2, 0, 0 ]);
    circle(d = bolt_d);
  }
}

module side() {
  difference() {
    rect([ od / 2, od / 2 ], anchor = BACK + LEFT);
    circle(d = od);
  }
}

module addon_corner() { linear_extrude(h) addon_corner2d(); }

module addon_corner2d() {
  rotate([ 0, 0, -90 ]) left(od) side();
  fwd(od / 4) mirror([ 1, 0, 0 ]) left(od * 0.75) scale(0.5) side();

  difference() {
    rect([ od, od ], rounding = [ od / 2, 0, 0, 0 ]);
    circle(d = bolt_d);
  }
}

addon_corner();
