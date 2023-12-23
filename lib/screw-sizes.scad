include <BOSL2/std.scad>
include <BOSL2/structs.scad>

nut_diameters = [ [ "m3", 6.2 ], [ "m4", 7.8 ], [ "m5", 9 ], [ "1/4", 12.5 ] ];
nut_widths = [ [ "m3", 5.6 ], [ "m4", 6.8 ] ];
// TODO: measure the M5 nut height
nut_thicknesses = [ [ "m3", 2.5 ], [ "m4", 3.3 ], [ "m5", 4 ], [ "1/4", 5.6 ] ];

screw_diameters = [[ "m3", 3.3 ]];

function screw_d(type) = struct_val(screw_diameters, type);
function nut_d(type) = struct_val(nut_diameters, type);
function nut_h(type) = struct_val(nut_thicknesses, type);

// Using the pythagorean theorem:
//
//   (Width/2)^2 + (r/2)^2 = r^2
//
function nut_width(type) = sqrt(3) * nut_diameter(type) / 2;
