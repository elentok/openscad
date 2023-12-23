include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

module screw_adapter(outer_spec, inner_spec, height) {
  difference() {
    screw(outer_spec, l = height, bevel2 = false);
    screw_hole(inner_spec, l = height + 0.01, thread = true);
  }
}

screw_adapter("1/4-20", "M3", 20);
