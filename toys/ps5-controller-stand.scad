include <BOSL2/std.scad>
$fn = 64;

id_bottom = 34;
id_top = 50;
thickness = 4;
od_bottom = id_bottom + thickness * 2;
od_top = id_top + thickness * 2;
dist = 130;
bottom_thickness = 5;

bottom_size = [ dist + od_bottom, od_bottom ];
holder_height = 34;
epsilon = 0.01;

back_support = 130;
font = "Google Sans:style=Bold";
// back_support = dist + od_bottom;

module stand() {
  base();

  up(bottom_thickness - epsilon) {
    left(dist / 2) holder();
    right(dist / 2) holder();
  }

  back(back_support / 4) up(bottom_thickness - epsilon) linear_extrude(2)
      text("Hello World", font = font, size = 10, halign = "center",
           valign = "center");
}

module base() {
  linear_extrude(bottom_thickness) round2d(15) {
    difference() {
      rect(bottom_size, rounding = od_bottom / 2);
      // fwd(bottom_size.y / 4)
      //     rect([ bottom_size.x / 4, bottom_size.y / 4 ], anchor = BACK);
      scale([ 1, 1.2 ]) fwd(bottom_size.y / 8)
          circle(d = bottom_size.x * 0.8, anchor = BACK);
    }
    difference() {
      circle(d = back_support);
      rect([ back_support, back_support ], anchor = BACK);
    }
  }
}

module base1() {
  linear_extrude(bottom_thickness) rect(bottom_size, rounding = od_bottom / 2);
  support();
}

module holder() {
  tube(od1 = od_bottom, id1 = id_bottom, od2 = od_top, id2 = id_top,
       h = holder_height, anchor = BOTTOM);
}

module support() {
  back_half(200) {
    cyl(d = back_support, h = bottom_thickness, anchor = BOTTOM);
  }
}

stand();
