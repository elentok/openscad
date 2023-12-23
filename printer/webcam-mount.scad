include <BOSL2/screws.scad>
include <BOSL2/std.scad>
use <../../lib/screw-hole-mask.scad>
$fn = 64;

plate_thickness = 2.4;
plate_padding = 10;

thread_length = 4.5;

// distance between the centers of the holes
hole_dist = 25;
hole_diameter = 5;

plate_size = hole_dist + hole_diameter + plate_padding;

module webcam_mount() {
  plate();

  rotate([ 0, 180, 0 ]) screw("1/4-20", l = thread_length + plate_thickness,
                              thread_len = thread_length, anchor = TOP);
}

module plate() {
  difference() {
    linear_extrude(plate_thickness) difference() {
      rect([ plate_size, plate_size ], rounding = 5);

      // back(hole_dist / 2) {
      //   left(hole_dist / 2) circle(d = hole_diameter);
      //   right(hole_dist / 2) circle(d = hole_diameter);
      // }
      //
      // fwd(hole_dist / 2) {
      //   left(hole_dist / 2) circle(d = hole_diameter);
      //   right(hole_dist / 2) circle(d = hole_diameter);
      // }
    }

    down(0.005) {
      back(hole_dist / 2) {
        right(hole_dist / 2) screw_hole();
        left(hole_dist / 2) screw_hole();
      }
      fwd(hole_dist / 2) {
        right(hole_dist / 2) screw_hole();
        left(hole_dist / 2) screw_hole();
      }
    }
  }
}

module screw_hole() {
  screw_hole_mask(d_screw = 4, d_screw_head = 6,
                  l_wall = plate_thickness + 0.01, l_screwdriver = 0,
                  l_countersink = 1.3, axis = UP, anchor = BOTTOM);
}

webcam_mount();
