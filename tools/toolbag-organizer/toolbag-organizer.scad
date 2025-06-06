include <BOSL2/std.scad>
$fn = 64;

hole_rounding = 1;
bottom_thickness = 3;
wall_thickness = 3;

// Drill bit organizer
// body_size = [120, 27, 60];
body_size = [120, 40, 60];
module organizer() {
  difference() {
    body();

    right(40) drill_bits_mask(
        sizes=[10, 9, 8, 7],
        screw_holes=[true, false, false, false],
        gap=4, orientation="x", x_align=LEFT, y_align=BACK
      );
    right(45) fwd(15) drill_bits_mask(
          sizes=[2, 2.5, 3, 4, 5, 6],
          heights=[15, 23, 23, 39, 39], gap=4, orientation="x", x_align=LEFT, y_align=BACK
        );
    right(25) cyl_hole_grid(d=7.5, x=1, y=1, h=50, spacing=5, x_align=LEFT, y_align=BACK);
    fwd(14) right(18) cyl_hole_grid(d=7.5, x=2, y=1, h=50, spacing=5, x_align=LEFT, y_align=BACK);
    cyl_hole_grid(d=7.5, x=2, y=2, h=20, spacing=5, x_align=RIGHT, y_align=BACK);

    // hole puncher
    cyl_hole(d=14, x_align=LEFT, y_align=BACK, screw_hole=true);

    cyl_hole_grid(d=7.5, x=10, y=1, h=50, spacing=4, x_align=LEFT, y_align=FWD, screw_hole=[7, 0]);
    // cyl_hole_grid(d=7.5, x=4, y=1, spacing=6, x_align=RIGHT, y_align=FWD);
  }
}

// Bit organizer
// body_size = [120, 99, 25];
// module organizer() {
//   difference() {
//     body();
//
//     drill_bits_mask(sizes=[6, 7, 8, 9, 10], gap=3, orientation="x", x_align=LEFT, y_align=BACK);
//     fwd(15) drill_bits_mask(sizes=[5, 4, 3, 2], gap=3, orientation="x", x_align=LEFT, y_align=BACK);
//     cyl_hole_grid(d=8, x=5, y=3, h=20, x_align=LEFT, y_align=FWD);
//   }
// }

// body_size = [120, 99, 80];
// module organizer() {
//   difference() {
//     body();
//
//     // locking pliers
//     rect_hole([17, 50], x_align=RIGHT, y_align=FWD);
//
//     // hole puncher
//     cyl_hole(d=13, x_align=RIGHT, y_align=BACK);
//
//     // bit holder
//     cyl_hole_grid(d=8, x=4, y=2, h=20, x_align=LEFT, y_align=FWD);
//
//     drill_bits_mask(orientation="x", x_align=LEFT, y_align=BACK);
//   }
// }

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

// @type sizes number[]
// @type heights number[]
// @type screw_holes boolean[]
module drill_bits_mask(sizes, heights, gap = 3, orientation = "x", x_align, y_align, tolerance = 0.2, screw_holes) {
  angle = orientation == "y" ? -90 : 0;

  size1 = sum_array(sizes, len(sizes)) + (gap) * (len(sizes) - 1);
  size2 = max(sizes);

  width = orientation == "y" ? size2 : size1;
  depth = orientation == "y" ? size1 : size2;

  shift_offset = size1 / 2 - sizes[0] / 2;

  align_x(width, x_align) align_y(depth, y_align) rotate([0, 0, angle])for (i = [0:len(sizes) - 1]) {
        x = sum_array(sizes, i) - sizes[0] / 2 + sizes[i] / 2 + gap * i;
        d = sizes[i];
        right(x - shift_offset) cyl_hole(d=d + tolerance, h=heights[i], screw_hole=screw_holes[i]);
      }
}

module body() {
  cuboid(size=body_size, anchor=LEFT + BACK + TOP, rounding=2, except=BOTTOM);
}

module cyl_hole(d, h, x_align, y_align, screw_hole) {
  assert(d > 1, str("Cylinder hole diameter must be larger than 1mm, got ", d, "mm"));
  hh = is_undef(h) ? body_size.z - bottom_thickness : h;
  align_y(d, y_align) align_x(d, x_align) up(0.01) {
        cyl(
          d=d, h=hh, anchor=TOP,
          rounding1=hole_rounding,
          rounding2=-hole_rounding,
        );

        if (screw_hole) {
          cyl(d=5, h=body_size.z + 0.02, anchor=TOP);
          down(body_size.z - bottom_thickness - hole_rounding + 0.02) cyl(d1=5, d2=7, h=bottom_thickness / 2, anchor=TOP);
        }
      }
}

// @type screw_hole [number, number] coords for the screw hole
module cyl_hole_grid(d, x, y, spacing = 4, h, x_align, y_align, screw_hole) {
  width = d * x + spacing * (x - 1);
  depth = d * y + spacing * (y - 1);

  align_x(width, x_align) align_y(depth, y_align) back(depth / 2 - d / 2) left(width / 2 - d / 2)for (ix = [0:x - 1]) {
          right(ix * (d + spacing))for (iy = [0:y - 1]) {
            has_screw_hole = is_def(screw_hole) && screw_hole.x == ix && screw_hole.y == iy;
            fwd(iy * (d + spacing)) cyl_hole(d=d, h=h, screw_hole=has_screw_hole);
          }
        }
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
// drill_bits_mask(orientation="y");
organizer();
// cyl_hole_grid(d=8, x=3, y=5, h=20);
// cyl_hole(d=8, screw_hole=true);
