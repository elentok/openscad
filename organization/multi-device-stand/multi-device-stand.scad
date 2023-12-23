// include <BOSL2/beziers.scad>
include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

// Two Laptops
device_widths = [ 18, 18 ];
spacer_width = 7;
spacer_thickness = 10;
side_triangle_width = 30;
wire_openings = false;
strengtheners = false;
stand_bottom_height = 10;
stand_height = 70;

// Tablets
// device_widths = [ 28, 28, 20 ];
// spacer_width = 7;
// spacer_thickness = 10;
// side_triangle_width = 12;
// wire_openings = true;
// wire_opening_width = 4;
// wire_hole_diameter = 5;
// stand_bottom_height = 10;
// stand_height = 70;
// strengtheners = true;

// Charger + Emergency batteries
// device_widths = [ 17, 17, 17, 28 ];
// spacer_width = 4;
// spacer_thickness = 10;
// side_triangle_width = 6;
// wire_openings = false;
// wire_opening_width = 4;
// wire_hole_diameter = 5;
// stand_bottom_height = 5;
// stand_height = 40;
// strengtheners = true;

stand_width =
    // devices
    sum(device_widths) +
    // spacers
    spacer_width * (len(device_widths) + 1) +
    // side triangles
    side_triangle_width * 2;
stand_depth = stand_height * 1.5;

stand_size = [ stand_width, stand_depth, stand_height ];
echo(stand_size = stand_size);

module stand() {
  difference() {
    right(stand_width / 2) stand_base();
    device_masks();
  }

  if (strengtheners) {
    // strengtheners
    right(side_triangle_width) strengthener(LEFT);
    right(stand_width - side_triangle_width) strengthener(RIGHT);

    cross_strengthener2();
    mirror([ 0, -1, 0 ]) cross_strengthener2();
  }

  // right(stand_width / 2) cross_strengthener();
  // right(stand_width / 2) rotate([ 0, 0, 90 ]) cross_strengthener();
}

module cross_strengthener2() {
  path = [[side_triangle_width, stand_depth / 2 - spacer_thickness],
          [stand_width - side_triangle_width,
           -stand_depth / 2 + spacer_thickness]];

  linear_extrude(stand_bottom_height / 3) stroke(path, width = spacer_width);
}

module strengthener(anchor) {
  cube(
      [ spacer_width, stand_depth - spacer_thickness, stand_bottom_height / 3 ],
      anchor = anchor + BOTTOM);
}

module cross_strengthener() {
  rotate([ 0, 0, 45 ]) cube(
      [ spacer_width, stand_depth + spacer_thickness, stand_bottom_height / 3 ],
      anchor = BOTTOM);
}

module device_masks() {
  for (i = [0:len(device_widths) - 1]) {
    device_mask(i);
  }
}

module device_mask(i) {
  w = device_widths[i];

  prev_devices_width_with_spacers =
      i == 0 ? 0 : sum([for (j = [0:i - 1]) device_widths[j] + spacer_width]);

  x = side_triangle_width + spacer_width + prev_devices_width_with_spacers;
  up(stand_bottom_height) right(x) cuboid([ w, stand_depth * 2, stand_height ],
                                          anchor = LEFT + BOTTOM, rounding = 3);

  // wire hole
  if (wire_openings) {
    right(x + w / 2) {
      up(stand_bottom_height - wire_hole_diameter / 2) rotate([ 90, 0, 0 ])
          cylinder(d = wire_hole_diameter, h = stand_depth, center = true);

      up(stand_bottom_height + epsilon)
          cube([ wire_opening_width, stand_depth, wire_hole_diameter / 2 ],
               anchor = TOP);
    }
  }
}

module stand_base() {
  intersection() {
    stand_tube();
    // stand_trapezoid();
    stand_triangles();
  }
}

module stand_tube() {
  difference() {
    scale([ 1, stand_depth / (stand_height * 2), 1 ]) rotate([ 90, 0, 90 ])
        cylinder(r = stand_height, h = stand_width, center = true);

    scale([ 1, stand_depth / (stand_height * 2) * 0.7, 1.07 ])
        rotate([ 90, 0, 90 ])
            cylinder(r = stand_height - spacer_thickness,
                     h = stand_width + epsilon, center = true);

    cube(add_scalar([ stand_width, stand_depth, stand_height ], epsilon),
         anchor = TOP);
  }
}

module stand_triangles() {
  w = stand_width - side_triangle_width * 2;
  rotate([ 90, 0, 0 ])
      linear_extrude(stand_depth, center = true, convexity = 4) {
    rect([ w, stand_height ], anchor = FWD);
    right(w / 2) right_triangle([ side_triangle_width, stand_height ]);
    left(w / 2) mirror([ -1, 0, 0 ])
        right_triangle([ side_triangle_width, stand_height ]);
  }
}

// stand();

// stand_tube();

module stand_trapezoid() {
  w = 20;
  rotate([ 90, 0, 90 ]) linear_extrude(
      stand_width, center = true, convexity = 4) round2d(r = 2) difference() {
    trapezoid(h = stand_height, w1 = stand_depth, w2 = stand_depth / 2,
              anchor = FWD);

    trapezoid(h = stand_height - w, w1 = stand_depth - w,
              w2 = stand_depth / 2 - w, anchor = FWD);
  }
}

// stand_trapezoid();
stand();

// stand_tube();
