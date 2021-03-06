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

module curtain_hook_cover(hook_size, pole_diameter, pole_dist, wall_width = 1.6,
                          screw_area_z = 15, screw_hole_diameter = 2.8,
                          screw_head_height = 2.5, screw_head_diameter = 8) {
  outer_size = calc_outer_size(hook_size, wall_width);
  pole_position =
      calc_pole_position(outer_size, pole_diameter, wall_width, pole_dist);

  // screw part
  screw_part_size = [ hook_size.x, hook_size.y, screw_area_z ];
  screw_tube_diameter = screw_head_diameter * 1.2;

  wall1_x = pole_position.x - pole_diameter / 2 - wall_width;
  wall1_y = -hook_size.y / 2 - wall_width;
  wall2_x = pole_position.x + pole_diameter / 2;
  wall2_y = wall1_y;

  screw_tube_x = wall2_x + pole_dist.x / 2;
  screw_tube_y = screw_tube_diameter / 2;

  difference() {
    union() {
      // hook cover
      translate([ 0, 0, -hook_size.z / 2 - wall_width ]) curtain_hook_component(
          hook_size, pole_diameter, pole_dist, wall_width);

      translate([ 0, 0, screw_area_z / 2 ]) curtain_hook_component(
          screw_part_size, pole_diameter, pole_dist, wall_width);

      // wall1
      translate([ wall1_x, wall1_y, 0 ])
          cube([ wall_width, hook_size.y, screw_area_z ]);

      // wall2
      translate([ wall2_x, wall2_y, 0 ])
          cube([ wall_width, hook_size.y, screw_area_z ]);

      // screw tube
      translate([ screw_tube_x, screw_tube_y, screw_tube_diameter / 2 ])
          rotate([ 0, 90, 0 ])
              cylinder(h = pole_dist.x, d = screw_tube_diameter, center = true);
    }

    // screw hole
    screw_hole_height = pole_dist.x + wall_width * 2;
    screw_hole_x = pole_dist.x + wall_width;
    screw_hole_y = screw_hole_diameter / 2 + screw_tube_diameter / 4;
    screw_hole_z = screw_hole_diameter / 2 + wall_width;
    translate([ screw_hole_x, screw_hole_y, screw_hole_z ]) rotate([ 0, 90, 0 ])
        cylinder(h = screw_hole_height, d = screw_hole_diameter);

    // inset for screw head
    // screw_head_x = outer_size.x / 2 - screw_head_height / 2;
    // translate([ screw_head_x, screw_tube_y, screw_hole_z ]) rotate([ 0, 90, 0
    // ])
    //     cylinder(h = screw_head_height + 0.2, d = screw_head_diameter,
    //              center = true);
  }
}

// hook_size = [x, y, z]
// pole_dist = [x, y]
module curtain_hook_component(hook_size, pole_diameter, pole_dist,
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
