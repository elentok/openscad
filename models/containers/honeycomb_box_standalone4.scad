$fn = 50;

// ------------------------------------------------------------
// Calculation functions
// ------------------------------------------------------------

// Using the pythagorean theorem:
//
//   (Width/2)^2 + (r/2)^2 = r^2
//
function calc_hexagon_width(height) = sqrt(3) * height / 2;
function calc_hexagon_height(width) = width * 2 / sqrt(3);

// Using the pythagorean theorem:
//
//   VertDist^2 + (Dist/2)^2 = Dist^2
//
function calc_hexagon_vertical_distance(horizontal_distance) =
    sqrt(1.25) * horizontal_distance;

// ------------------------------------------------------------
// Honeycomb Rectangle
// ------------------------------------------------------------

module honeycomb_rectangle(size, hexagons, thickness = undef) {
  hexagon_width = size.x / hexagons;
  hexagon_height = calc_hexagon_height(hexagon_width);
  pattern_thickness = is_undef(thickness) ? hexagon_width * 0.2 : thickness;

  pattern_height = hexagon_height * 1.5;

  x_reps = ceil(size.x / hexagon_width) + 1;
  y_reps = ceil(size.y / pattern_height) + 1;

  translate([ -size.x / 2, -size.y / 2 ]) intersection() {
    square(size);
    translate([ 0, -pattern_height / 2 ])
        honeycomb_pattern(x_reps, y_reps, hexagon_height, pattern_thickness);
  }
}

// ------------------------------------------------------------
// Honeycomb Pattern
// ------------------------------------------------------------

module honeycomb_pattern(x_reps, y_reps, hexagon_height, thickness) {
  hexagon_width = calc_hexagon_width(hexagon_height);
  hexagon_thickness = thickness / 2;
  pattern_height = 1.5 * hexagon_height;

  for (index_x = [0:x_reps - 1]) {
    x1 = index_x * hexagon_width;
    x2 = x1 + hexagon_width / 2;

    for (index_y = [0:y_reps - 1]) {
      y1 = index_y * pattern_height;
      translate([ x1, y1 ]) hexagon_shell(hexagon_height, hexagon_thickness);

      y2 = y1 + pattern_height / 2;
      translate([ x2, y2 ]) hexagon_shell(hexagon_height, hexagon_thickness);
    }
  }
}

// ------------------------------------------------------------
// Hexagon Shell
// ------------------------------------------------------------

module hexagon_shell(height, thickness) {
  radius = height / 2 - thickness / 2;
  rotate([ 0, 0, 90 ]) for (i = [0:5]) {
    hull() {
      x1 = radius * cos(i * 60);
      y1 = radius * sin(i * 60);
      translate([ x1, y1 ]) circle(d = thickness);

      x2 = radius * cos((i + 1) * 60);
      y2 = radius * sin((i + 1) * 60);
      translate([ x2, y2 ]) circle(d = thickness);
    }
  }
}

// ------------------------------------------------------------
// Mirrors while copying the object
// ------------------------------------------------------------
module mirror_copy(vec) {
  children();
  mirror(vec) children();
}

// ------------------------------------------------------------
// Helper functions
// ------------------------------------------------------------

function normalize_radius(radius) = is_list(radius)
                                        ? radius
                                        : [ radius, radius, radius, radius ];

// ------------------------------------------------------------
// Rounded Square
// ------------------------------------------------------------
//
// Uses 4 corners and a hull() to connect them to a rectangle.
// Rounded corners are circles while straight corners are squares.
//
// Arguments:
//
// - size: [x, y]
// - radius: r or [r_top_left, r_top_right, r_bottom_right, r_bottom_left]
//
module rounded_square(size, radius) {
  radius = normalize_radius(radius);
  assert(len(radius) == 4,
         "Invalid radius value, must be either single value or array of 4");

  max_radius = min(size.x / 2, size.y / 2);

  r_top_left = min(radius[0], max_radius);
  r_top_right = min(radius[1], max_radius);
  r_bottom_right = min(radius[2], max_radius);
  r_bottom_left = min(radius[3], max_radius);

  hull() {
    if (r_top_left == 0) {
      translate([ -size.x / 2, size.y / 2 - 1 ]) square([ 1, 1 ]);
    } else {
      x = -size.x / 2 + r_top_left;
      y = size.y / 2 - r_top_left;
      translate([ x, y ]) circle(r = r_top_left);
    }

    if (r_top_right == 0) {
      translate([ size.x / 2 - 1, size.y / 2 - 1 ]) square([ 1, 1 ]);
    } else {
      x = size.x / 2 - r_top_right;
      y = size.y / 2 - r_top_right;
      translate([ x, y ]) circle(r = r_top_right);
    }

    if (r_bottom_right == 0) {
      translate([ size.x / 2 - 1, -size.y / 2 ]) square([ 1, 1 ]);
    } else {
      x = size.x / 2 - r_bottom_right;
      y = -size.y / 2 + r_bottom_right;
      translate([ x, y ]) circle(r = r_bottom_right);
    }

    if (r_bottom_left == 0) {
      translate([ -size.x / 2, -size.y / 2 ]) square([ 1, 1 ]);
    } else {
      x = -size.x / 2 + r_bottom_left;
      y = -size.y / 2 + r_bottom_left;
      translate([ x, y ]) circle(r = r_bottom_left);
    }
  }
}

// ------------------------------------------------------------
// Rounded Shell
// ------------------------------------------------------------
//
// Arguments:
//
// - size: [x, y]
// - thickness
// - outer_radius: r or [r_top_left, r_top_right, r_bottom_right, r_bottom_left]
// - inner_radius: optional, if missing will revert to inner_radius
//
module rounded_shell(size, thickness, outer_radius, inner_radius) {
  inner_radius = is_undef(inner_radius) ? outer_radius : inner_radius;
  inner_size = [ size.x - thickness * 2, size.y - thickness * 2 ];

  difference() {
    rounded_square(size, outer_radius);
    rounded_square(inner_size, inner_radius);
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
  linear_extrude(size.z) { rounded_shell(size, wall_width, radius); }

  linear_extrude(wall_width) { rounded_square(size, radius); }
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
// Honeycomb Box
// ------------------------------------------------------------

module honeycomb_box(size, border_radius, wall_width, x_hexagons, y_hexagons,
                     padding_bottom, padding_top, padding_horizontal) {
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

    // Honeycomb on X-Axis
    y1 = -size.y / 2 + wall_width;
    mirror_copy([ 0, 1, 0 ]) translate([ 0, y1, z ]) rotate([ 90, 0, 0 ])
        linear_extrude(wall_width) honeycomb_rectangle(
            [ honeycomb_width + 0.4, honeycomb_height + 0.4 ], x_hexagons);

    // Honeycomb on Y-Axis
    x1 = -size.x / 2;
    mirror_copy([ 1, 0, 0 ]) translate([ x1, 0, z ]) rotate([ 90, 0, 90 ])
        linear_extrude(wall_width) honeycomb_rectangle(
            [ honeycomb_depth + 0.4, honeycomb_height + 0.4 ], y_hexagons);
  }
}

// ------------------------------------------------------------
// Test
// ------------------------------------------------------------

honeycomb_box([ 80, 100, 130 ], border_radius = 5, wall_width = 1.2,
              x_hexagons = 7, y_hexagons = 9, padding_bottom = 25,
              padding_top = 15, padding_horizontal = 10);
