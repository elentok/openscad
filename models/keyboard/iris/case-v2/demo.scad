include <./vars.scad>
include <BOSL2/std.scad>
use <./case.scad>
use <./magnetic-plate.scad>
use <./wrist-rests.scad>
$fn = 64;

color("green") mid_layer_left();
fwd(case_left_depth) color("blue") wrist_rest_left();
// right(130) rotate([ 0, 0, -25 ]) fwd(mplate_size.y / 2) right(mplate_size.x /
// 2)
//     color("orange") magnetic_plate();
