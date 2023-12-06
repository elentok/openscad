include <BOSL2/std.scad>
$fn = 64;

angle = 7;

module left_side() {
  back(32.7) right(27.8) up(39.5) rotate([ 180 + angle, 0, 0 ])
      import("original/Keebio_Iris_left_wrist_rest.stl");
}

module right_side() {
  back(32.7) left(277.8) up(39.5) rotate([ 180 + angle, 0, 0 ])
      import("original/Keebio_Iris_right_wrist_rest.stl");
}

right_side();
// left_side();
