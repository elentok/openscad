use <BOSL2/std.scad>
include <mount.scad>
use <variables.scad>

hook_width = pb_peg_diameter;

module hook(width = hook_width) { mount(width); }
