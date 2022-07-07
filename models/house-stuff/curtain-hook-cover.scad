$fn = 50;

use <../../lib/rounded_square.scad>

function calc_outer_size(hook_size, wall_width) = [
  hook_size.x + 2 * wall_width, hook_size.y + 2 * wall_width, hook_size.z + 2 *
  wall_width
];

function calc_pole_position(outer_size, pole_diameter, wall_width, pole_dist) =
    [
      // x:
      outer_size.x / 2 - pole_diameter / 2 - wall_width - pole_dist.x,
      // y:
      outer_size.y / 2 - pole_diameter / 2 - wall_width - pole_dist.y
    ];

// hook_size = [x, y, z]
// pole_dist = [x, y]
module curtain_hook_cover(hook_size, pole_diameter, pole_dist, pole_dist,
                          wall_width = 1.6) {
  outer_size = calc_outer_size(hook_size, wall_width);
  pole_position =
      calc_pole_position(outer_size, pole_diameter, wall_width, pole_dist);

  difference() {
    linear_extrude(outer_size.z, center = true)
        rounded_square([ outer_size.x, outer_size.y ],
                       [ outer_size.x / 2, outer_size.x / 2, 0, 0 ]);

    linear_extrude(hook_size.z, center = true) translate([ 0, -wall_width / 2 ])
        rounded_square([ hook_size.x, hook_size.y + wall_width + 0.1 ],
                       [ hook_size.x / 2, hook_size.x / 2, 0, 0 ]);

    translate(pole_position)
        cylinder(h = outer_size.z + 0.1, d = pole_diameter, center = true);

    cube_position = [
      pole_position.x,
      // y:
      -(pole_dist.y + wall_width + pole_diameter / 2)
    ];
    translate(cube_position) cube(
        [ pole_diameter, outer_size.y, outer_size.z + 0.1 ], center = true);
  }
}

// Mark 1 - too small
// curtain_hook_cover(hook_size = [ 23.9, 30, 3.9 ], pole_diameter = 10.5,
//                    pole_dist_x = 5, pole_dist_y = 6);

// Mark 2
curtain_hook_cover(hook_size = [ 24, 30, 4.2 ], pole_diameter = 10.25,
                   pole_dist = [ 5, 6 ]);
