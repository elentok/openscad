$fn = 50;

use <../../lib/rounded_square.scad>

module two_d_hook(size, pole_diameter, pole_dist, wall_width) {
  rounded_square(size, [ size.x / 2, size.x / 2, 0, 0 ]);

  x = -pole_diameter / 2 + size.x / 2;  // - wall_width;
#translate([ x, 0 ]) circle(d = pole_diameter);
}

wall_width = 2;
hook_size = [ 24, 30 ];
outer_size = [ hook_size.x + wall_width, hook_size.y + wall_width ];
two_d_hook(outer_size, pole_diameter = 10.25, pole_dist = [ 5, 6 ],
           wall_width = 2);
