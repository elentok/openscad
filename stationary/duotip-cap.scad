include <BOSL2/std.scad>
$fn = 64;

d1 = 8.2;
h1 = 6;

d2 = 5.2;
h2 = 14;

height = h1 + h2 + 5;
dout = 9.5;

module cap() {
  difference() {
    cyl(d=dout, h=height, anchor=BOTTOM, rounding2=1);

    down(0.01) cyl(d=d1, h=h1, rounding2=0.2, rounding1=-0.4, anchor=BOTTOM);
    up(h1 - 0.02) cyl(d=d2, h=h2, anchor=BOTTOM, rounding1=-0.3, rounding2=1);

    fwd(1.5) cyl(d=1.5, rounding=-0.2, h=height + 0.01, anchor=BOTTOM);
    back(1) left(1.5) cyl(d=1.5, rounding=-0.2, h=height + 0.01, anchor=BOTTOM);
    back(1) right(1.5) cyl(d=1.5, rounding=-0.2, h=height + 0.01, anchor=BOTTOM);
  }
}

cap();
