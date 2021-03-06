$fn = 50;

use <../../lib/rounded_square.scad>

module panel(size, pole_diameter, offset) {
  difference() {
    translate(offset) rounded_square(size, [ size.x / 2, size.x / 2, 0, 0 ]);
    circle(d = pole_diameter);
    translate([ 0, -size.y / 2 ]) square([ pole_diameter, size.y ], center = true);
  }
}

module outer_wall(size, offset, wall_width) {
  inner_size = [ size.x - wall_width * 2, size.y - wall_width ];

  translate(offset) difference() {
    rounded_square(size, [ size.x / 2, size.x / 2, 0, 0 ]);

    translate([ 0, -wall_width ])
        rounded_square(inner_size, [ inner_size.x / 2, inner_size.x / 2, 0, 0 ]);
  }
}

module inner_wall(size, offset, pole_diameter, wall_width) {
  outer_size = [ pole_diameter + wall_width * 2, size.y / 2 - offset.y ];
  inner_size = [ pole_diameter, size.y / 2 - offset.y ];

  difference() {
    union() {
      circle(d = outer_size.x);
      translate([ 0, -outer_size.y / 2 ]) square(outer_size, center = true);
    }

    union() {
      circle(d = inner_size.x);
      translate([ 0, -inner_size.y / 2 ]) square(inner_size, center = true);
    }
  }
}

module curtain_hook_cover(hook_size, pole_diameter, pole_dist, wall_width) {
  outer_size = [ hook_size.x + wall_width * 2, hook_size.y + wall_width * 2 ];
  offset = [
    pole_diameter / 2 - outer_size.x / 2 + wall_width + pole_dist.x,
    pole_diameter / 2 - outer_size.y / 2 + wall_width + pole_dist.y,
  ];

  screw_head_diameter = 8;
  screw_head_height = 2.1;
  tightener_height = screw_head_diameter * 1.5;

  difference() {
    union() {
      // Bottom panel
      linear_extrude(wall_width) panel(outer_size, pole_diameter, offset);

      // Middle panel
      mid_panel_z = hook_size.z + wall_width;
      translate([ 0, 0, mid_panel_z ]) linear_extrude(wall_width)
          panel(outer_size, pole_diameter, offset);

      // Top panel
      top_panel_z = mid_panel_z + wall_width + tightener_height;
      translate([ 0, 0, top_panel_z ]) linear_extrude(wall_width)
          panel(outer_size, pole_diameter, offset);

      // Outer wall
      linear_extrude(top_panel_z + wall_width) outer_wall(outer_size, offset, wall_width);

      // Inner wall
      translate([ 0, 0, mid_panel_z + wall_width ]) linear_extrude(tightener_height)
          inner_wall(outer_size, offset, pole_diameter, wall_width);

      // Screw support
      screw_support_size = [
        // x:
        pole_dist.x - wall_width + 0.1,
        // y:
        screw_head_diameter * 1.4,
      ];
      screw_support_offset = [
        // x:
        hook_size.x / 2 - screw_support_size.x - wall_width + 0.2,
        // y:
        -screw_support_size.y / 2
      ];
      translate([ 0, 0, hook_size.z + wall_width * 2 ]) linear_extrude(tightener_height)
          intersection() {
        panel(outer_size, pole_diameter, offset);
        translate(screw_support_offset) square(screw_support_size);
      }
    }

    screw_offset = [
      // x:
      outer_size.y / 2 + offset.y - screw_head_height / 2 + 0.1,
      // y:
      0,
      // z:
      tightener_height / 2 + 2 * wall_width + hook_size.z
    ];

    translate(screw_offset) rotate([ 0, -90, 0 ]) screw(screw_head_height, screw_head_diameter);
  }
}

module screw(head_height = 2.1, head_diameter = 8, screw_diameter = 2.8, screw_height = 5.8) {
  cylinder(d = head_diameter, h = head_height);
  translate([ 0, 0, head_height ]) cylinder(d = screw_diameter, h = screw_height);
}

// Mark 3
mirror([ 0, 1, 0 ]) curtain_hook_cover(hook_size = [ 24, 30, 4.2 ], pole_diameter = 10.29,
                                       pole_dist = [ 5, 6 ], wall_width = 1.7);
