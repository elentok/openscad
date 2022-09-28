use <../containers/box.scad>
include <BOSL2/std.scad>

size = [ 60, 38, 90 ];
rounding = 3;
thickness = 1.5;

module caddy() { box(size, rounding = rounding, thickness = thickness, separators_x = [17]); }

caddy();
