include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

nothing = 0.01;

edge_size = 30;
cube_size = [ edge_size, edge_size, edge_size ];
wall_thickness = 2;
pyramid_height = edge_size / 4;
rounding = edge_size / 10;

hole_diameter = edge_size / 2;
hole_height = 4;
thread_pitch = 1.5;
thread_tolerance = 0.8; // diameter-wise (includes both sides)
thread_stop_size = 2;
thread_stop_height = 1;

letter_height = edge_size * 0.7;

module dreidel() {
  difference() {

    // dreidel body
    hull() {
      cuboid(cube_size, rounding = rounding, anchor = BOTTOM);
      down(pyramid_height) sphere(d = rounding);
    }

    // space inside
    up(wall_thickness)
        cuboid(add_scalar(cube_size, -wall_thickness * 2), anchor = BOTTOM);

    // top hole thread
    up(cube_size.z - wall_thickness - nothing / 2)
        cylinder(d = hole_diameter, h = wall_thickness + nothing);

    letter_mask("נ", side = 0);
    letter_mask("ג", side = 1);
    letter_mask("ה", side = 2);
    letter_mask("פ", side = 3);
  }

  // nut
  up(cube_size.z - hole_height) hole_nut();

  // thread stops
  up(cube_size.z - thread_stop_height - hole_height) thread_stop();
}

module thread_stop() {
  d = hole_diameter + wall_thickness * 2;
  // d = hole_diameter + (cube_size.x - rounding * 2 - hole_diameter) / 2;
  linear_extrude(thread_stop_height) difference() {
    circle(d = d);
    rect([ hole_diameter - thread_stop_size * 2, d + nothing ]);
  }
}

module hole_nut() {
  difference() {
    cylinder(d = hole_diameter + wall_thickness * 2, h = hole_height);
    hole_thread(for_mask = true);
  }
}

module letter_mask(letter, side = 0) {
  angle = side * 90;

  letter_bottom = (edge_size - letter_height) / 2;

  rotate(-angle) fwd(edge_size / 2) up(letter_bottom) rotate([ 90, 0, 0 ])
      linear_extrude(wall_thickness / 2 + nothing, center = true)
          back(letter_height / 2) letter2d(letter);
}

module letter2d(letter) {
  text(letter, halign = "center", valign = "center", font = "Arial:style=Bold",
       size = letter_height);
}

module handle_thread() { hole_thread_mask(for_mask = false); }

module hole_thread(for_mask) {
  d = for_mask ? hole_diameter + thread_tolerance : hole_diameter;
  l = for_mask ? hole_height + nothing : hole_height;
  z = for_mask ? nothing / 2 : 0;
  down(z) threaded_rod(d = d, l = l, pitch = thread_pitch, internal = for_mask,
                       anchor = BOTTOM);
}

dreidel();
