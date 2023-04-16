include <./variables.scad>
include <BOSL2/metric_screws.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

foot_od = 15;
foot_thread_diameter = 8; /* M6 */
foot_thread_pitch = get_metric_iso_coarse_thread_pitch(foot_thread_diameter);

// Make the bolt diameter slightly smaller than the designated M value
// e.g. M10 will be 9.8, M8 will be 7.8
foot_thread_tolerance = 0.2;

// The nut will be 0.5mm higher than the thread to make sure it goes all the
// way in.
foot_thread_height_tolerance = 0.5;

foot_extender_thread_height = 2.95;
foot_extender_nut_height = 3;
// a separation layer between the thread and the nut (same diameter as the nut)
foot_extender_middle_height = 2;

// Connects the feet to the case (attaches to the case with a )
module foot_extender() {
  // top (connects to the case)
  foot_thread();

  // middle
  cylinder(d = foot_od, h = foot_extender_middle_height, center = true);

  // bottom (connects to the foot)
  foot_nut();
}

module foot_nut() {
  h_nut = foot_extender_nut_height;
  d_nut = foot_thread_diameter + foot_thread_tolerance;

  down(h_nut / 2 + foot_extender_middle_height / 2) difference() {
    cylinder(d = foot_od, h = h_nut, center = true);
    threaded_rod(d = d_nut, l = h_nut + nothing, pitch = foot_thread_pitch,
                 internal = true);
  }
}

module foot_thread() {
  d_thread = foot_thread_diameter - foot_thread_tolerance;
  up(foot_extender_thread_height / 2 + foot_extender_middle_height / 2)
      threaded_rod(d = d_thread, l = foot_extender_thread_height,
                   pitch = foot_thread_pitch, internal = false);
}

module foot() {}

// foot();
foot_extender();
