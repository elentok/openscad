include <BOSL2/std.scad>
$fn = 64;

mug_id = 68;
mug_od = 77;

outer_h = 10;
inner_h = 10;
thickness = 3;
side_thickness = 2;

module part1() {
  od = mug_od + side_thickness * 2;

  cyl(d=od, h=thickness, anchor=TOP, rounding1=thickness / 2);
  tube(od=od, id=mug_od, h=outer_h, anchor=BOTTOM, irounding1=-1, rounding2=0.5);
}

module part2() {
  cyl(d=mug_id, h=inner_h, anchor=TOP, rounding1=1);
}

module stacker() {
  up(thickness) part1();
  part2();
}

stacker();
// part1();
// part2();
