$fn = 50;

// ------------------------------------------------------------
// Calculation functions
// ------------------------------------------------------------

// Using the pythagorean theorem:
//
//   (Width/2)^2 + (r/2)^2 = r^2
//
function calc_hexagon_width(height) = sqrt(3) * height / 2;

// Using the pythagorean theorem:
//
//   VertDist^2 + (Dist/2)^2 = Dist^2
//
function calc_hexagon_vertical_distance(horizontal_distance) =
    sqrt(1.25) * horizontal_distance;

// ------------------------------------------------------------
// Honeycomb Rectangle
// ------------------------------------------------------------

module honeycomb_rectangle(size, hexagon_height, distance) {
  hexagon_width = calc_hexagon_width(hexagon_height);
  pattern_height = hexagon_height * 1.5;

  x_reps = ceil(size.x / hexagon_width) + 1;
  y_reps = ceil(size.y / pattern_height) + 1;

  translate([ -size.x / 2, -size.y / 2 ]) intersection() {
    square(size);
    honeycomb_pattern(x_reps, y_reps, hexagon_height, distance);
  }
}

// ------------------------------------------------------------
// Honeycomb Pattern
// ------------------------------------------------------------

module honeycomb_pattern(x_reps, y_reps, hexagon_height, distance) {
  hexagon_width = calc_hexagon_width(hexagon_height);
  thickness = distance / 2;
  pattern_height = 1.5 * hexagon_height;

  for (index_x = [-1:x_reps - 1]) {
    x1 = index_x * hexagon_width;
    x2 = x1 + hexagon_width / 2;

    for (index_y = [-1:y_reps - 1]) {
      y1 = index_y * pattern_height;
      translate([ x1, y1 ]) hexagon_shell(hexagon_height, thickness);

      y2 = y1 + pattern_height / 2;
      translate([ x2, y2 ]) hexagon_shell(hexagon_height, thickness);
    }
  }
}

// ------------------------------------------------------------
// Hexagon Shell
// ------------------------------------------------------------

module hexagon_shell(height, thickness) {
  radius = height / 2 - thickness;
  rotate([ 0, 0, 90 ]) for (i = [0:5]) {
    hull() {
      x1 = radius * cos(i * 60);
      y1 = radius * sin(i * 60);
      translate([ x1, y1 ]) circle(thickness);

      x2 = radius * cos((i + 1) * 60);
      y2 = radius * sin((i + 1) * 60);
      translate([ x2, y2 ]) circle(thickness);
    }
  }
}

// ------------------------------------------------------------
// Rounded Square (minkowski)
// ------------------------------------------------------------

module rsquare(size, radius) {
  assert(radius < size.x / 2, "Radius must be less than half the width");
  assert(radius < size.y / 2, "Radius must be less than half the height");

  minkowski() {
    square([ size.x - radius * 2, size.y - radius * 2 ], center = true);
    circle(radius);
  }
}

module rsquare_shell(size, radius, thickness) {
  difference() {
    rsquare(size, radius);

    x = size.x - thickness * 2;
    y = size.y - thickness * 2;
    rsquare([ x, y ], radius);
  }
}

// ------------------------------------------------------------
// Shelf
// ------------------------------------------------------------

module shelf(size) {
  difference() {
    cube(size);

    translate([ size.x / 2, 0, -1 ]) {
      rotate([ 90, 0, 90 ]) {
        cylinder(h = size.x + 1, r = size.y, center = true);
      }
    }
  }

  triangle_width = 2;

  // Left triangle
  shelf_triangle(size.y, triangle_width);

  // Right triangle
  translate([ size.x - triangle_width, 0, 0 ]) {
    shelf_triangle(size.y, triangle_width);
  }
}

module shelf_triangle(size, triangle_width) {
  rotate([ 90, 0, 90 ]) {
    linear_extrude(triangle_width) {
      polygon([[size, size], [0, size], [size, 0]]);
    }
  }
}

// ------------------------------------------------------------
// Box
// ------------------------------------------------------------

module box(size, radius, wall_width) {
  linear_extrude(size.z) { rsquare_shell(size, radius, wall_width); }

  linear_extrude(wall_width) { rsquare(size, radius); }
}

// ------------------------------------------------------------
// Box with Label
// ------------------------------------------------------------

module box_with_label(size, radius, wall_width) {
  label_size = [ 60, 10, 10 ];

  box(size, radius, wall_width);

  x = -label_size.x / 2;
  y = size.y / 2 - label_size.y;
  z = size.z - label_size.z;
  translate([ x, y, z ]) shelf(label_size);
}

// ------------------------------------------------------------
// Box with Label
// ------------------------------------------------------------

module honeycomb_box(size, border_radius, wall_width, hexagon_radius,
                     hexagon_dist, padding_bottom, padding_top,
                     padding_horizontal) {
  honeycomb_height = size.z - padding_bottom - padding_top;
  honeycomb_width = size.x - padding_horizontal * 2;
  honeycomb_depth = size.y - padding_horizontal * 2;

  union() {
    difference() {
      box_with_label(size, border_radius, wall_width);

      // Remove chunks to make place for the honeycombs
      translate([ 0, 0, honeycomb_height / 2 + padding_bottom ]) cube(
          [ honeycomb_width, size.y + 0.2, honeycomb_height ], center = true);

      // Remove chunks to make place for the honeycombs
      translate([ 0, 0, honeycomb_height / 2 + padding_bottom ]) cube(
          [ size.x + 0.2, honeycomb_depth, honeycomb_height ], center = true);
    }

    z = honeycomb_height / 2 + padding_bottom;

    // Honeycomb on X-Axis (1/2)
    y1 = -size.y / 2 + wall_width;
    translate([ 0, y1, z ]) rotate([ 90, 0, 0 ]) linear_extrude(wall_width)
        honeycomb_rectangle([ honeycomb_width + 0.4, honeycomb_height + 0.4 ],
                            hexagon_radius * 2, hexagon_dist);

    // Honeycomb on X-Axis (2/2)
    y2 = size.y / 2;
    translate([ 0, y2, z ]) rotate([ 90, 0, 0 ]) linear_extrude(wall_width)
        honeycomb_rectangle([ honeycomb_width + 0.4, honeycomb_height + 0.4 ],
                            hexagon_radius * 2, hexagon_dist);

    // Honeycomb on Y-Axis (1/2)
    x1 = -size.x / 2;
    translate([ x1, 0, z ]) rotate([ 90, 0, 90 ]) linear_extrude(wall_width)
        honeycomb_rectangle([ honeycomb_depth + 0.4, honeycomb_height + 0.4 ],
                            hexagon_radius * 2, hexagon_dist);

    // Honeycomb on Y-Axis (1/2)
    x2 = size.x / 2 - wall_width;
    translate([ x2, 0, z ]) rotate([ 90, 0, 90 ]) linear_extrude(wall_width)
        honeycomb_rectangle([ honeycomb_depth + 0.4, honeycomb_height + 0.4 ],
                            hexagon_radius * 2, hexagon_dist);
  }
}

// ------------------------------------------------------------
// Test
// ------------------------------------------------------------

honeycomb_box([ 80, 100, 130 ], border_radius = 5, wall_width = 1.2,
              hexagon_radius = 7, hexagon_dist = 2, padding_bottom = 25,
              padding_top = 15, padding_horizontal = 10);
