include <./vars.scad>
include <BOSL2/std.scad>
use <./case.scad>
use <./wrist-rests.scad>
$fn = 64;

color("green") mid_layer_left();
fwd(case_left_depth) color("blue") wrist_rest_left();
