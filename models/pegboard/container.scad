use <../containers/box.scad>
include <BOSL2/std.scad>
use <mount.scad>
include <variables.scad>

// Size 1 (medium)
// container_width_in_pegs = 3;
// container_height_in_pegs = 4;
// container_depth = 24;

// Size 2 (large)
// container_width_in_pegs = 5;
// container_height_in_pegs = 5;
// container_depth = 30;

// Size 3 (small)
container_width_in_pegs = 3;
container_height_in_pegs = 3;
container_depth = 24;

container_thickness = 1.5;
container_hook_tolerance = 0.1;
container_hook_protrusion = 5;
container_hook_opening_tolerance = 0.4;
container_hook_opening_z_distance = 10;

container_size = [
  container_width_in_pegs * pb_hole_spacing,
  container_depth,
  container_height_in_pegs* pb_hole_spacing,
];

echo("Container size: ", container_size);

container_mount_bar_width = pb_peg_diameter;
container_mount_thickness = container_thickness + container_hook_tolerance;
container_hook_size = [
  container_thickness,
  pb_mount_height * 0.7,
  container_mount_bar_width,
];

container_hook_opening_size = [
  container_hook_size.z + container_hook_opening_tolerance,
  container_thickness + 0.2,
  pb_mount_height + container_hook_protrusion + container_hook_opening_tolerance,
];
honeycomb_size = [
  container_size.x - container_honeycomb_padding * 2,
  container_thickness,
  container_size.z - container_honeycomb_padding * 2,
];

module container_hook() {
  mount(bar_width = container_mount_bar_width, rounding = 0, thickness = container_mount_thickness);

  y = (pb_mount_height - container_hook_size.y) / 2;
  back(y + container_hook_protrusion) left(container_hook_size.x / 2)
      cube(container_hook_size, anchor = RIGHT);
}

module container() {
  difference() {
    box(container_size, thickness = container_thickness);
    container_hook_openings();
  }
}

module container_hook_openings() {
  opening_x = pb_hole_spacing * ceil(container_width_in_pegs / 4);

  up(container_size.z - container_hook_opening_size.z / 2 - container_hook_opening_z_distance)
      back(container_size.y / 2 - container_hook_opening_size.y / 2 + 0.1) {
    right(opening_x) cube(container_hook_opening_size, center = true);
    left(opening_x) cube(container_hook_opening_size, center = true);
  }
}

// container_hook();
// back(container_size.y * 2) rotate([ 0, 0, 90 ]) container_hook();
// fwd(container_size.y * 2) rotate([ 0, 0, 90 ]) container_hook();
container();
