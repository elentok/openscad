use <../containers/box.scad>
include <BOSL2/std.scad>

thickness = 1.5;
size = [ 62, 42, 90 ];
rounding = 3;

module caddy() { box(size, rounding = rounding, thickness = thickness, separators_x = [18]); }

caddy();
