include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
edge_radius = 1;
bottom_radius = 1;
thickness = 2;
// diameter = 30;

// text_value = "1";
// text_xoffset = 0;

font = "Google Sans:style=Bold";

module all_coins() {
  coin1();
  right(30) coin2();
  right(60) coin3();
}

module coin1() { coin(text = "1", text_xoffset = -1.2, diameter = 20); }

module coin2() { coin(text = "2", diameter = 25); }

module coin3() { coin(text = "3", diameter = 30); }

module coin(diameter, text, text_xoffset = 0, faces = 64) {
  difference() {
    rotate_extrude($fn = faces) coin_flat(diameter);
    coin_text(text, text_xoffset, diameter);
  }
}

module coin_flat(diameter) {
  // flat bottom
  square([ diameter / 2 - bottom_radius, thickness ], anchor = LEFT + FWD);

  hull() {
    // bottom circle
    right(diameter / 2 - bottom_radius) circle(r = bottom_radius, anchor = FWD);

    // top edge
    right(diameter / 2 - edge_radius) back(edge_radius)
        circle(r = edge_radius, anchor = FWD);
  }
}

module coin_text(text, text_xoffset, diameter) {
  font_size = (diameter - 2 * edge_radius) / 2;
  right(text_xoffset) down(nothing / 2) linear_extrude(thickness + nothing)
      offset(r = +0.5) offset(r = -0.5)
          text(text, halign = "center", valign = "center", size = font_size,
               font = font);
}

all_coins();
