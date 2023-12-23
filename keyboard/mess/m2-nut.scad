include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

// w1 = 15 (3x side => 6)
// w2 = 8 (4x side => 8)

threaded_nut(nutwidth = 8, id = 2.2, h = 3.5, pitch = 0.25, end_len1 = 0.5,
             lead_in1 = 3);

// difference() { linear_extrude(h) hexagon(d = 8, rounding = 1); threaded_rod }
// nut("M2", thickness = "thick");
