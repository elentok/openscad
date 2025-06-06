include <BOSL2/std.scad>
$fn = 64;

hole_rounding = 1;
body_size = [120, 99, 80];
bottom_thickness = 3;
wall_thickness = 3;

module organizer() {
  difference() {
    body();

    // locking pliers
    rect_hole([17, 50], x_align=RIGHT, y_align=FWD);

    // hole puncher
    cyl_hole(d=13, x_align=RIGHT, y_align=BACK);

    // bit holder
    cyl_hole_grid(d=8, x=4, y=2, h=20, x_align=LEFT, y_align=FWD);

    drill_bits_mask(orientation="x", x_align=LEFT, y_align=BACK);
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

module drill_bits_mask(sizes = [10, 9, 8, 7, 6, 5, 4, 3, 2], gap = 3, orientation = "x", x_align, y_align) {
  angle = orientation == "y" ? -90 : 0;

  size1 = sum_array(sizes, len(sizes)) + (gap) * (len(sizes) - 1);
  // TODO: proper max
  size2 = sizes[0];

  width = orientation == "y" ? size2 : size1;
  depth = orientation == "y" ? size1 : size2;

  shift_offset = size1 / 2 - sizes[0] / 2;

  align_x(width, x_align) align_y(depth, y_align) rotate([0, 0, angle])for (i = [0:len(sizes) - 1]) {
        x = sum_array(sizes, i) - sizes[0] / 2 + sizes[i] / 2 + gap * i;
        echo("sum_array", sum_array(sizes, i));
        echo("gap", gap * i);
        echo("x", x);
        d = sizes[i];
        right(x - shift_offset) cyl_hole(d);
      }
}

module body() {
  cuboid(size=body_size, anchor=LEFT + BACK + TOP, rounding=2, except=BOTTOM);
}

module cyl_hole(d, h, x_align, y_align) {
  hh = is_undef(h) ? body_size.z - bottom_thickness : h;
  d_with_tolerance = d + 0.1;
  align_y(d, y_align) align_x(d, x_align) up(0.01) cyl(
          d=d, h=hh, anchor=TOP,
          rounding1=hole_rounding,
          rounding2=-hole_rounding,
        );
}

module cyl_hole_grid(d, x, y, spacing = 4, h, x_align, y_align) {
  width = d * x + spacing * (x - 1);
  depth = d * y + spacing * (y - 1);

  echo("WIDTH", width);
  echo("DEPTH", depth);

  align_x(width, x_align) align_y(depth, y_align) back(depth / 2 - d / 2) left(width / 2 - d / 2)for (ix = [0:x - 1]) {
          right(ix * (d + spacing))for (iy = [0:y - 1]) {
            fwd(iy * (d + spacing)) cyl_hole(d=d, h=h);
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
