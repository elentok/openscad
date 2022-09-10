$fn = 60;

use <../../lib/3d.scad>
include <BOSL2/std.scad>

mount_wall_distance = 13;
mount_height = 50;
mount_width = 13;
mount_thickness = 4;
wedge_length = 7;
wedge_thickness1 = 2.5;
wedge_mid_height = 3.9;
wedge_mid_width = 1.5;
screwdriver_diameter = 8;

angle = atan(mount_wall_distance / mount_height);
wedge_height = wedge_length * cos(angle);
wedge_width = wedge_length * sin(angle);

module mount() {
  t = mount_thickness;
  r = t / 2;
  mount_path = [
    [ 0, 0 ],
    [ mount_wall_distance - t, 0 ],
    [ mount_wall_distance - t, -(mount_height - t) ],
  ];

  wedge_path = [
    [ 0, 0 ],
    [ -wedge_width, wedge_height ],
  ];

  wedge_center = [
    [ 0, 0 ],
    [ -wedge_width, wedge_height ],
  ];

  linear_extrude(mount_width, center = true) union() {
    // #left(r) back(r) square([ mount_wall_distance, mount_height ], anchor = TOP + LEFT);
    stroke(mount_path, width = t, closed = true);

    x = (t - wedge_thickness1) / 2 - 0.1;
    left(x) fwd(x) { stroke(wedge_path, width = wedge_thickness1); }
  }

  stroke([ [ 0, 0, 0 ], [ -wedge_width, wedge_height, 0 ] ], width = wedge_thickness1);
  // linear_extrude(wedge_mid_width, center = true) stroke(wedge_path, width = wedge_thickness1);
}

module mount_holes() {
  fwd(mount_height / 4) mount_screw_hole();

  // screwdriver hole
  fwd(mount_height / 4) left(mount_thickness / 2) rotate([ 0, 90, 0 ])
      cylinder(h = mount_wall_distance - mount_thickness, d = screwdriver_diameter);
}

module mount_screw_hole() {
  t = mount_thickness;
  right(mount_wall_distance - t) rotate([ 0, -90, 0 ])
      screw_hole_mask(h = t + 0.2, d_screw = 4, d_head = 8);
}

difference() {
  mount();
  mount_holes();
}
