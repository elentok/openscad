include <BOSL2/std.scad>
include <BOSL2/structs.scad>

nut_diameters = [ [ "m3", 6.2 ], [ "m4", 7.8 ], [ "m5", 9 ], [ "1/4", 12.5 ] ];
// TODO: add missing nut widths
nut_widths = [ [ "m3", 5.6 ], [ "m4", 6.8 ] ];
// TODO: measure the M5 nut height
nut_thicknesses = [ [ "m3", 2.5 ], [ "m4", 3.3 ], [ "m5", 4 ], [ "1/4", 5.6 ] ];

screw_hole_diameters =
    [ [ "m3", 3.3 ], [ "m4", 4.3 ], [ "m5", 5.2 ], [ "1/4", 6.5 ] ];

screw_head_diameters = [ [ "m4", 7.4 ], [ "m5", 10.2 ] ];
screw_head_heights = [ [ "m4", 3.3 ], [ "m5", 3.6 ] ];

function screw_hole_d(type) = struct_val(screw_hole_diameters, type);
function screw_head_d(type) = struct_val(screw_head_diameters, type);
function screw_head_h(type) = struct_val(screw_head_heights, type);
function nut_d(type) = struct_val(nut_diameters, type);
// function nut_w(type) = struct_val(nut_widths, type);
function nut_h(type) = struct_val(nut_thicknesses, type);

// Using the pythagorean theorem:
//
//   (Width/2)^2 + (r/2)^2 = r^2
//
function nut_w(type) = sqrt(3) * nut_d(type) / 2;
