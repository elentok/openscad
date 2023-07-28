include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

// When cutting object A from object B, object A must be slightly larger,
// otherwise there are leftover edges.
epsilon = 0.01;

// inner_diameter = 25;  // the hole's diameter
inner_diameter = 16.1;         // the hole's diameter
threads_diameter_top = 26;     // 40;
threads_diameter_bottom = 30;  // 44;
threads_height = 30;
pitch = 6;

nut_diameter = 54;  // 74;
nut_height = 14;    // 20;
grip_angle = 30;

// // Diameters:
// inner_diameter = 25;  // the hole's diameter
// threads_diameter = 30;
// disc_diameter = 65;
//
// // Heights
// disc_height = 25;
// threadless_height = 30;
// threads_height = 50;
// total_height = disc_height + threadless_height + threads_height;
//
// // Threading:
// pitch = 8;
// nut_tolerance = 0.02;  // increase this value of the nut is too tight
// nut_width = disc_diameter;
// nut_height = 25;

module grip() {
  difference() {
    grip_threads();
    cyl(d = inner_diameter, h = threads_height + epsilon);
  }
}

module grip_threads() {
  threaded_rod(d1 = threads_diameter_bottom, d2 = threads_diameter_top,
               l = threads_height, pitch = pitch);
}

module nut() {
  difference() {
    linear_extrude(nut_height, convexity = 4, center = true) round2d(r = 5)
        star(n = 5, od = nut_diameter, id = nut_diameter * 0.6);

    grip_threads();
  }
}

module grip_left() { left_half() grip(); }
module grip_right() { right_half() grip(); }

module cut_grip() {
  difference() {
    grip();
    pie_slice(h = threads_height + epsilon, d = threads_diameter_bottom,
              ang = grip_angle, center = true);
  }
}

cut_grip();
// left(2) grip_left();
// right(2) grip_right();
up(threads_height + 10) nut();

// nut();
// grip();
// grip_left();
// grip_right();
