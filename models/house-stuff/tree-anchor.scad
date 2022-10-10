include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
// tree_diameter = 20;
// opening_height = 30;
hole_diameter = 5;
thickness = 5;
anchor_height = 40;

inner_radius = 25;
mid_radius = inner_radius + thickness / 2;
outer_radius = inner_radius + thickness;
opening_angle = 140;
y = mid_radius * sin(opening_angle / 2);
x = mid_radius * cos(opening_angle / 2);

echo("Opening height: ", x * 2);

path3d = arc(points = [
  [ x, y, 0 ],
  [ -mid_radius, 0, 0 ],
  [ x, -y, 0 ],
]);

path2d = arc(points = [
  [ x, y ],
  [ -mid_radius, 0 ],
  [ x, -y ],
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
  angle = opening_angle / 2 + 15;
  rotate([ 0, 0, angle ]) up(anchor_height / 4) hole();
  rotate([ 0, 0, -angle ]) up(anchor_height / 4) hole();
  rotate([ 0, 0, angle ]) down(anchor_height / 4) hole();
  rotate([ 0, 0, -angle ]) down(anchor_height / 4) hole();
}

module hole() { rotate([ 0, 90, 0 ]) cylinder(d = 5, h = outer_radius * 2.4); }

difference() {
  tree_anchor();
  holes();
}
// stroke(path3d, width = thickness);
