use <../../lib/hexagon.scad>
use <box.scad>

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

honeycomb_box([ 98, 93, 130 ], border_radius = 5, wall_width = 1.2,
              hexagon_radius = 5, hexagon_dist = 2, padding_bottom = 25,
              padding_top = 15, padding_horizontal = 10);
