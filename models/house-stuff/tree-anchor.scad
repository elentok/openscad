include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
// tree_diameter = 20;
// opening_height = 30;
hole_diameter = 5;
thickness = 5;
anchor_height = 40;

radius = 30;
path3d = arc(points = [
  [ radius, radius, 0 ],
  [ -radius, 0, 0 ],
  [ radius, -radius, 0 ],
]);

path2d = arc(points = [
  [ radius, radius ],
  [ -radius, 0 ],
  [ radius, -radius ],
]);

module tree_anchor() {
  // Top
  up(anchor_height / 2) stroke(path3d, width = thickness);

  // Bottom
  down(anchor_height / 2) stroke(path3d, width = thickness);

  // Between
  linear_extrude(anchor_height + nothing, center = true) stroke(path2d, width = thickness);
}

module holes() {
  rotate([ 0, 0, 65 ]) up(anchor_height / 4) hole();
  rotate([ 0, 0, -65 ]) up(anchor_height / 4) hole();
  rotate([ 0, 0, 65 ]) down(anchor_height / 4) hole();
  rotate([ 0, 0, -65 ]) down(anchor_height / 4) hole();
}

module hole() { rotate([ 0, 90, 0 ]) cylinder(d = 5, h = radius * 2.4); }

difference() {
  tree_anchor();
  holes();
}
