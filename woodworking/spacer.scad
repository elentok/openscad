include <BOSL2/std.scad>
$fn = 64;

// label = "1.5mm";
spacer_size = [ 200, 40, 1.5 ];

// // hole_d = 20;
// // holes_x = 5;
// //
// // difference() {
// //   cuboid(size, anchor);
// //
// //   for (ix = [1:holes_x]) {
// //     x = holes cyl(d = hole_d, h = size.z + 0.1);
// //   }
// // }
//
// // Use BOSL2
// include <BOSL2/constants.scad>
// include <BOSL2/std.scad>
//
// // Parameters
// size = [ 100, 20, 10 ];   // Overall size of the spacer (X, Y, Z)
holes_x = 5;              // Number of holes along X-axis
hole_to_space_ratio = 1;  // Ratio of hole diameter to space between holes
//
// module spacer(size, holes_x, hole_to_space_ratio = 1) {
//   x = size[0];
//   y = size[1];
//   z = size[2];
//
//   // Compute spacing and hole diameter
//   spacing = x / (holes_x + 1);
//   hole_d = spacing * hole_to_space_ratio /
//            (1 + hole_to_space_ratio);  // adjust for ratio
//   offset = spacing;
//
//   difference() {
//     // Main body
//     cuboid(size, anchor = CENTER);
//
//     // Holes
//     for (i = [1:holes_x]) {
//       translate([ -x / 2 + i * spacing, 0, 0 ]) cylinder(
//           d = hole_d, h = z + 2, center = true);  // +2 to guarantee cut
//           through
//     }
//   }
// }
//

module spacer(size, holes_x, hole_to_space_ratio = 1) {
  x = size[0];
  y = size[1];
  z = size[2];

  // Compute spacing and hole diameter
  spacing = x / (holes_x + 1);
  hole_d = spacing * hole_to_space_ratio / (1 + hole_to_space_ratio);

  difference() {
    // Main block
    cuboid(size, anchor = CENTER);

    // Vertical holes along Z axis
    for (i = [1:holes_x]) {
      translate([ -x / 2 + i * spacing, 0, 0 ])
          cylinder(d = hole_d, h = z + 2,
                   center = true);  // Add buffer to guarantee full cut
    }

    // Engraved text at center, 1mm deep pocket
    translate([ 0, size.y / 2 - 6, z / 2 - 0.5 ])  // on top surface
        linear_extrude(height = 1)
            text(str(z, "mm"), halign = "center", valign = "center", size = 6,
                 font = "Arial:style=Bold");  // size is adjustable
  }
}

// Example usage
spacer(size = spacer_size, holes_x = holes_x,
       hole_to_space_ratio = hole_to_space_ratio);
