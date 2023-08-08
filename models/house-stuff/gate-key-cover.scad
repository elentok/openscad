include <BOSL2/std.scad>
$fn = 64;

h_min = 9.6;   // 9;
h_max = 9.8;   // 9.2;
w_min = 33.5;  // 33;
w_max = 38;    // 37.5;
l_min = 31;
l_max = 47;
d_button = 10.5;  // 9.7;
button_padding = 3;
margin = 7;  // 7.6;
wall = 1;
bump_height = 1;

module button_cover() {
  difference() {  // outer
    union() {
      linear_extrude(h_max + wall * 2, convexity = 4, center = true)
          body_slice(l_min, w_max + wall * 2);

      // bump
      up(h_max / 2) cuboid([ l_min, d_button + 6, wall + bump_height ],
                           anchor = LEFT + BOTTOM, rounding = wall);
    }

    // inner
    left(0.01 / 2) linear_extrude(h_max, convexity = 4, center = true)
        body_slice(l_min + 0.01, w_max);

    right(l_min - margin)
        cyl(d = d_button, h = h_max / 2 + bump_height + wall + 0.01,
            anchor = BOTTOM + RIGHT);
  }

  // extension
  difference() {
    linear_extrude(h_max + wall * 2, center = true)
        rect([ l_max - l_min, w_max + wall * 2 ], anchor = RIGHT);

    right(0.01 / 2) linear_extrude(h_max, center = true)
        rect([ l_max - l_min + 0.01, w_max ], anchor = RIGHT);
  }

  // intersection() {
  //   ellipse(d = [ ellipse_d1, ellipse_d2 ]);
  //   rect([ l_min, w_max ], anchor = LEFT);
  // }
}

module body_slice(l_min, w_max) {
  // ellipse_d1 = 2 * (l_min + (w_min * w_min) / (4 * l_min));
  ellipse_d1 = l_min * 4;
  ellipse_d2 = w_max;

  intersection() {
    ellipse(d = [ ellipse_d1, ellipse_d2 ]);
    rect([ l_min, w_max ], anchor = LEFT);
  }
}

button_cover();
