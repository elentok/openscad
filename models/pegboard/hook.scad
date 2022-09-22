include <../lib/2d.scad>
use <./mount.scad>
include <./variables.scad>
include <BOSL2/std.scad>

hook_width = pb_peg_diameter;
hook_thickness = 4;

module hook(width = hook_width) {
  mount(bar_width = width, rounding = 0);
  circle(d = hook_thickness);
}

hook();
