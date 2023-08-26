include <BOSL2/std.scad>
use <../../lib/rect-grill.scad>
$fn = 64;

shelf_width = 345;

thickness = 2.5;
grill_size = [ shelf_width + thickness * 2, 60 ];
side_depth = 80;

middle_support_depth = side_depth / 2;

grip_depth = 15;

grill_padding = 10;
grill_holes = [ 6, 4 ];
grill_space = 5;

shelf_thickness = 12;

grill_hole_size =
    rect_grill_hole_size(size = grill_size, holes = grill_holes,
                         space = grill_space, padding = grill_padding);

grill_hole_offset = add_scalar(grill_hole_size, grill_space);

echo("Grill hole size:", grill_hole_size);

module grill() {
  rotate([ -90, 0, 0 ]) linear_extrude(thickness, convexity = 4) grill2d();

  cuboid([ grill_size.x, thickness, shelf_thickness + thickness ],
         anchor = TOP + FWD);

  // top grip
  screw_x = thickness + grill_hole_size.x / 2;
  back(thickness) grip(width = grill_size.x, screws = [ screw_x, -screw_x ]);

  // bottom grip
  down(shelf_thickness + thickness) grip(width = grill_size.x);

  // sides
  side_x = grill_size.x / 2 - thickness / 2;
  right(side_x) mirror([ 1, 0, 0 ]) side();
  left(side_x) side();

  // supports
  middle_support();
  left(grill_hole_offset.x) small_support();
  left(grill_hole_offset.x * 2) small_support();
  right(grill_hole_offset.x) small_support();
  right(grill_hole_offset.x * 2) small_support();
}

module middle_support() {
  back(thickness) {
    difference() {
      union() {
        up(thickness) wedge(
            [ grill_space, middle_support_depth, grill_size.y - thickness ],
            anchor = BOTTOM + FWD);

        middle_support_grip();
        mirror([ 1, 0, 0 ]) middle_support_grip();
      }

      up(grill_size.y * 0.3) back(middle_support_depth * 0.4)
          rotate([ 90, 0, 90 ]) cyl(d = 4.2, h = thickness * 2 + 0.01);
    }
  }
}

module middle_support_grip() {
  rotate([ 0, 0, 90 ])
      grip(width = middle_support_depth,
           screws = [-middle_support_depth / 2 + grill_padding],
           rounding = [ 0, 0, 0, 5 ], anchor = LEFT + BACK + BOTTOM);
}

module small_support() {
  up(thickness) back(thickness)
      wedge([ grill_space, grip_depth, grill_padding ], anchor = FWD + BOTTOM);
}

module side() {
  rotate([ -90, 0, 90 ]) linear_extrude(thickness, convexity = 4, center = true)
      side2d();

  // top side grip
  side_grip();

  // bottom side grip
  down(shelf_thickness + thickness) side_grip();
}

module side_grip() {
  right(thickness / 2) rotate([ 0, 0, 90 ]) grip(
      width = side_depth, anchor = LEFT + BOTTOM + BACK,
      screws = [-side_depth / 2 + grill_padding], rounding = [ 0, 0, 0, 5 ]);
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

    width1 = triangle_depth - grill_padding;
    right(grill_padding / 2) fwd(grill_padding) {
      rect_grill_hole([ width1, grill_hole_size.y ]);
      fwd(grill_hole_offset.y)
          rect_grill_hole([ width1 * 0.7, grill_hole_size.y ]);
      fwd(grill_hole_offset.y * 2)
          rect_grill_hole([ width1 * 0.5, grill_hole_size.y ]);
      fwd(grill_hole_offset.y * 3)
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
    right(grill_padding) fwd(grill_hole_offset.y + grill_padding) {
      right(grill_hole_offset.x * 2) grill_handle(grill_hole_size, grill_space);
      right(grill_hole_offset.x * 3) grill_handle(grill_hole_size, grill_space);
    }
  }
}

module grill_handle(hole_size, space) {
  rect([ hole_size.x, hole_size.y * 2 + space ], rounding = hole_size.y / 2,
       anchor = LEFT + BACK);
}

module test_shelf() {
  back(thickness) color("green")
      cuboid([ shelf_width, 500, shelf_thickness ], anchor = TOP + FWD);
}

module half_grill() {
  intersection() {
    grill();

    down(shelf_thickness + thickness + 0.01 / 2) fwd(0.01 / 2) cuboid(
        [
          grill_size.x / 2 + 0.01, side_depth + 0.01,
          grill_size.y + thickness * 2 + shelf_thickness + 0.01
        ],
        anchor = LEFT + FWD + BOTTOM);
  }
}

module grip(width, screws, rounding = 0, anchor = FWD + BOTTOM) {
  attachable(size = [ width, grip_depth, thickness ], anchor) {
    linear_extrude(thickness, convexity = 4, center = true) difference() {
      rect([ width, grip_depth ], rounding = rounding);

      if (is_def(screws)) {
        for (i = [0:len(screws) - 1]) {
          left(screws[i]) circle(d = 4.2);
        }
      }
    }

    children();
  }
}

// grip(60, screws = [20], anchor = BACK + TOP);

half_grill();

// test_shelf();
// side();
// grill2d();
// side();
// grill();
// side2d();
// middle_support();
// left_half(s = grill_size.x * 2) grill();
