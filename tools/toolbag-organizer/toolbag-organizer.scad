include <BOSL2/std.scad>
$fn = 64;

hole_rounding = 1;
body_size = [120, 99, 80];
bottom_thickness = 3;
wall_thickness = 3;

module organizer() {
  difference() {
    body();

    rect_hole([17, 50], x_align=RIGHT, y_align=FWD);
    // align_back(30) align_right(20) rotate([0, 0, 90]) rect_hole([30, 20]);

    // hole puncher
    cyl_hole(d=13, x_align=RIGHT, y_align=BACK);

    fwd(wall_thickness) right(wall_thickness) {
        drill_bits_mask();
        // fwd(10 / 2) {
        // cyl_hole(d=10);
        // right(10 + 3) cyl_hole(d=9);
        // right(10 + 9 + 3 * 2) cyl_hole(d=8);
        // right(10 + 9 + 8 + 3 * 3) cyl_hole(d=7);
        // right(10 + 9 + 8 + 7 + 3 * 4) cyl_hole(d=6);
        // right(10 + 9 + 8 + 7 + 6 + 3 * 5) cyl_hole(d=5);
        // right(10 + 9 + 8 + 7 + 6 + 5 + 3 * 6) cyl_hole(d=4);
        // }
      }
  }
}

// @type dir LEFT | RIGHT | undef
module align_x(width, dir) {
  if (dir == LEFT) {
    right(width / 2 + wall_thickness) children();
  } else if (dir == RIGHT) {
    right(body_size.x - width / 2 - wall_thickness) children();
  } else {
    children();
  }
}

// @Type dir FWD | BACK | undef
module align_y(depth, dir) {
  if (dir == FWD) {
    fwd(body_size.y - depth / 2 - wall_thickness) children();
  } else if (dir == BACK) {
    fwd(depth / 2 + wall_thickness) children();
  } else {
    children();
  }
}

module align_back(depth){}

function sum_array(arr, stop, i = 0) =
  i >= stop ? 0 : arr[i] + sum_array(arr, stop, i + 1);

module drill_bits_mask(sizes = [10, 9, 8, 7, 6, 5, 4, 3, 2], gap = 3, angle = 0) {
  right(sizes[0] / 2) fwd(sizes[0] / 2) rotate([0, 0, angle])for (i = [0:len(sizes) - 1]) {
        x = sum_array(sizes, i) + i * (hole_rounding + gap);
        d = sizes[i];
        right(x) cyl_hole(d);
      }
}

module body() {
  cuboid(size=body_size, anchor=LEFT + BACK + TOP, rounding=2, except=BOTTOM);
}

module cyl_hole(d, h = body_size.z - bottom_thickness, x_align, y_align) {
  d_with_tolerance = d + 0.1;
  align_y(d, y_align) align_x(d, x_align) up(0.01) cyl(
          d=d, h=h, anchor=TOP,
          rounding1=hole_rounding,
          rounding2=-hole_rounding,
        );
}

module rect_hole(size, h = body_size.z - bottom_thickness, x_align, y_align) {
  align_y(size.y, y_align) align_x(size.x, x_align) up(0.01) {
        cuboid([size.x, size.y, h], anchor=TOP, rounding=hole_rounding, except=TOP);
        negative_3d_roundover([size.x, size.y, hole_rounding], positive_rounding=hole_rounding);
      }
}

module negative_3d_roundover(size, positive_rounding = 0) {
  back(size.y / 2) left(size.x / 2) {
      negative_3d_roundover_side(size, positive_rounding);
      fwd(size.y) mirror([0, 1, 0]) negative_3d_roundover_side(size, positive_rounding);

      fwd(positive_rounding) mirror([0, 1, 0]) rotate([0, 0, 90]) negative_3d_roundover_edge(size.y, size.z, positive_rounding);
      fwd(positive_rounding) right(size.x) mirror([1, 0, 0]) mirror([0, 1, 0]) rotate([0, 0, 90]) negative_3d_roundover_edge(size.y, size.z, positive_rounding);
    }
}

module negative_3d_roundover_side(size, positive_rounding) {
  fwd(positive_rounding) right(positive_rounding) mirror([1, 0, 0]) negative_3d_roundover_corner(size, positive_rounding);
  fwd(positive_rounding) right(size.x - positive_rounding) negative_3d_roundover_corner(size, positive_rounding);
  right(positive_rounding) negative_3d_roundover_edge(size.x, size.z, positive_rounding);
}

module negative_3d_roundover_corner(size, positive_rounding) {
  mirror([0, 0, 1]) rotate_extrude(angle=90) right(positive_rounding) mask2d_roundover(r=size.z, excess=0);
}

module negative_3d_roundover_edge(w, h, positive_rounding) {
  rotate([0, 90, 0]) linear_extrude(w - positive_rounding * 2) mask2d_roundover(r=h, excess=0);
}

// negative_3d_roundover([30, 20, 3], positive_rounding=2);
// right(4) mask2d_roundover(r=5, excess=0);

// rect_hole([30, 20]);
// drill_bits_mask();
organizer();
