$fn=50;

use <rounded.scad>

module grip(grip_depth, bottom_wall_width = 3, wall_width = 1.3) {
  rounded_edge(grip_depth, 30, bottom_wall_width, 1.5);
}

grip(grip_depth = 15);