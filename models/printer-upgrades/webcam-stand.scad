$fn = 64;
use <../../lib/3d.scad>
include <bosl2/std.scad>

size = [
  // x (width)
  20,
  // y (depth)
  45,
  // z (height)
  30,
];

thickness = 4;
slot_width = 6.5;
slot_margin = 10;
space_width = 12;
washer_outer_diameter = slot_width + 3;

module stand() {
  difference() {
    base();
    space();
    slot();
    screws();
  }
}

module base() {
  r = thickness / 2;
  path = [[r, -r], [size.y - r, -r], [r, -size.z + r]];
  rotate([ 90, 0, 90 ]) linear_extrude(size.x, center = true)
      stroke(path, closed = true, width = thickness);
}

module space() {
  space_size = [
    space_width,
    size.y,
    size.z,
  ];
  down(space_size.z / 2 + thickness + 0.1) back(space_size.y / 2 + thickness + 0.1)
      cube(space_size, center = true);
}

module slot() {
  slot_size = [ size.y - 2 * slot_margin, slot_width ];

  y = slot_size.x / 2 + (size.y - slot_size.x) / 2;
  down(thickness / 2) back(y) rotate([ 0, 0, 90 ]) linear_extrude(thickness + 0.2, center = true)
      rect(slot_size, rounding = slot_width / 2);
}

module screws() {
  down(size.z * 0.3) screw();
  down(size.z * 0.75) screw();
}

module screw() {
  back(thickness / 2) rotate([ -90, 0, 0 ])
      screw_hole_mask(h = thickness + 0.2, d_screw = 4, d_head = 8);
}

// The only screw I had was a bit too long so I need a tall washer
module washer(h) { tube(od = washer_outer_diameter, id = slot_width, h = h); }

stand();
// washer(h = 4);
// washer(h = 2);
