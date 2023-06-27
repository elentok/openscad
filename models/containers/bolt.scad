include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

h = 120;
wall = 2;

size = 30;
size_name = str("M", size);
scale_factor = 2.5;

module the_bolt()
{
    difference()
    {
        scale(scale_factor) screw(size_name, l = h / scale_factor, anchor = BOTTOM, bevel1 = false);
        down(0.01) cylinder(d = 59, h = h - 8, anchor = BOTTOM);
    }
}

module the_nut()
{
    scale(scale_factor) nut(size_name, ibevel = false, anchor = BOTTOM, thickness = 20, $slop = 0.6);
    cyl(d = size * scale_factor * 1.1, h = wall, anchor = BOTTOM);
}

the_nut();
up(100) the_bolt();

// nut("M50x4", thickness = 100, nutwidth = 100, width = 100);

// echo(nut_info("M20"));
