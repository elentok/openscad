include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.01;
jar_outer_diameter = 40;  // 100;
jar_height = 20;          // 30;
wall_thickness = 2;
thread_max_size = 2.5;
jar_wall_thickness = wall_thickness + thread_max_size;
jar_inner_diameter = jar_outer_diameter - jar_wall_thickness * 2;
// inner_diameter = jar_outer_diameter - jar_wall_thickness * 2;
// inner_diameter = jar_outer_diameter - wall_thickness * 2;
thread_guide_height = 1;
space_below_thread = 3;
thread_height = 12;
jar_thread_minor_patch_major =
    add_scalar([ 0, thread_max_size / 2, thread_max_size ],
               jar_inner_diameter + wall_thickness - epsilon);
thread_pitch = 4;
thread_tolerance = 0.6;
lid_thread_minor_patch_major =
    add_scalar(jar_thread_minor_patch_major, thread_tolerance);
felt_thickness = 2;
rounding = 3;
// lid_height =
//     wall_thickness + thread_height + rounding / 2 + thread_guide_height;
lid_height = wall_thickness + thread_height + felt_thickness + rounding / 2;
jar_base_height = jar_height - thread_height;

echo("Lid height", lid_height);

lid_inner_diameter = jar_outer_diameter -
                     wall_thickness * 2;  // lid_thread_minor_patch_major[2];
lid_outer_diameter =
    jar_outer_diameter;  // lid_inner_diameter + wall_thickness * 2;

module jar() {
  rounded_container(od = jar_outer_diameter,
                    wall_thickness = jar_wall_thickness, h = jar_base_height,
                    rounding = rounding);
  up(jar_base_height - epsilon)
      tube(id = jar_inner_diameter, od = jar_inner_diameter + wall_thickness,
           h = thread_height, anchor = BOTTOM);
  jar_thread();
}

module jar_thread(anchor = CENTER) {
  up(jar_height - thread_height / 2) difference() {
    threaded_rod(d = jar_thread_minor_patch_major, l = thread_height,
                 end_len2 = thread_guide_height, end_len1 = space_below_thread,
                 pitch = thread_pitch, internal = false);
    // up(height - thread_height / 2 - thread_guide_height) difference() {
    //   threaded_rod(d = jar_thread_minor_patch_major, l = thread_height,
    //                pitch = thread_pitch, internal = false);

    cylinder(d = jar_inner_diameter + wall_thickness,
             h = thread_height + epsilon, center = true);
  }
}

module lid() {
  up(lid_height) mirror([ 0, 0, 1 ]) rounded_container(
      od = lid_outer_diameter, wall_thickness = wall_thickness, h = lid_height,
      rounding = rounding);

  up(thread_guide_height) difference() {
    cylinder(d = lid_inner_diameter + epsilon, h = thread_height);
    down(epsilon / 2) threaded_rod(
        d = lid_thread_minor_patch_major, l = thread_height + epsilon,
        end_len2 = thread_guide_height, end_len1 = space_below_thread,
        pitch = thread_pitch, internal = true, anchor = BOTTOM);
  }
}

module rounded_container(od, wall_thickness, h, rounding) {
  id = od - wall_thickness * 2;
  rotate_extrude() difference() {
    rect([ od / 2, h ], anchor = LEFT + FWD, rounding = [ 0, 0, 0, rounding ]);
    back(wall_thickness + epsilon)
        rect([ id / 2, h - wall_thickness ], anchor = LEFT + FWD,
             rounding = [ 0, 0, 0, rounding ]);
  }
}

module demo(spacing) {
  jar();
  % up(jar_height + spacing) lid();
}

module print() {
  jar();
  left(lid_outer_diameter * 1.5) lid();
}

module threading_test() {
  down(jar_base_height - 1) intersection() {
    jar();
    up(jar_base_height - 1) cylinder(d = jar_outer_diameter + epsilon,
                                     h = thread_height + 1 + epsilon);
  }

  left(lid_outer_diameter * 1.5) intersection() {
    lid();
    cylinder(d = lid_outer_diameter + epsilon, h = thread_height + epsilon);
  }
}

// rounded_container(od = 120, wall_thickness = 2, h = 30, rounding = 2);
// jar();
// lid();
// demo(spacing = -8);
demo(spacing = 10);
// print();
// threading_test();
