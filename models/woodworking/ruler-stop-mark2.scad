//
// Ruler Stop Mark 2
//
// Uses a plastic screw instead of a metal one (so it can have a handle that's
// easier to hold).
//

include <BOSL2/metric_screws.scad>
include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;

// ruler_width = 19.6;
// ruler_height = 0.37;

// Amazon rulers
ruler_width = 15.2; // includes 0.2 tolerance
ruler_height = 0.76;

ruler_width_tolerance = 0.85;
ruler_height_tolerance = 0.1;

stop_size = [ 50, 20, 22 ];
stop_rounding = 4;

screw_diameter = 10;
screw_tolerance = 0.4;

screw1_length = stop_size.x / 2 - ruler_width / 2 + 4;
screw2_length = stop_size.y / 2 + 4;

module ruler_stop() {
  difference() {
    linear_extrude(stop_size.z, center = true) ruler_stop2d();

    rotate([ 90, 0, 0 ]) thread_mask(l = stop_size.y / 2);
    right(ruler_width / 2 - 2) rotate([ 90, 0, 90 ])
        thread_mask(l = stop_size.x / 2 - ruler_width / 2 + 2);
  }
}

module ruler_stop2d() {
  difference() {
    rect(stop_size, rounding = stop_rounding);
    rect([
      ruler_width + ruler_width_tolerance, ruler_height + ruler_height_tolerance
    ]);
  }
}

module thread_mask(l) {
  metric_bolt(size = screw_diameter, l = l, shank = 1, headtype = "none",
              anchor = BOTTOM);
}

module test_ruler_size() {
  linear_extrude(4) difference() {
    rect([ ruler_width + 5, ruler_height + 5 ], rounding = 2);
    rect([
      ruler_width + ruler_width_tolerance, ruler_height + ruler_height_tolerance
    ]);
  }
}

module screw(l) {
  // hull() {
  //   circle(d = 8);
  //   left(6) circle(d = 4);
  //   right(6) circle(d = 4);
  // }
  mirror([ 0, 0, 1 ]) metric_bolt(size = screw_diameter, coarse = true,
                                  headtype = "hex", l = l, anchor = TOP);
}

module all() {
  up(stop_size.z / 2) ruler_stop();
  left(50) screw(screw1_length);
  right(50) screw(screw2_length);
}

all();

// screw(screw1_length);
// #circle(d = 20);
// thread_mask();
// ruler_stop();
// test_ruler_size();
