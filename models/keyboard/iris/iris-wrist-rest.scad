include <BOSL2/rounding.scad>
include <BOSL2/std.scad>
$fn = 64;

// without the keycaps
kb_case_height = 22;

back_width1 = 65;
back_width2 = 65;
back_width = back_width1 + back_width2;
back_depth1 = 18;
back_depth2 = 35;

rest_depth = 60;

path = [
  [ 0, 0 ], [ back_width1, 0 ], [ back_width1, back_depth1 ],
  [ back_width1 + back_width2, back_depth2 ], [ back_width1 + 45, rest_depth ],
  [ 0, rest_depth ]
];

// rounded_base = round2d(r = 5) polygon(points = path);
// rounded_base = rounded_corners(polygon(points = path);
// rounded_base = path;

module base() {
  // rounded_base = round_corners(path, r = 5);
  // rounded_prism(path, height = kb_case_height, joint_top = 3, joint_sides =
  // 5);

  rounded_prism(path3d(path),
                apply(affine3d_skew_yz(0, -10), path3d(path, kb_case_height)),
                height = kb_case_height, joint_top = 5, joint_sides = 5);

  // // apply(affine3d_skew_yz(0, -20),
  // mirror([ 0, 1, 0 ]) offset_sweep(rounded_base, height = kb_case_height,
  //                                  joint_top = 0.5, steps = 64);
  // height = kb_case_height, top = os_circle(r = 5), steps = 64);
}

base();
// top_half(back_width * 2) rotate([ 12, 0, 0 ]) base();

// difference() {
//   linear_extrude(kb_case_height, convexity = 4) round2d(r = 5)
//       mirror([ 0, 1, 0 ]) polygon(points = path);
//
//   left(0.01 / 2) up(kb_case_height) rotate([ 12, 0, 0 ])
//       cuboid([ back_width + 0.01, rest_depth + 20, kb_case_height ],
//              anchor = BACK + LEFT + BOTTOM);
// }
