include <BOSL2/std.scad>
use <../../lib/thumb-mask.scad>
$fn = 64;

notepad_size = [ 63, 4, 105 ];
thickness = 1.5;
thumb_width = 20;
thumb_height = 20;
thumb_rounding = 10;

outer_size = [
  notepad_size.x + thickness * 2, notepad_size.y + thickness * 2,
  notepad_size.z +
  thickness
];

module notepad_case() {
  difference() {
    cuboid(outer_size, anchor = BOTTOM, rounding = thickness);
    up(thickness + 0.01) cuboid(notepad_size, anchor = BOTTOM);

    // thumb mask
    up(outer_size.z) rotate([ 90, 0, 0 ])
        linear_extrude(outer_size.y + 0.01, center = true)
            thumb_mask(width = thumb_width, height = thumb_height,
                       rounding = thumb_rounding);
  }
}

// module thumb_mask() {
//   up(outer_size.z - thumb_diameter * 1.5) rotate([ 90, 0, 0 ])
//       linear_extrude(outer_size.y + 1, center = true) thumb_mask_2d();
// }
//
// module thumb_mask_2d() {
//   d = thumb_diameter;
//   circle(d = d, anchor = FWD);
//   back(d / 2) rect([ d, d ], anchor = FWD);
//
//   round2d(d / 2) {
//     back(d / 2) rect([ d, d ], anchor = FWD);
//     back(d * 1.5) rect([ d * 2, d ], anchor = FWD);
//   }
// }

notepad_case();

// thumb_mask(width = 10, height = 20, rounding = 5, wall_thickness = 3);
