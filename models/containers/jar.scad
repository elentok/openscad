include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.01;
jar_outer_diameter = 100;
wall_thickness = 2;
inner_diameter = jar_outer_diameter - wall_thickness * 2;
height = 30;
thread_guide_height = 1;
thread_height = 12;
thread_minor_patch_major =
    add_scalar([ 0, 1.5, 3 ], jar_outer_diameter - epsilon);
thread_pitch = 4;
felt_thickness = 2;
lid_height =
    wall_thickness + thread_height + thread_guide_height + felt_thickness;
// lid_outer_diameter = thread_outer_diameter

echo("Lid height", lid_height);

// thread_outer_diameter = jar_outer_diameter + thread_pitch + 2;
thread_outer_diameter = thread_minor_patch_major[0];

module jar() {
  cylinder(d = jar_outer_diameter, h = wall_thickness);
  tube(od = jar_outer_diameter, id = inner_diameter, h = height,
       anchor = BOTTOM);
  jar_thread();
}

module jar_thread(anchor = CENTER) {
  up(height - thread_height / 2 - thread_guide_height) difference() {
    threaded_rod(d = thread_minor_patch_major, l = thread_height,
                 pitch = thread_pitch, internal = false);

    cylinder(d = jar_outer_diameter, h = thread_height + epsilon,
             center = true);
  }
}

module lid() {}

jar();
// lid
