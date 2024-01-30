include <BOSL2/std.scad>
use <../lib/thumb-mask.scad>
$fn = 64;

type = "fieldnotes";
// type = "traveler-regular";
// type = "a6";

notebook_thickness = 3.2;
notebooks = 3;
wall_thickness = 2;
tolerance = [ 1, 1, 1 ];
thumb_size = [ 20, 30 ];
rubberband_size = [ 2.5, 23 ];

notebook_size = type == "traveler-regular" ? [ 110, 210 ]
                : type == "fieldnotes"     ? [ 90, 140 ]
                                           : [ 105, 148 ];

// to make space for the rubber band hole
side_thickness = rubberband_size.x + wall_thickness * 2;

case_inner_size = [
  notebook_size.x + tolerance.x,
  notebook_size.y + tolerance.y,
  notebooks* notebook_thickness + tolerance.z,
];

case_outer_size = [
  case_inner_size.x + wall_thickness + side_thickness,
  case_inner_size.y + wall_thickness * 2,
  case_inner_size.z + wall_thickness * 2,
];

module notebook_case() {
  difference() {
    cuboid(case_outer_size, rounding = wall_thickness, anchor = LEFT);
    right(wall_thickness + side_thickness + 0.01)
        cuboid(case_inner_size, anchor = LEFT);
    right(case_outer_size.x - thumb_size.x) rotate([ 0, 0, -90 ])
        thumb_mask([ thumb_size.y, thumb_size.x, case_outer_size.z + 0.01 ],
                   rounding = 10, anchor = FWD);

    rubberband_hole_mask();
    back(case_outer_size.y / 4) rubberband_hole_mask();
    fwd(case_outer_size.y / 4) rubberband_hole_mask();
  };
}

module rubberband_hole_mask() {
  right(wall_thickness * 2) cuboid(
      [ rubberband_size.x, rubberband_size.y, case_outer_size.z + 0.01 ]);
}

notebook_case();
