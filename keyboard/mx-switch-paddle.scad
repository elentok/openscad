include <BOSL2/std.scad>
$fn = 64;

hole_size = [ 12, 12 ];
paddle_height = 10;
paddle_thickness = 3;
base_thickness = 2;
base_cover_thickness = 3;
base_height_above = 10;
base_height_below = 4;
pin_d = 0.5;  // with tolerance

module base() {
  rect_tube(size = hole_size, wall = base_thickness, h = base_height_below,
            anchor = TOP);

  size_top = add_scalar(hole_size, base_thickness * 2);
  size_bottom = add_scalar(hole_size, base_cover_thickness * 2);
  rect_tube(h = base_height_above, size1 = size_top, size2 = size_bottom);
  // up(4) rect_tube(size2 = hole_size, isize2 = add_scalar(hole_size, -2),
  //                 size1 = add_scalar(hole_size, base_cover_thickness * 2),
  //                 isize1 = hole_size, h = 10);
}

base();

// module paddle() {
//
// }
