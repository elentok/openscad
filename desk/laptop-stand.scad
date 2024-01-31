include <../lib/screw-sizes.scad>
include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

fast_render = false;

epsilon = 0.01;
depth_back = 90;
depth_fwd = 80;
angle = -5;
height_back = 120;
height_fwd = 90;
laptop_thickness = 14;
bottom_thickness = 15;

side_thickness = 15;

screw_type = "m4";

connector_d = 7;
rod_size = [ 15, 10 ];
rod_length = 120;

module stand() {
  left(side_thickness / 2 + rod_length / 2) side();
  right(side_thickness / 2 + rod_length / 2) mirror([ 1, 0, 0 ]) side();
  rod();
}

module rod() {
  up(rod_size.y / 2) rotate([ 90, 0, 90 ]) difference() {
    linear_extrude(rod_length, convexity = 4, center = true) {
      difference() {
        rect(rod_size, rounding = [ rod_size.y / 2, rod_size.y / 2, 0, 0 ]);
        circle(d = screw_threadmaker_d(screw_type));
      }
    }
    // screw_hole(screw_type, l = rod_length + epsilon, thread = !fast_render,
    //            $slop = 0.25);
  }
}

module side() {
  rotate([ 90, 0, 90 ]) {
    difference() {
      linear_extrude(side_thickness, center = true, convexity = 4) slice();
#back(rod_size.y / 2) {
      left(depth_fwd * 0.8) hole_mask();
      right(depth_back * 0.8) hole_mask();
      back(height_back * 0.5) right(30) hole_mask();
    }
  }
}
}

module hole_mask() {
  cyl(d = screw_hole_d(screw_type), h = side_thickness + epsilon);
  down(epsilon) cyl(d = screw_head_d(screw_type) * 1.1, h = side_thickness / 2,
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

side();
// rod();
// stand();
