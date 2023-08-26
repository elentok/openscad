include <BOSL2/std.scad>
$fn = 64;

function rect_grill_hole_size(size, holes, space, padding) =
    let(isize = add_scalar(size,
                           -padding * 2))  // calculate inner size
        [(isize.x - (holes.x - 1) * space) / holes.x,
         (isize.y - (holes.y - 1) * space) / holes.y,
];

module rect_grill_mask(size, holes, space, padding = 0) {
  hole_size = rect_grill_hole_size(size, holes, space, padding);
  hole_offset = add_scalar(hole_size, space);

  fwd(padding) right(padding) {
    for (j = [0:holes.x - 1]) {
      right(j * hole_offset.x) {
        for (i = [0:holes.y - 1]) {
          fwd(i * hole_offset.y) rect_grill_hole(hole_size);
        }
      }
    }
  }
}

module rect_grill_hole(size) {
  rect(size, rounding = size.y / 2, anchor = LEFT + BACK);
}
