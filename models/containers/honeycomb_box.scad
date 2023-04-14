use <../../lib/honeycomb.scad>
use <../../lib/mirror_copy.scad>
use <box.scad>

module honeycomb_box(size, border_radius, wall_width, x_hexagons, y_hexagons,
                     padding_bottom, padding_top, padding_horizontal,
                     label = true) {
  honeycomb_height = size.z - padding_bottom - padding_top;
  honeycomb_width = size.x - padding_horizontal * 2;
  honeycomb_depth = size.y - padding_horizontal * 2;

  union() {
    difference() {
      if (label == true) {
        box_with_label(size, border_radius, wall_width);
      } else {
        box(size, border_radius, wall_width);
      }

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
        linear_extrude(wall_width, convexity = 4) honeycomb_rectangle(
            [ honeycomb_width + 0.4, honeycomb_height + 0.4 ], x_hexagons);

    // Honeycomb on Y-Axis
    x1 = -size.x / 2;
    mirror_copy([ 1, 0, 0 ]) translate([ x1, 0, z ]) rotate([ 90, 0, 90 ])
        linear_extrude(wall_width, convexity = 4) honeycomb_rectangle(
            [ honeycomb_depth + 0.4, honeycomb_height + 0.4 ], y_hexagons);
  }
}

// honeycomb_box([ 80, 100, 130 ], border_radius = 5, wall_width = 1.2,
//               x_hexagons = 7, y_hexagons = 9, padding_bottom = 25,
//               padding_top = 15, padding_horizontal = 10);

// For charger drawer
honeycomb_box([ 107, 90, 75 ], border_radius = 5, wall_width = 1.2,
              x_hexagons = 9, y_hexagons = 8, padding_bottom = 15,
              padding_top = 15, padding_horizontal = 10);
