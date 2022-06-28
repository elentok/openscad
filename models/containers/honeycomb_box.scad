use <../../lib/honeycomb.scad>
use <box.scad>

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

honeycomb_box([ 80, 100, 130 ], border_radius = 5, wall_width = 1.2,
              hexagon_radius = 7, hexagon_dist = 2, padding_bottom = 25,
              padding_top = 15, padding_horizontal = 10);
