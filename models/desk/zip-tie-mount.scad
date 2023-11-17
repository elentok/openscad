include <../../lib/countersunk-screw-mask.scad>
include <BOSL2/std.scad>
$fn = 64;

layer_height = 0.3;

// Including tolarance
zip_tie_width = 8.5;
zip_tie_thickness = 2.5;

size = [ 35, 35, 8 ];
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
  path = arc(64, points = [[size.z / 2, -size.y / 2], [0, 0],
                           [size.z / 2, size.y / 2]]);

  up(zip_tie_thickness / 2 + layer_height) rotate([ 0, -90, 0 ])
      linear_extrude(zip_tie_width, convexity = 4, center = true)
          stroke(path, width = zip_tie_thickness);
}

module screw_mask() {
  down(0.01 / 2)
      countersunk_screw_mask(h = size.z + 0.01, h_above = size.z / 2);
}

zip_tie_mount();
// zip_tie_mask();
