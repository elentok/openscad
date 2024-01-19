include <BOSL2/std.scad>
$fn = 64;

type = "traveler-regular";
// type = "a6";
// type = "moleksin-pocket"

notebook_thickness = 4;
notebooks = 3;
wall_thickness = 2.4;
tolerance = [ 1, 1, 1 ];

notebook_size = type == "traveler-regular" ? [ 110, 210 ]
                : type == "a6"             ? [ 105, 148 ]
                                           : [ 90, 140 ];

case_inner_size = [
  notebook_size.x + tolerance.x,
  notebook_size.y + tolerance.y,
  notebooks* notebook_thickness + tolerance.z,
];

case_outer_size = [
  case_inner_size.x + wall_thickness,
  case_inner_size.y + wall_thickness * 2,
  case_inner_size.z + wall_thickness * 2,
];

module notebook_case() {
  difference() {
    cuboid(case_outer_size, rounding = wall_thickness, anchor = LEFT);
    right(wall_thickness + 0.01) cuboid(case_inner_size, anchor = LEFT);
  };
}

notebook_case();
