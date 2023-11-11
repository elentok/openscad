include <../../lib/countersunk-screw-mask.scad>
include <BOSL2/std.scad>
$fn = 64;

// Including tolarance
zip_tie_width = 8.5;
zip_tie_thickness = 2.2;

size = [ 35, 45, 10 ];
rounding = size.z / 2;

screw_offset = size.x / 2 - 4 - rounding;

module zip_tie_mount() {
  difference() {
    top_half() cuboid([ size.x, size.y, size.z * 2 ], rounding = rounding,
                      anchor = CENTER);

    zip_tie_mask();

    left(screw_offset) screw_mask();
    right(screw_offset) screw_mask();
  }
}

module zip_tie_mask() {
  up(zip_tie_width / 2) rotate([ 0, -90, 0 ])
      linear_extrude(zip_tie_width, convexity = 4, center = true)
          stroke(arc(64, points = [[size.z / 2, -size.y / 2], [0, 0],
                                   [size.z / 2, size.y / 2]]));
}

module screw_mask() { countersunk_screw_mask(h = size.z); }

zip_tie_mount();
// zip_tie_mask();
