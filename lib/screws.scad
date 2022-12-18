$fn = 64;
include <BOSL2/metric_screws.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// Make the bolt diameter slightly smaller than the designated M value
// e.g. M10 will be 9.8, M8 will be 7.8
bolt_tolerance = 0.2;

// Make the bolt hole mask diameter slightly larger than the designated M value
// e.g. M10 will be 10.4, M8 will be 8.4
bolt_hole_tolerance = 0.4;

function get_thread_pitch(size, coarse = true) =
    coarse ? get_metric_iso_coarse_thread_pitch(size)
           : get_metric_iso_fine_thread_pitch(size);

function get_head_height(size, head_l) = head_l == undef
                                             ? get_metric_nut_thickness(size)
                                             : head_l;

module assert_valid_size(size) {
  assert(round(size) == size,
         "Bolt size must be a valid integer (M4, M5, ...)");
}

module bolt(size, l, head_l, anchor, coarse = true, head_anchor = BOTTOM) {
  assert_valid_size(size);
  pitch = get_thread_pitch(size, coarse);
  HEAD_L = get_head_height(size, head_l);

  d = size - bolt_tolerance;
  echo(str("Bolt M", size, " actual diameter: ", d, "mm"));

  threaded_rod(d = d, l = l + HEAD_L, pitch = pitch, internal = true,
               anchor = anchor) {
    position(head_anchor) bolt_head(size, l = HEAD_L, anchor = head_anchor);
  };
}

module bolt_head(size, l, d, anchor, spin, orient) {
  D = d == undef ? get_metric_nut_size(size) / cos(30) : d;
  L = get_head_height(size, l);

  attachable(anchor, spin, orient, d = D, l = L) {
    linear_extrude(height = L, center = true) hexagon(d = D, rounding = 2);
    children();
  }
}

module bolt_hole(size, l, anchor, coarse = true, shank = 1,
                 shank_anchor = TOP) {
  assert_valid_size(size);
  pitch = get_thread_pitch(size, coarse);
  d = size + bolt_hole_tolerance;

  echo(str("Bolt hole for M", size, " actual diameter: ", d, "mm"));
  echo(str("Bolt hole for M", size, " pitch: ", pitch));

  threaded_rod(d = d, l = l + shank, pitch = pitch, internal = true,
               anchor = anchor) {
    position(shank_anchor) cylinder(d = size + bolt_hole_tolerance, h = shank,
                                    anchor = shank_anchor);
  };
}

module nut(size, l, d, coarse = true, anchor, spin, orient) {
  assert_valid_size(size);
  pitch = get_thread_pitch(size, coarse);
  D = d == undef ? get_metric_nut_size(size) / cos(30) : d;
  L = l == undef ? get_metric_nut_thickness(size) : l;

  attachable(anchor, spin, orient, d = D, l = L) {
    difference() {
      bolt_head(size, d = D);
      bolt_hole(size, L + 0.01, coarse = coarse);
    }

    children();
  }
}

// xdistribute(spacing = 30) {
//   bolt(size = 10, l = 10, anchor = BOTTOM);
//   nut(size = 10, anchor = BOTTOM);
// }

// bolt_head(size = 10, anchor = BOTTOM);
// bolt_hole(size = 10, l = 20, anchor = BOTTOM);
// nut(size = 10, l = 5);

// metric_bolt(size = 10, l = 8, headtype = "hex", orient = DOWN);
//

nut(size = 12, d = 35);
