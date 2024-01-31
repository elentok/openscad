include <../lib/screw-sizes.scad>
include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;
depth_back = 90;
depth_fwd = 80;
angle = -5;
height_back = 120;
height_fwd = 90;
laptop_thickness = 14;
bottom_thickness = 15;

side_thickness = 20;

screw_type = "m4";

connector_d = 7;
rod_size = [ 10, 10 ];
rod_length = 14;

module stand() { side(); }

module side() {
  rotate([ 0, 0, 0 ]) {
    difference() {
      linear_extrude(side_thickness, center = true, convexity = 4) slice();
      fwd() hole_mask();
    }
  }
}

module hole_mask() {
  cyl(d = screw_hole_d(screw_type), h = side_thickness + epsilon);
  down(epsilon) cyl(d = screw_head_d(screw_type) * 1.5, h = side_thickness / 2,
                    anchor = TOP);
}

module slice() {
  path = [
    [ -depth_fwd, 0 ], [ depth_back, 0 ], [ laptop_thickness, height_back ],
    [ 0, height_fwd ]
  ];

  round2d(or = 2) difference() {
    polygon(path);
    rotate([ 0, 0, angle ]) back(bottom_thickness)
        rect([ laptop_thickness, height_back ], anchor = BOTTOM);
  }
}

stand();
