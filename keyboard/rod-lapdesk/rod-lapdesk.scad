include <../../lib/screw-masks.scad>
include <../../lib/screw-sizes.scad>
include <BOSL2/std.scad>
$fn = 64;

epsilon = 0.01;
rod_dist = 100;
rod_d = 10.8;
// Thickness around the rod
rod_wrapper_thickness = 6;
rod_mount_panel_size = [ 140, 30, 6 ];
sticker_d = 13;

// Nut (with tolerances) {{{1
// nut_m5_d = 9;
tripod_bolt_d = 6.5;
tripod_nut_d = 12.4;
tripod_nut_h = 5.4;

rect_plate_size = [ 110, 140, 3 ];
rect_plate_rounding = 30;
rect_plate_border_h = 4;
rect_plate_border_thickness = 2;

module trapezoid_plate() {
  w1 = 95;   // 85
  w2 = 155;  // 140
  l = 195;   // 177
  panel_thickness = 2;
  border_thickness = 2;
  border_height = 4;

  linear_extrude(panel_thickness) difference() {
    half_trapezoid(l = l, w1 = w1, w2 = w2);
    right(w1 / 2 + (w2 - w1) / 4) screw_hole_mask2d("m5");
  }
  linear_extrude(panel_thickness + border_height) {
    difference() {
      half_trapezoid(l = l, w1 = w1, w2 = w2);
      right(border_thickness) half_trapezoid(l = l - border_thickness * 2,
                                             w1 = w1 - border_thickness * 2,
                                             w2 = w2 - border_thickness * 2);
    }
  }
}

module half_trapezoid(l, w1, w2) {
  round2d(r = 5) {
    intersection() {
      trapezoid(h = l, w1 = w1 * 2, w2 = w2 * 2);
      rect([ w2, l ], anchor = LEFT);
    }
  }
}

module rect_plate() {
  s = rect_plate_size;
  linear_extrude(s.z, convexity = 5) difference() {
    rect([ s.x, s.y ], rounding = rect_plate_rounding);
    back(s.y / 2 - 62) left(s.x / 2 - 30) circle(d = screw_hole_d("m5"));
  }

  rect_tube(h = s.z + rect_plate_border_h, size = [ s.x, s.y ],
            wall = rect_plate_border_thickness, rounding = rect_plate_rounding);
}

module rod_mount() {
  difference() {
    linear_extrude(rod_mount_panel_size.y, convexity = 4, center = true) {
      rod_mount_panel_2d();
      left(rod_dist / 2) rod_wrapper_2d();
      right(rod_dist / 2) rod_wrapper_2d();
    }

    // nuts
    left(7) nut_and_screw_mask("m5");
    right(7) nut_and_screw_mask("1/4");
    left(rod_dist / 4) nut_and_screw_mask("m5");
    right(rod_dist / 4) nut_and_screw_mask("m5");

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
  fwd(rod_d / 2) rotate([ -90, 0, 0 ]) rotate([ 0, 0, -90 ]) back(nut_h("m4"))
      rotate([ 90, 0, 0 ]) {
    linear_extrude(nut_h("m4")) {
      rect([ nut_w("m4"), 20 ], anchor = FWD);
      hexagon(d = nut_d("m4"), align_side = LEFT);
    }
    up(epsilon) cyl(d = screw_hole_d("m4"), h = rod_wrapper_thickness * 3);
  }
}

module nut_and_screw_mask(type) {
  fwd(epsilon / 2) rotate([ -90, 0, 0 ]) {
    screw_hole_mask(type, h = rod_mount_panel_size.z + epsilon,
                    anchor = BOTTOM);
    nut_mask(type);
  }
}

module rod_mount_panel_2d() {
  s = rod_mount_panel_size;
  rect([ s.x, s.z ], rounding = s.z / 2, anchor = FWD);
}

module rod_wrapper_2d() {
  s = [ rod_d + rod_wrapper_thickness * 2, rod_d + rod_wrapper_thickness ];
  back(epsilon) difference() {
    rect(s, rounding = [ 0, 0, 5, 5 ], anchor = BACK);

    circle(d = rod_d, anchor = BACK);
  }
}

tripod_adapter_w = 25;
tripod_adapter_d = 35;
tripod_adapter_h = 6.5;

module tripod_adapter() {
  difference() {
    linear_extrude(tripod_adapter_h, convexity = 4) difference() {
      rect([ tripod_adapter_w, tripod_adapter_d ], rounding = 5);
      fwd(tripod_adapter_d / 5) circle(d = screw_hole_d("m5"));
      back(tripod_adapter_d / 5) circle(d = tripod_bolt_d);
    }

    up(tripod_adapter_h + epsilon) fwd(tripod_adapter_d / 5)
        cyl(d = screw_head_d("m5"), h = screw_head_h("m5"), anchor = TOP);

    down(epsilon) back(tripod_adapter_d / 5) nut_mask("1/4");
  }
}

module tripod_washer(h = 3) { tube(od = 20, id = tripod_bolt_d, h = h); }

// tripod_washer();

// tripod_adapter();

// trapezoid_plate();
// rect_plate();
rod_mount();
// nut_and_screw_slot_mask();
