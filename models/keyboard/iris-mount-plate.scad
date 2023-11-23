include <../../lib/screw-hole-mask.scad>
include <BOSL2/screws.scad>
include <BOSL2/std.scad>
$fn = 64;

dist_between_holes = 123;
width = 20;
hole_d = 7;
length = dist_between_holes + 3 * 2 + hole_d;
h = 3;

magnet_d = 15;
magnet_h = 2.4;
// distance between the magnets center
magnet_dist = 25;
magnet_plate_padding = 10;
magnet_plate_h = 4;
magnet_plate_r = magnet_dist / 2 + magnet_d / 2 + magnet_plate_padding;

tripod_magnet_plate_h = 6;

module magnetic_mount_plate_glue_helper() {
  cyl(r = magnet_dist / 2 + magnet_d / 2 + 9 / 2, h = 2, anchor = TOP);
  magnet_shift() tube(id = 7, od = 9, h = 7, anchor = BOTTOM);
}

module magnetic_tripod_plate() {
  difference() {
    magnetic_plate(h = tripod_magnet_plate_h);
    up(tripod_magnet_plate_h - magnet_h + 0.01) magnet_shift() {
      magnet_mask();
    };

    down(0.01 / 2)
        screw_hole("1/4-20", thread = true, l = tripod_magnet_plate_h + 0.01,
                   anchor = BOTTOM);
  }
}

module magnetic_mount_plate(keyboard = true, screw_hole = false) {
  difference() {
    union() {
      if (keyboard) {
        mount_plate();
      }
      magnetic_plate(h = magnet_plate_h);
    }

    up(magnet_plate_h - magnet_h + 0.01) magnet_shift() magnet_mask();
    if (screw_hole) {
      down(0.01 / 2) screw_hole_mask(
          d_screw = 4.2, d_screw_head = 10, l_countersink = 2.5,
          l_wall = magnet_plate_h + 0.01, axis = UP, anchor = BOTTOM);
    }
  }
}

module magnetic_plate(h) { cyl(r = magnet_plate_r, h = h, anchor = BOTTOM); }

module magnet_shift() {
  left(magnet_dist / 2) {
    back(magnet_dist / 2) children();
    fwd(magnet_dist / 2) children();
  }
  right(magnet_dist / 2) {
    back(magnet_dist / 2) children();
    fwd(magnet_dist / 2) children();
  }
}

module magnet_mask() { cyl(d = magnet_d, h = magnet_h, anchor = BOTTOM); }

module mount_plate() {
  linear_extrude(h) difference() {
    rect([ length, width ], rounding = width / 2);
    left(dist_between_holes / 2)
        rect([ hole_d * 1.5, hole_d ], rounding = hole_d / 2);
    right(dist_between_holes / 2)
        rect([ hole_d * 1.5, hole_d ], rounding = hole_d / 2);
  }
}

// mount_plate();
// magnetic_mount_plate();
// magnetic_mount_plate_glue_helper();
// magnetic_tripod_plate();

module tripod_bolt() {
  screw("1/4-20", head = "flat", l = 25, drive = "phillips", anchor = BOTTOM);
}
// #cyl(d = 2, h = 25, anchor = BOTTOM);

module ball_joint_base() {
  w = 23;
  h = 3;

  difference() {
    linear_extrude(h, convexity = 4) rect([ w, w * 3 ], rounding = w / 2);
    back(w) down(0.01 / 2)
        screw_hole_mask(d_screw = 4, d_screw_head = 10, l_wall = h,
                        l_countersink = 1.5, axis = UP, anchor = BOTTOM);

    fwd(w) down(0.01 / 2)
        screw_hole_mask(d_screw = 4, d_screw_head = 10, l_wall = h,
                        l_countersink = 1.5, axis = UP, anchor = BOTTOM);
  }
}

// ball_joint_base();
magnetic_mount_plate(keyboard = false, screw_hole = true);
