include <BOSL2/std.scad>
$fn = 64;

module half_yinyang(d, h) { linear_extrude(h) half_yinyang_2d(d); }

module half_yinyang_2d(d) {
  r = d / 2;

  difference() {
    union() {
      difference() {
        circle(d = d);
        rect([ d, r ], anchor = FWD);
      }

      circle(d = r, anchor = LEFT);
    }

    circle(d = r, anchor = RIGHT);
  }
}

color("white") half_yinyang(30, 3);
rotate(180) color("black") half_yinyang(30, 3);
