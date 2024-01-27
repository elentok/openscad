include <BOSL2/std.scad>
$fn = 64;

hole_size = [ 18, 20.5 ];
paddle_height = 10;
base_thickness = 2;
base_cover_thickness = 2;
// base_height_above = 4;
base_height_below = 5;
pin_d = 0.9;  // with tolerance
triangle_height = 10;
// triangle_thickness = base_cover_thickness + base_thickness;
triangle_thickness = base_thickness;

top_size = hole_size;
// top_size = add_scalar(hole_size, base_thickness * 2);
// top_size = add_scalar(hole_size, base_cover_thickness * 2);
rnd = 2;

paddle_y_tolerance = 1;
paddle_pin_tolerance = 1.5;
paddle_y = hole_size.y - base_thickness * 2 - paddle_y_tolerance;
paddle_x1 = hole_size.x - 5;
paddle_x2 = 4;
paddle_z2 = 10;
paddle_thickness = 2;

module base() {
  isize = add_scalar(hole_size, -base_thickness * 2);

  difference() {
    union() {
      rect_tube(size = hole_size, isize = isize, h = base_height_below,
                anchor = TOP);

      // rect_tube(size = top_size, isize = isize, h = base_height_above);

      fwd(top_size.y / 2 - triangle_thickness / 2) triangle();
      back(top_size.y / 2 - triangle_thickness / 2) triangle();
    }

    right(top_size.x / 2 - rnd) up(triangle_height - rnd) rotate([ 90, 0, 0 ])
        cyl(d = pin_d, h = top_size.y + 1);
  }

  // isize = add_scalar(hole_size, -base_thickness * 2);
  // size_bottom = add_scalar(hole_size, base_cover_thickness * 2);
  // size_top = size_bottom;
  // // size_top = hole_size;
  // rect_tube(h = base_height_above, size1 = size_bottom, isize1 = isize,
  //           size2 = size_top, isize2 = isize);
}

module triangle() {
  // r = min(top_size.x, top_size.y) / 8;
  rotate([ 90, 0, 0 ])
      linear_extrude(triangle_thickness, center = true, convexity = 4) hull() {
    left(top_size.x / 2)
        rect([ top_size.x / 4, triangle_height / 4 ],
             rounding = [ rnd, rnd, 0, 0 ], anchor = FWD + LEFT);

    right(top_size.x / 2)
        rect([ top_size.x / 4, triangle_height ], rounding = [ rnd, rnd, 0, 0 ],
             anchor = FWD + RIGHT);
  }
}

module paddle() {
  path = [
    [ -paddle_x1, 0 ], [ 0, 0 ], [ paddle_x2, paddle_z2 ], [ -paddle_x1, 0 ]
  ];

  linear_extrude(paddle_y) difference() {
    union() {
      circle(d = pin_d + paddle_pin_tolerance + paddle_thickness);
      stroke(path, width = paddle_thickness);
    }
    circle(d = pin_d + paddle_pin_tolerance);
  }
}

paddle();

// base();
// triangle();
