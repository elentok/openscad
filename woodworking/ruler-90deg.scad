include <BOSL2/std.scad>
$fn = 64;

ilen1 = 45;
ilen2 = 100;
// ilen1 = 80;   // 40
// ilen2 = 150;  // 80
hole_d = 5;
thickness = 8;
width = 25;

bar_len = width / 4;
bar_len_long = bar_len * 1.2;
long_bar_every = 5;
bar_margin = 1.6;

module ruler() {
  difference() {
    linear_extrude(thickness, center = true) ruler2d();
    // down(thickness / 2) inner_bars();
    // up(thickness / 2) inner_bars();
    // down(thickness / 2) outer_bars();
    // up(thickness / 2) outer_bars();
  }
}

module ruler2d() {
  difference() {
    union() {
      left(width) rect([ ilen1 + width, width ], anchor = FWD + LEFT);
      rect([ width, ilen2 ], anchor = BACK + RIGHT);
    }

    circle(d = hole_d);
  }
}

module outer_bars() {
  back(width) left(width - bar_margin) mirror([ 1, 0, 0 ]) bars(ilen2 / 10 + 1);
  back(width - bar_margin) left(width) rotate([ 0, 0, 90 ])
      bars(ilen1 / 10 + 1);
}

module inner_bars() {
  left(bar_margin) bars(ilen2 / 10 - 1);
  back(bar_len + bar_margin) rotate([ 0, 0, 90 ]) bars(ilen1 / 10 - 1);
}

module bars(n) {
  for (i = [1:n]) {
    fwd(i * 10) bar(i);
  }
}

module bar(i) {
  len = i % long_bar_every == 0 ? bar_len_long : bar_len;
  cuboid([ len, 0.4, 1.2 ], anchor = RIGHT);
}

ruler();
