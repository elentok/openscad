include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;

base_w = 100;
base_h = 5;
base_depth = 160;

screw_d = 4.2;
nut_d = 7.5;
nut_h = 3;

holder_height = 12;
holder_depth = 12;
holder_width = 12;
holder_front_padding = 5;

arm_thickness = 4;

arm1_width = 50;
arm1_height = 110;
arm_connector_d = 7;

tolerance = 0.1;
space_between_holders = arm1_width - holder_depth * 2;

module base() {
  linear_extrude(base_h, convexity = 4)
      rect([ base_w, base_depth ], rounding = 10);

  fwd(base_depth / 2 - holder_depth / 2 - holder_front_padding)
      up(base_h - epsilon) {
    left(space_between_holders / 2 + holder_width / 2) holder(nut = true);
    right(space_between_holders / 2 + holder_width / 2) holder();
  }
}

module holder(nut = false) {
  up(holder_height / 2) rotate([ 90, 0, 90 ]) difference() {
    linear_extrude(holder_width, convexity = 4, center = true) holder2d();
    if (nut) {
      down(holder_width / 2 + epsilon) linear_extrude(nut_h) hexagon(d = nut_d);
    }
  }
}

module holder2d() {
  r = holder_depth / 2;
  difference() {
    rect([ holder_depth, holder_height ], rounding = [ r, r, 0, 0 ]);
    circle(d = screw_d);
  }
}

module arm1() {
  difference() { arm1_base(); }
}

module arm1_base() {
  w = space_between_holders - tolerance;
  h = arm1_height - (arm_connector_d - screw_d);
  linear_extrude(space_between_holders, center = true)
      rect([ h, arm_thickness ]);

  left(h / 2 + screw_d / 2) tube(od = arm_connector_d, id = screw_d, h = w);
  right(h / 2 + screw_d / 2) tube(od = arm_connector_d, id = screw_d, h = w);
}

module demo(angle = 45) {
  base();
  up(holder_height / 2)
      fwd(base_depth / 2 - holder_depth - holder_front_padding)
          rotate([ angle, 0, 0 ]) up(arm_thickness / 2 + base_h)
              back(arm1_height / 2) rotate([ 90, 0, 90 ]) arm1();
}

// holder();
// holder(nut = true);
// holder2d();
// base();
// arm1();
demo();

// debug
// #fwd(base_depth / 2 - holder_depth / 2 - holder_front_padding)
// up(holder_depth / 2 + base_h) rotate([ 0, 90, 0 ]) cyl(d = screw_d, h = 55);
