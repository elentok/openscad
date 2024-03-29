use <../containers/box.scad>
include <BOSL2/std.scad>
use <mount.scad>
include <variables.scad>

// Defaults:
container_has_bottom = true;
container_y_cells = 1;
container_x_cells = 1;

// Variation 1 (large)
// container_width_in_pegs = 5;
// container_height_in_pegs = 5;
// container_depth = 30;
//
// Variation 2 (medium)
// container_width_in_pegs = 3;
// container_height_in_pegs = 4;
// container_depth = 24;

// Variation 3 (small)
// container_width_in_pegs = 3;
// container_height_in_pegs = 3;
// container_depth = 15;

// Variation 4 (small without bottom)
// container_width_in_pegs = 2;
// container_height_in_pegs = 2;
// container_depth = 15;
// container_has_bottom = false;

// Variation 5 (XL)
// container_width_in_pegs = 5;
// container_height_in_pegs = 5;
// container_depth = 40;
// container_y_cells = 2;

// Variation 6 (Thin)
container_width_in_pegs = 2;
container_height_in_pegs = 5;
container_depth = 40;

container_thickness = 1.5;
container_hook_tolerance = 0;
container_hook_protrusion = 5;
container_hook_opening_tolerance = 0.1;
container_hook_opening_z_distance = 10;

function calc_container_size(width_in_pegs, depth, height_in_pegs) = [
  container_width_in_pegs * pb_hole_spacing,
  container_depth,
  container_height_in_pegs* pb_hole_spacing,
];

container_size =
    calc_container_size(container_width_in_pegs, container_depth, container_height_in_pegs);

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

module container_hook() {
  mount(bar_width = container_mount_bar_width, rounding = 0, thickness = container_mount_thickness);

  y = (pb_mount_height - container_hook_size.y) / 2;
  back(y + container_hook_protrusion) left(container_hook_size.x / 2)
      cube(container_hook_size, anchor = RIGHT);
}

module container(size = container_size, thickness = container_thickness,
                 has_bottom = container_has_bottom, x_cells = container_x_cells) {
  difference() {
    box(size, thickness = thickness, has_bottom = has_bottom);
    container_hook_openings();
  }

  if (container_x_cells > 1) {
    x_separators();
  }

  if (container_y_cells > 1) {
    y_separators();
  }
}

module x_separators() {
  cell_width = container_size.x / container_x_cells;
  for (i = [2:container_x_cells]) {
    x = (i - 1) * cell_width;

    up(container_size.z / 2)
        cube([ container_thickness, container_size.y, container_size.z ], center = true);
  }
}

module y_separators() {
  cell_y_size = container_size.y / container_y_cells;
  for (i = [2:container_y_cells]) {
    y = (i - 1) * cell_y_size;

    up(container_size.z / 2)
        cube([ container_size.x, container_thickness, container_size.z ], center = true);
  }
}

module container_hook_openings() {
  opening_x = container_width_in_pegs == 2 ? pb_hole_spacing / 2
                                           : pb_hole_spacing * ceil(container_width_in_pegs / 4);

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
