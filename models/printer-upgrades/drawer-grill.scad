include <BOSL2/std.scad>
use <../../lib/rect-grill.scad>
$fn = 64;

grill_size = [ 345, 60 ];
thickness = 2.5;
side_depth = 60;

middle_support_depth = side_depth / 2;

grip_depth = 10;

grill_padding = 10;
grill_holes = [ 6, 4 ];
grill_space = 5;

shelf_thickness = 12;

grill_hole_size =
    rect_grill_hole_size(size = grill_size, holes = grill_holes,
                         space = grill_space, padding = grill_padding);

echo("Grill hole size:", grill_hole_size);

module grill() {
  rotate([ -90, 0, 0 ]) linear_extrude(thickness) grill2d();

  cuboid([ grill_size.x, thickness, shelf_thickness + thickness ],
         anchor = TOP + FWD);

  // top grip
  cuboid([ grill_size.x, grip_depth + thickness, thickness ],
         anchor = FWD + BOTTOM);

  // bottom grip
  down(shelf_thickness + thickness)
      cuboid([ grill_size.x, grip_depth + thickness, thickness ],
             anchor = FWD + BOTTOM);

  // sides
  side_x = grill_size.x / 2 - thickness / 2;
  right(side_x) mirror([ 1, 0, 0 ]) side();
  left(side_x) side();

  // supports
  middle_support();
}

module middle_support() {
  back(thickness) {
    difference() {
      union() {
        up(thickness) wedge(
            [ grill_space, middle_support_depth, grill_size.y - thickness ],
            anchor = BOTTOM + FWD);

        cuboid([ grip_depth * 2, middle_support_depth, thickness ],
               anchor = BOTTOM + FWD);
      }

      up(grill_size.y * 0.3) back(middle_support_depth * 0.4)
          rotate([ 90, 0, 90 ]) cyl(d = 4.2, h = thickness * 2 + 0.01);
    }
  }
}

module side() {
  rotate([ -90, 0, 90 ]) linear_extrude(thickness, center = true) side2d();

  // top side grip
  right(thickness / 2) cuboid([ grip_depth, side_depth, thickness ],
                              anchor = BOTTOM + FWD + LEFT);

  // bottom side grip
  down(shelf_thickness + thickness) right(thickness / 2) cuboid(
      [ grip_depth, side_depth, thickness ], anchor = BOTTOM + FWD + LEFT);
}

module side2d() {
  difference() { side_base2d(); }
}

module side_base2d() {
  rect_depth = side_depth * 0.2;
  triangle_depth = side_depth - rect_depth;

  difference() {
    union() {
      right(rect_depth) {
        rect([ rect_depth, grill_size.y ], anchor = BACK + RIGHT);
        mirror([ 0, 1 ]) back(thickness)
            right_triangle([ triangle_depth, grill_size.y - thickness ]);
      }
      fwd(thickness) rect([ side_depth, shelf_thickness + thickness * 2 ],
                          anchor = FWD + LEFT);
    }

    hole_offset = add_scalar(grill_hole_size, grill_space);
    width1 = triangle_depth - grill_padding;
    right(grill_padding / 2) fwd(grill_padding) {
      rect_grill_hole([ width1, grill_hole_size.y ]);
      fwd(hole_offset.y) rect_grill_hole([ width1 * 0.7, grill_hole_size.y ]);
      fwd(hole_offset.y * 2)
          rect_grill_hole([ width1 * 0.5, grill_hole_size.y ]);
      fwd(hole_offset.y * 3)
          rect_grill_hole([ width1 * 0.3, grill_hole_size.y ]);
    }
  }
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

// side();
// grill2d();
grill();
// side2d();
// middle_support();
