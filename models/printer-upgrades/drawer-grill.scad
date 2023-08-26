include <BOSL2/std.scad>
use <../../lib/rect-grill.scad>
$fn = 64;

grill_size = [ 345, 60 ];
thickness = 2.5;
side_depth = 40;

grip_depth = 10;

grill_padding = 10;
grill_holes = [ 6, 4 ];
grill_space = 5;

grill_hole_size =
    rect_grill_hole_size(size = grill_size, holes = grill_holes,
                         space = grill_space, padding = grill_padding);

echo("Grill hole size:", grill_hole_size);

module grill() {
  rotate([ -90, 0, 0 ]) linear_extrude(thickness) grill2d();
  cuboid([ grill_size.x, grip_depth + thickness, thickness ], anchor = FWD);
}

module side2d() {
  difference() {
    side_base2d();

    side_grill_slit_width = side_depth - grill_padding * 2;

    // x_offset = grill_slit_width + grill_slits_x_space;
    z_offset = grill_slit_height + grill_slits_z_space;
    fwd(grill_padding) left(grill_padding) {
      // for (j = [0:grill_slits_x_count - 1]) {
      // right(j * x_offset) {
      for (i = [0:grill_slits_z_count - 1]) {
#fwd(i* z_offset)
        rect([ side_grill_slit_width, grill_slit_height ],
             rounding = grill_slit_height / 2, anchor = LEFT + FWD);
      }
      //   }
      // }
    }
  }
}

module side_base2d() {
  rect_depth = side_depth * 0.2;
  triangle_depth = side_depth - rect_depth;
  rect([ rect_depth, height ], anchor = BACK + RIGHT);
  left(rect_depth) mirror([ 1, 0 ]) mirror([ 0, 1 ])
      right_triangle([ triangle_depth, height ]);
}

module grill2d() {
  left(grill_size.x / 2) difference() {
    rect(grill_size, anchor = LEFT + BACK);

    rect_grill_mask(grill_size, holes = grill_holes, space = grill_space,
                    padding = grill_padding);

    // handles
    hole_offset = add_scalar(grill_hole_size, grill_space);
    right(grill_padding) fwd(hole_offset.y + grill_padding) {
      right(hole_offset.x * 2) grill_handle(grill_hole_size, grill_space);
      right(hole_offset.x * 3) grill_handle(grill_hole_size, grill_space);
    }
  }
}

module grill_handle(hole_size, space) {
  rect([ hole_size.x, hole_size.y * 2 + space ], rounding = hole_size.y / 2,
       anchor = LEFT + BACK);
}

// grill2d();
grill();
// side2d();ho
