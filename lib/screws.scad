$fn = 64;
include <BOSL2/metric_screws.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

bolt_hole_tolerance = 0.4;

module assert_valid_size(size) {
  assert(round(size) == size,
         "Bolt size must be a valid integer (M4, M5, ...)");
}

module bolt_hole(size, l, anchor, coarse = true, shank = 1,
                 shank_anchor = TOP) {
  assert_valid_size(size);
  pitch = get_metric_iso_coarse_thread_pitch(size);

  threaded_rod(d = size + bolt_hole_tolerance, l = l + shank, pitch = pitch,
               internal = true, anchor = anchor) {
    position(shank_anchor) cylinder(d = size + bolt_hole_tolerance, h = shank,
                                    anchor = shank_anchor);
  };
}

module nut(size, l, coarse = true) {
  assert_valid_size(size);
  pitch = get_metric_iso_coarse_thread_pitch(size);
  l = get_metric_nut_thickness(size);

  difference() {
    metric_nut(size = size, hole = false);
    bolt_hole(size, l + 0.01, coarse = coarse);
  }
}

// bolt_hole(size = 10, l = 20, anchor = BOTTOM);
// nut(size = 10, l = 5);
metric_bolt(size = 10, l = 8, headtype = "hex", orient = DOWN);
