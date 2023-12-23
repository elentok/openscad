include <BOSL2/std.scad>
$fn = 64;

thickness = 1.2;
solder_height = 2.8;
width_between_feet = 12.6;
width_around_feet = 17.4;
board_width = 18.4;
depth = 38;
height_below_arduino = 7;
board_thickness = 1.6;
type_c_height = 3.9;

width = board_width + thickness * 2;
height = thickness + solder_height + board_thickness + height_below_arduino;

echo("Height: ", height);

module front() {
  r = thickness / 2;

  linear_extrude(thickness) difference() {
    rect([ width, height ], rounding = [ r, r, 0, 0 ], anchor = BACK);

    // type-c
    fwd(thickness + board_thickness + solder_height) rect(
        [ width_between_feet, type_c_height ], rounding = r, anchor = BACK);
  }
}

module body() {
  r = thickness / 2;

  linear_extrude(depth) difference() {
    rect([ width, height ], rounding = [ r, r, 0, 0 ], anchor = BACK);

    // type-c
    fwd(thickness) rect([ board_width, height - thickness ],
                        rounding = [ r, r, 0, 0 ], anchor = BACK);
  }

  // spacer (solder height)
  fwd(thickness)
      cube([ 3, solder_height - 0.1, depth ], anchor = BACK + BOTTOM);

  // grip (between feet)
  fwd(height) cube([ width_between_feet, 2, 10 ], anchor = BOTTOM + FWD);

  // grip (around feet)
  fwd(height) linear_extrude(depth) {
    difference() {
      rect([ width, thickness ], anchor = FWD);
      rect([ width_around_feet, thickness ], anchor = FWD);
    }
  }
}

up(thickness - 0.01) body();
front();
