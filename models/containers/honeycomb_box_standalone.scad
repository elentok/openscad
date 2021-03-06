$fn = 50;

// ============================================================
// Honeycomb Box Module
// ============================================================
module honeycomb_box(size, border_radius, wall_width, hexagon_radius,
                     hexagon_dist, padding_bottom, padding_top,
                     padding_horizontal) {
  honeycomb_height = size.z - padding_bottom - padding_top;
  honeycomb_width = size.x - padding_horizontal * 2;
  honeycomb_depth = size.y - padding_horizontal * 2;

  difference() {
    box_with_label(size, border_radius, wall_width);

    // Pattern on the label side
    translate([
      padding_horizontal - size.x / 2, (size.y + 10) / 2,
      padding_bottom
    ]) {
      rotate([ 90, 0, 0 ]) {
        blocked_hexagons(size.y + 10, hexagon_radius, hexagon_dist,
                         honeycomb_width, honeycomb_height);
      }
    }

    // Pattern on the other side
    translate([
      -(size.x + 10) / 2, padding_horizontal - size.y / 2,
      padding_bottom
    ]) {
      rotate([ 90, 0, 90 ]) {
        blocked_hexagons(size.x + 10, hexagon_radius, hexagon_dist,
                         honeycomb_depth, honeycomb_height);
      }
    }
  }
}

// ============================================================
// Box With Label Module
// ============================================================

module box_with_label(size, radius, wall_width) {
  box(size, radius, wall_width);

  label_width = 60;
  label_depth = 10;
  label_height = 10;

  translate(
      [ -label_width / 2, size.y / 2 - label_depth, size.z - label_height ]) {
    shelf([ label_width, label_depth, label_height ]);
  }
}

// ============================================================
// Box Module
// ============================================================

module box(size, radius, wall_width) {
  linear_extrude(size.z) { rsquare_shell(size.x, size.y, radius, wall_width); }

  linear_extrude(wall_width) { rsquare(size.x, size.y, radius); }
}

// ============================================================
// Rounded Rectangle Border Module
// ============================================================

module rsquare_shell(width, height, radius, wall_width) {
  difference() {
    rsquare(width, height, radius);
    rsquare(width - wall_width * 2, height - wall_width * 2, radius);
  }
}

// ============================================================
// Rounded Rectangle Module
// ============================================================

module rsquare(width, height, radius) {
  minkowski() {
    square([ width - radius * 2, height - radius * 2 ], center = true);
    circle(radius);
  }
}

// ============================================================
// Shelf Module (for the label)
// ============================================================

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

// ============================================================
// Shelf Triangle (to hold the shelf)
// ============================================================

module shelf_triangle(size, triangle_width) {
  rotate([ 90, 0, 90 ]) {
    linear_extrude(triangle_width) {
      polygon([[size, size], [0, size], [size, 0]]);
    }
  }
}

// ============================================================
// 3D Hexagons Module
// ============================================================

module hexagons(extrusion_height, radius, distance, x_reps, y_reps) {
  hexagon_height = radius * 2;
  side = radius;

  // Using the pythagorean theorem:
  //
  //   (Width/2)^2 + (r/2)^2 = r^2
  //
  hexagon_width = sqrt(3) * radius;

  // Using the pythagorean theorem:
  //
  //   VertDist^2 + (Dist/2)^2 = Dist^2
  //
  vertical_distance = sqrt(1.25) * distance;

  pattern_height = hexagon_height + vertical_distance * 2 + side;
  pattern_width = hexagon_width + distance;

  for (index_y = [0:1:y_reps - 1]) {
    y1 = index_y * pattern_height;
    y2 = y1 + 0.75 * hexagon_height + vertical_distance;

    for (index_x = [0:1:x_reps - 1]) {
      x1 = index_x * pattern_width;
      translate([ x1, y1, 0 ]) hexagon(extrusion_height, radius);

      x2 = x1 + hexagon_width / 2 + distance / 2;

      translate([ x2, y2, 0 ]) hexagon(extrusion_height, radius);
    }
  }
}

// ============================================================
// 3D Blocked Hexagons Module (constrained within a cube)
// ============================================================

module blocked_hexagons(extrusion_height, radius, distance, width, height) {
  hexagon_height = radius * 2;
  hexagon_width = sqrt(3) * radius;
  x_reps = ceil(width / (hexagon_width + distance)) + 1;
  y_reps = ceil(height / (hexagon_height + distance)) + 1;

  intersection() {
    cube([ width, height, extrusion_height ]);
    hexagons(extrusion_height, radius, distance, x_reps, y_reps);
  }
}

// ============================================================
// Hexagon Module
// ============================================================

module hexagon(extrusion_height, radius) {
  rotate([ 0, 0, 90 ]) cylinder($fn = 6, h = extrusion_height, r = radius);
}

// ============================================================
// Main Component
// ============================================================

honeycomb_box([ 98, 93, 130 ], border_radius = 5, wall_width = 1.2,
              hexagon_radius = 5, hexagon_dist = 2, padding_bottom = 25,
              padding_top = 15, padding_horizontal = 10);
