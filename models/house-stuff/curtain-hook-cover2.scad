$fn = 50;

use <../../lib/rounded_square.scad>

module two_d_hook(size, pole_diameter, pole_dist, wall_width) {
  x = pole_diameter / 2 - size.x / 2 + wall_width + pole_dist.x;
  y = pole_diameter / 2 - size.y / 2 + wall_width + pole_dist.y;

  difference() {
    translate([ x, y ]) rounded_square(size, [ size.x / 2, size.x / 2, 0, 0 ]);
    circle(d = pole_diameter);
    translate([ 0, -size.y / 2 ])
        square([ pole_diameter, size.y ], center = true);
  }
}

module curtaion_hook_cover(hook_size, pole_diameter, pole_dist, wall_width) {
  // wall_width = 2;
  // hook_size = [ 24, 30 ];
  outer_size = [ hook_size.x + wall_width * 2, hook_size.y + wall_width * 2 ];
  two_d_hook(outer_size, pole_diameter = 10.25, pole_dist = [ 5, 6 ],
             wall_width = 2);
}

curtaion_hook_cover(hook_size = [ 24, 30 ], pole_diameter = 10.25,
                    pole_dist = [ 5, 6 ], wall_width = 2);
