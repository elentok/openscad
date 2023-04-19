include <./variables.scad>
include <BOSL2/metric_screws.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// Connects the feet to the case (attaches to the case with a )
module foot_extender() {
  // top (connects to the case)
  up(foot_extender_thread_height / 2 + foot_extender_middle_height / 2)
      foot_thread();

  // middle
  cylinder(d = foot_od, h = foot_extender_middle_height, center = true);

  // bottom (connects to the foot)
  down(foot_extender_nut_height / 2 + foot_extender_middle_height / 2)
      foot_nut();
}

module foot_nut() {
  h_nut = foot_extender_nut_height;

  difference() {
    cylinder(d = foot_od, h = foot_extender_nut_height, center = true);
    foot_thread_mask(h = foot_extender_nut_height + nothing);
  }
}

module foot_thread_mask(h, anchor) {
  d_nut = foot_thread_diameter + foot_thread_tolerance;
  threaded_rod(d = d_nut, l = h, pitch = foot_thread_pitch, internal = true,
               anchor = anchor);
}

module foot_thread(h = foot_extender_thread_height) {
  d_thread = foot_thread_diameter - foot_thread_tolerance;
  threaded_rod(d = d_thread, l = h, pitch = foot_thread_pitch,
               internal = false);
}

module foot_extender_bottom() {
  difference() {
    bottom_half() { sphere(d = foot_od); }
    down(foot_extender_thread_height / 2)
        foot_thread_mask(foot_extender_thread_height + 1);
  }
}

module foot() {
  difference() {
    base_foot();

    up(nothing / 2) {
      cylinder(d = foot_screw_hole_diameter, h = foot_diameter + nothing,
               anchor = TOP);

      down(foot_screw_meat_thickness + nothing)
          foot_thread_mask(h = foot_thread_height, anchor = TOP);
    }
  }
}

module base_foot(anchor = TOP) {
  attachable(d = foot_diameter, l = foot_height, anchor) {
    rotate_extrude() base_foot_2d();
    children();
  }
}

module base_foot_2d() {
  rect([ foot_diameter / 2, foot_height ], rounding = [ 0, 0, 0, foot_radius ],
       anchor = LEFT);
}

// Connects the foot and the foot extender (or directly to the case)
module foot_screw() { foot_thread(h = foot_extender_thread_height * 2 - 1); }

// base_foot_2d();
// base_foot();
foot();

// foot_screw();
// foot_extender();
// foot_extender_bottom();
