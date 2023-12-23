include <BOSL2/std.scad>
use <./bin.scad>
$fn = 64;

epsilon = 0.01;

// Using the pythagorean theorem:
//
//   (Width/2)^2 + (r/2)^2 = r^2
//
function calc_hexagon_width(diameter) = sqrt(3) * diameter / 2;
function calc_hexagon_diameter(width) = width * 2 / sqrt(3);

// Using the pythagorean theorem:
//
//   VertDist^2 + (Dist/2)^2 = Dist^2
//
function calc_hexagon_vertical_distance(horizontal_distance) =
    sqrt(1.25) * horizontal_distance;

module honeycomb_wall_mask_3d(size, x_spacing, x_hexagons, anchor = CENTER,
                              spin = 0) {
  attachable(size = size, anchor, spin) {
    rotate([ 90, 0, 0 ]) linear_extrude(size.y, convexity = 4, center = true)
        honeycomb_mask([ size.x, size.z ], x_spacing, x_hexagons);
    children();
  }
}

module honeycomb_mask_3d(size, x_spacing, x_hexagons, anchor = CENTER,
                         spin = 0) {
  attachable(size = size, anchor, spin) {
    linear_extrude(size.z, convexity = 4)
        honeycomb_mask([ size.x, size.y ], x_spacing, x_hexagons);
    children();
  }
}

module honeycomb_mask(size, x_spacing, x_hexagons) {
  hw = (size.x - (x_hexagons - 1) * x_spacing) / x_hexagons;
  hd = calc_hexagon_diameter(hw);
  echo("Hexagon Width:", hw);
  echo("Hexagon Diameter:", hd);

  pattern_height = sqrt(0.75) * (hw + x_spacing);
  y_hexagons = ceil(size.y / pattern_height);
  echo("Y hexagons: ", y_hexagons);

  intersection() {
    rect(size);

    back(size.y / 2 - hd / 2) left(size.x / 2) {
      for (j = [1:y_hexagons]) {
        x0 = (j % 2 == 0) ? hw / 2 + x_spacing / 2 : 0;
        i0 = (j % 2 == 0) ? 0 : 1;
        y = pattern_height * (j - 1);
        fwd(y) for (i = [i0:x_hexagons]) {
          x = x0 + (hw + x_spacing) * (i - 1);
          right(x) hexagon(d = hd, realign = true, anchor = LEFT);
        }
      }
    }
  }
}

module honeycomb_bin(size, wall_thickness, rounding, x_hexagons, x_spacing,
                     y_spacing, y_hexagons, padding_bottom, padding_top,
                     padding_x, padding_y) {
  echo("PADDING BOTTOM", padding_bottom);
  echo("PADDING TOP", padding_top);
  echo("X SPACING", x_spacing);

  diff() {
    bin(size, wall_thickness, rounding) {
      x_mask_size = [
        size.x - padding_x * 2,
        wall_thickness + epsilon * 2,
        size.z - padding_top - padding_bottom,
      ];
      echo("X MASK SIZE", x_mask_size);
      tag("remove") up(padding_bottom) back(epsilon) position(BACK + BOTTOM)
          honeycomb_wall_mask_3d(size = x_mask_size, x_spacing = x_spacing,
                                 x_hexagons = x_hexagons,
                                 anchor = BACK + BOTTOM);

      tag("remove") up(padding_bottom) fwd(epsilon) position(FWD + BOTTOM)
          honeycomb_wall_mask_3d(size = x_mask_size, x_spacing = x_spacing,
                                 x_hexagons = x_hexagons,
                                 anchor = FWD + BOTTOM);

      y_mask_size = [
        size.y - padding_y * 2,
        wall_thickness + epsilon * 2,
        size.z - padding_top - padding_bottom,
      ];
      echo("Y MASK SIZE", y_mask_size);
      tag("remove") up(padding_bottom) right(wall_thickness / 2) back(epsilon)
          position(LEFT + BOTTOM) rotate([ 0, 0, 90 ])
              honeycomb_wall_mask_3d(size = y_mask_size, x_spacing = y_spacing,
                                     x_hexagons = y_hexagons, anchor = BOTTOM);

      tag("remove") up(padding_bottom) left(wall_thickness / 2) back(epsilon)
          position(RIGHT + BOTTOM) rotate([ 0, 0, 90 ])
              honeycomb_wall_mask_3d(size = y_mask_size, x_spacing = y_spacing,
                                     x_hexagons = y_hexagons, anchor = BOTTOM);
    }
  }
}

honeycomb_bin(size = [ 170, 72, 70 ], wall_thickness = 2.5,
              rounding = [ 0, 0, 10, 10 ], padding_bottom = 10,
              padding_top = 15, padding_x = 10, padding_y = 10, x_spacing = 10,
              y_spacing = 10, x_hexagons = 4, y_hexagons = 2);
// honeycomb_mask(size = [ 170, 70 ], x_spacing = 10, x_hexagons = 4);
// honeycomb_mask_3d(size = [ 170, 70, 30 ], x_spacing = 7, x_hexagons = 5);
// honeycomb_wall_mask_3d(size = [ 100, 10, 70 ], x_spacing = 7, x_hexagons = 5,
//                        anchor = BOTTOM);
// #cube([ 100, 10, 70 ], center = true);
