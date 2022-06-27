$fn = 60;

use <../../lib/3d.scad>

module sonic_stand() {
  base_height = 2.1;
  height_diff_between_legs = 2;
  union() {
    half_rounded_disc(diameter = 85, height = base_height);

    translate([ -10, 0, 0 ]) {
      half_rounded_disc(diameter = 10,
                        height = base_height + height_diff_between_legs);
    }
  }
}

sonic_stand();
