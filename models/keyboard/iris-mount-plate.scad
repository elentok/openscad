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

module magnetic_mount_plate_glue_helper() {}

module magnetic_mount_plate() {
  difference() {
    union() {
      mount_plate();
      magnetic_plate();
    }
    magnet_shift() { magnet_mask(); };
    // magnets_mask();
  }
}

module magnetic_plate() {
  cyl(r = magnet_plate_r, h = magnet_plate_h, anchor = BOTTOM);
}

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

module magnets_mask() {
  left(magnet_dist / 2) {
    back(magnet_dist / 2) magnet_mask();
    fwd(magnet_dist / 2) magnet_mask();
  }
  right(magnet_dist / 2) {
    back(magnet_dist / 2) magnet_mask();
    fwd(magnet_dist / 2) magnet_mask();
  }
}

module magnet_mask() {
  up(magnet_plate_h - magnet_h + 0.01)
      cyl(d = magnet_d, h = magnet_h, anchor = BOTTOM);
}

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
magnetic_mount_plate();
