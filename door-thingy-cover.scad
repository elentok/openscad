$fn = 50;

use <lib/3d.scad>

module door_thingy_cover(diameter = 38) {
  difference() {
    half_sphere(diameter);
    translate([ 0, 0, -0.1 ]) { door_thingy(); }
  }
}

module door_thingy(width = 13, square_height = 4, triangle_height = 12) {
  translate([ -width / 2, width / 2, 0 ]) {
    rotate([ 90, 0, 0 ]) {
      linear_extrude(width) {
        square([ width, square_height ]);
        polygon([[width, square_height], [width, triangle_height],
                 [0, square_height]]);
      }
    }
  }
}

// door_thingy();
door_thingy_cover();
