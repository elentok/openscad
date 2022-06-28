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

  x_reps = ceil(size.x / hexagon_width);
  y_reps = ceil(size.y / pattern_height);

  intersection() {
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

  for (index_x = [0:x_reps - 1]) {
    x1 = index_x * hexagon_width;
    x2 = x1 + hexagon_width / 2;

    for (index_y = [0:y_reps - 1]) {
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
// Test
// ------------------------------------------------------------

honeycomb_rectangle([ 100, 50 ], 20, 2);
// honeycomb_pattern(10, 5, 20, 2);
// hexagon_shell(20, 2);
