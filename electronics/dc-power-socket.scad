include <BOSL2/std.scad>
use <../../lib/jar.scad>
$fn = 64;

// # The first layer expands a bit, these values account for that.
lid_hole_diameter = 11.6 + 0.5;
lid_hole_width = 10.8 + 0.3;
body_hole_diameter = 5;

jar_props = create_jar_props([
  "od",
  30,
  "jar_height",
  30,
  "lid_height",
  9,
  "jar_thread_height",
  6,
  "thread_pitch",
  2,
  "jar_wall",
  1.7,
  "thread_wall",
  1,
  "jar_rounding",
  1,
]);

module dc_power_socket_body() {
  difference() {
    jar_body(jar_props);
    down(0.01) cyl(d = body_hole_diameter, h = jar_wall(jar_props) + 0.03,
                   anchor = BOTTOM);
  }
}
module dc_power_socket_lid() {
  difference() {
    jar_lid(jar_props);
    down(jar_wall(jar_props)) linear_extrude(jar_wall(jar_props) + 0.02)
        intersection() {
      circle(d = lid_hole_diameter);
      rect([ lid_hole_diameter, lid_hole_width ]);
    }
  }
}

// dc_power_socket_body();
dc_power_socket_lid();
// up(50) dc_power_socket_lid();
