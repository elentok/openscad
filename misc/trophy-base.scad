include <BOSL2/std.scad>
$fn = 64;

d1 = 85;
d2 = 80;
d3 = 70;
d4 = 65;

h1 = 2;
h2 = 2;
h3 = 20;
h4 = 2;

// cylinder(d = d1, h = h1);
// up(h1) cylinder(d = d2, h = h2);
// up(h1 + h2) cylinder(d = d3, h = h3);
// up(h1 + h2 + h3) cylinder(d = d4, h = h4);

r = 5;

plaque_h = h3 - 4;
plaque_w = d3 - r * 2;

pin_d = 5;
pin_h = 5;
pin_h_plaque = 1;
pin_dist = plaque_w - pin_d - r * 2;

module base() {
  difference() {
    union() {
      linear_extrude(h1) rect([ d1, d1 ], rounding = r);
      up(h1) linear_extrude(h2) rect([ d2, d2 ], rounding = r);
      up(h1 + h2) linear_extrude(h3) rect([ d3, d3 ], rounding = r);
      up(h1 + h2 + h3) linear_extrude(h4) rect([ d4, d4 ], rounding = r);
    }

    up(h1 + h2 + h3 / 2) fwd(d3 / 2 - pin_h + pin_h_plaque) rotate([ 90, 0, 0 ])
        plaque_pins(is_mask = true);
  }
}

module plaque() {
  difference() {
    union() {
      linear_extrude(2) rect([ plaque_w, plaque_h ], rounding = r);
      up(2) linear_extrude(1) scale([ 1, 1.5, 1 ]) up(1.9) color("green")
          text("Saltomania", valign = "center", halign = "center", size = 6,
               font = "Arial Black");
    }

    down(pin_h + 1 - pin_h_plaque) plaque_pins(is_mask = true);
  }
}

module demo() {
  base();
  up(h1 + h2 + h3 / 2) fwd(d3 / 2) rotate([ 90, 0, 0 ]) plaque();
}

module plaque_pins(is_mask) {
  d = pin_d + (is_mask ? 0.1 : 0);
  h = pin_h + (is_mask ? 1 : 0);
  left(pin_dist / 2) plaque_pin(is_mask);
  right(pin_dist / 2) plaque_pin(is_mask);
}

module plaque_pin(is_mask) {
  d = pin_d + (is_mask ? 0.1 : 0);
  h = pin_h + (is_mask ? 1 : 0);
  cyl(d = d, h = h, anchor = BOTTOM);
}

// demo();
// base();
// plaque();
// plaque_pins(is_mask = false);
plaque_pin(is_mask = false);

// up(h1 + h2) cylinder(d = d3, h = h3);
// up(h1 + h2 + h3) cylinder(d = d4, h = h4);
