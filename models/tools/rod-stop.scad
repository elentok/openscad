include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

// ============================================================
// Variables

// When cutting object A from object B, object A must be slightly larger,
// otherwise there are leftover edges.
epsilon = 0.01;

inner_diameter = 16.1;  // the hole's diameter
threads_diameter_top = 26;
threads_diameter_bottom = 30;
grip_threads_height = 30;
grip_base_height = 10;
grip_height = grip_threads_height + grip_base_height;
pitch = 6;

nut_diameter = 40;
nut_height = 14;
grip_pie_slice_angle = 30;

// ============================================================
// Shared modules

// The screw (used for the grip and for the nut).
module grip_screw(end_len1 = 0, internal = false, anchor = BOTTOM) {
  threaded_rod(d1 = threads_diameter_bottom, d2 = threads_diameter_top,
               end_len1 = end_len1, l = grip_threads_height, pitch = pitch,
               anchor = anchor, internal = internal);
}

// ============================================================
// Grip (the part that wraps around the rod)

module grip() {
  difference() {
    // The solid grip (handle + screw).
    union() {
      up(grip_base_height - epsilon) grip_screw(end_len1 = pitch * 0.75);
      grip_handle();
    }

    // Remove an internal cylinder to make space for the rod.
    down(epsilon / 2)
        cyl(d = inner_diameter, h = grip_height + epsilon, anchor = BOTTOM);

    // Remove a pie slice to make it easier to wrap around the rod and to make
    // it possible to clamp when screwing the nut.
    down(epsilon / 2) linear_extrude(grip_height + epsilon) grip_pie_slice_2d();
  }
}

module grip_handle() {
  linear_extrude(grip_base_height, convexity = 4) round2d(r = 5) difference() {
    hexagon(d = nut_diameter);
    grip_pie_slice_2d();
  }
}

module grip_pie_slice_2d() {
  arc(d = nut_diameter, angle = grip_pie_slice_angle,
      spin = grip_pie_slice_angle / 2, wedge = true);
}

// ============================================================
// Nut

module nut(anchor) {
  attachable(d = nut_diameter, h = nut_height, anchor) {
    difference() {
      linear_extrude(nut_height, convexity = 4, center = true) round2d(r = 5)
          hexagon(d = nut_diameter);
      grip_screw(anchor = CENTER, internal = true);
    }
    children();
  }
}

// ============================================================
// Demo

module demo() {
  grip();
  up(grip_height + 10) nut(anchor = BOTTOM);
}

// To generate STLs to print comment the call to "demo" and then uncomment one
// of the following each time and export it to STL:
//
// nut();
// grip();
demo();
