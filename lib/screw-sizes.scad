include <BOSL2/std.scad>
include <BOSL2/structs.scad>

nut_diameters = [[ "m3", 6.2 ]];
nut_widths = [[ "m3", 5.6 ]];
nut_thicknesses = [[ "m3", 2.5 ]];

screw_diameters = [[ "m3", 3.3 ]];

function screw_diameter(type) = struct_val(screw_diameters, type);
function nut_diameter(type) = struct_val(nut_diameters, type);
function nut_thickness(type) = struct_val(nut_thicknesses, type);

// Using the pythagorean theorem:
//
//   (Width/2)^2 + (r/2)^2 = r^2
//
function nut_width(type) = sqrt(3) * nut_diameter(type) / 2;
