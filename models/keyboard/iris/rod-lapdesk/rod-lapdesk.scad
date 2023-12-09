include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;
rod_dist = 100;
rod_d = 10.8;
// Thickness around the rod
rod_wrapper_thickness = 6;
rod_mount_panel_size = [ 140, 30, 4 ];
sticker_d = 13;

// Nut (with tolerances) {{{1
nut_m5_d = 9;
nut_m5_h = 2;
nut_m4_h = 3.3;
nut_m4_d = 7.8;
nut_m4_w = 6.8;
m4_screw_hole_d = 4.2;
screw_hole_d = 5.2;

module rod_mount() {
  difference() {
    linear_extrude(rod_mount_panel_size.y, convexity = 4, center = true) {
      rod_mount_panel_2d();
      left(rod_dist / 2) rod_wrapper_2d();
      right(rod_dist / 2) rod_wrapper_2d();
    }

    // nuts
    nut_and_screw_mask();
    left(rod_dist / 3) nut_and_screw_mask();
    right(rod_dist / 3) nut_and_screw_mask();

    // rod strengtheners
    x = rod_dist / 2 + rod_d / 2 + 1;
    right(x) nut_and_screw_slot_mask();
    left(x) mirror([ 1, 0, 0 ]) nut_and_screw_slot_mask();

    // sticker holes
    right(rod_dist / 2) sticker_mask();
    left(rod_dist / 2) sticker_mask();
  }
}

module sticker_mask() {
  fwd(rod_d + rod_wrapper_thickness) rotate([ 90, 0, 0 ])
      cyl(d = sticker_d, h = 1.5, anchor = TOP);
}

module nut_and_screw_slot_mask() {
  fwd(rod_d / 2) rotate([ -90, 0, 0 ]) rotate([ 0, 0, -90 ]) back(nut_m4_h)
      rotate([ 90, 0, 0 ]) {
    linear_extrude(nut_m4_h) {
      rect([ nut_m4_w, 20 ], anchor = FWD);
      hexagon(d = nut_m4_d, align_side = LEFT);
    }
    up(epsilon) cyl(d = m4_screw_hole_d, h = rod_wrapper_thickness * 3);
  }
}

module nut_and_screw_mask() {
  fwd(epsilon / 2) rotate([ -90, 0, 0 ]) {
    cyl(d = screw_hole_d, h = rod_mount_panel_size.z + epsilon,
        anchor = BOTTOM);
    linear_extrude(nut_m5_h, convexity = 4)
        hexagon(d = nut_m5_d, align_side = LEFT);
  }
}

module rod_mount_panel_2d() {
  s = rod_mount_panel_size;
  rect([ s.x, s.z ], rounding = [ 0, 0, s.z / 2, s.z / 2 ], anchor = FWD);
}

module rod_wrapper_2d() {
  s = [ rod_d + rod_wrapper_thickness * 2, rod_d + rod_wrapper_thickness ];
  back(epsilon) difference() {
    rect(s, rounding = [ 0, 0, 5, 5 ], anchor = BACK);

    circle(d = rod_d, anchor = BACK);
  }
}

rod_mount();
// nut_and_screw_slot_mask();
