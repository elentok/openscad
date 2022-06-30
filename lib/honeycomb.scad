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
// Test
// ------------------------------------------------------------

translate([ 0, 0, -1 ]) linear_extrude(1)
    honeycomb_rectangle([ 50, 100 ], hexagons = 5, thickness = 2);
// translate([ 0, -11, -1 ]) linear_extrude(1) honeycomb_pattern(10, 5, 20, 2);
// translate([ 0, 0, -1 ]) linear_extrude(1) hexagon_shell(20, 2);
