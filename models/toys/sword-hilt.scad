$fn = 50;

module hilt(radius, depth) {
  difference() {
    hull() { rotate_extrude() translate([ 40, 0 ]) circle(r = 20); }

    translate([ 40, 0, 0 ]) rotate([ 0, -90, 0 ]) cylinder(r = 14, h = 120);

    translate([ 0, 0, 20 - 2 ]) linear_extrude(4) rotate([ 0, 0, 90 ])
        text("name", size = 20, valign = "center", halign = "center");
  }
}

hilt(radius = 40, depth = 30);
