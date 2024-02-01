include <BOSL2/std.scad>
$fn = 64;

size = [ 80, 60, 45 ];
rounding = 2;
hole_d = 8.5;
hole_spacing = 20;

// hole for the bottom of the dumbbell nut
nut_d = 50;
nut_h = 6.5;

module block() {
  difference() {
    cuboid(size, rounding = rounding);

    cyl(d = hole_d, h = size.z + 0.01);
    right(hole_spacing) cyl(d = hole_d, h = size.z + 0.01);
    left(hole_spacing) cyl(d = hole_d, h = size.z + 0.01);
    // cyl(d = dumbbell_thread_d, h = size.z + 0.01);
    // up(size.z / 2 - nut_h) cyl(d = nut_d, h = nut_h + 0.01, anchor = BOTTOM);
  }
}

block();
