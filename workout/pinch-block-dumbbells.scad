include <BOSL2/std.scad>
$fn = 64;

size = [ 80, 60, 50 ];
rounding = 5;
dumbbell_thread_d = 30;

module block() {
  difference() {
    cuboid(size, rounding = rounding);

    cyl(d = dumbbell_thread_d, h = size.z + 0.01);
  }
}

block();
