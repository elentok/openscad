include <BOSL2/std.scad>
$fn = 64;

size = [ 80, 60, 50 ];
rounding = 2;
dumbbell_thread_d = 32;

// hole for the bottom of the dumbbell nut
nut_d = 50;
nut_h = 6.5;

module block() {
  difference() {
    cuboid(size, rounding = rounding);

    cyl(d = dumbbell_thread_d, h = size.z + 0.01);
    up(size.z / 2 - nut_h) cyl(d = nut_d, h = nut_h + 0.01, anchor = BOTTOM);
  }
}

block();
