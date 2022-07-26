use <./cable-hook-mark2.scad>

hook_size = [ 40, 20, 40 ];

ziptie_width = 9.5;
ziptie_height = 2;
ziptie_grip_height = 4;

module ziptie_grip() {
  z = -hook_size.z / 2 - ziptie_grip_height / 2;

  translate([ 0, 0, z ]) rotate([ 0, 90, 0 ]) linear_extrude(hook_size.x, center = true) {
    difference() {
      square([ ziptie_grip_height, hook_size.y ], center = true);
      ziptie_hole_x = -ziptie_grip_height / 2 + ziptie_height / 2;
      translate([ ziptie_hole_x, 0 ]) square([ ziptie_height, ziptie_width ], center = true);
    }
  }
}

union() {
  cable_hook_mark2(hook_size, thickness = 3, inner_radius = 15);
  ziptie_grip();
}
