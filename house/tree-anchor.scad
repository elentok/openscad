include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
// tree_diameter = 20;
// opening_height = 30;
hole_diameter = 5;
thickness = 5;
anchor_height = 40;

anchor_inner_radius = 25;
anchor_mid_radius = anchor_inner_radius + thickness / 2;
anchor_outer_radius = anchor_inner_radius + thickness;
anchor_angle = 140;

loop_thickness = 2;
loop_id = hole_diameter + thickness;
loop_od = loop_id + loop_thickness * 2;
loop_width = thickness / 2 + hole_diameter + loop_thickness;
wire_hole_size = [ 5, 8 ];
wire_hole_rounding = 2;

function open_circle_arc_x(r, angle) = r * cos(angle / 2);
function open_circle_arc_y(r, angle) = r * sin(angle / 2);
function open_circle_arc_points(r, angle) = [
  [ open_circle_arc_x(r, angle), open_circle_arc_y(r, angle) ],
  [ -r, 0 ],
  [ open_circle_arc_x(r, angle), -open_circle_arc_y(r, angle) ],
];
function open_circle_arc2d(r, angle) = arc(points = open_circle_arc_points(r, angle));
function open_circle_arc3d(r, angle) = arc(points = path3d(open_circle_arc_points(r, angle)));
module open_circle2d(ir, angle, thickness) {
  path = open_circle_arc2d(ir + thickness / 2, angle);
  stroke(path, width = thickness);
}
module open_circle3d(ir, angle, thickness) {
  path = open_circle_arc3d(ir + thickness / 2, angle);
  stroke(path, width = thickness);
}
module open_circle_tube(ir, angle, thickness, h) {
  up(h / 2 - thickness / 2) open_circle3d(ir, angle, thickness);
  down(h / 2 - thickness / 2) open_circle3d(ir, angle, thickness);
  linear_extrude(h - thickness + nothing, center = true) open_circle2d(ir, angle, thickness);
}

anchor_path2d = open_circle_arc2d(anchor_mid_radius, anchor_angle);

echo("Opening height: ", open_circle_arc_y(anchor_mid_radius, anchor_angle) * 2);

module tree_anchor() {
  open_circle_tube(anchor_inner_radius, anchor_angle, thickness, anchor_height);
  // arc_tube(anchor_path2d, anchor_height, thickness); }
}

module arc_tube(arc_path2d, h, thickness) {
  arc_path3d = path3d(arc_path2d);

  // Top
  up(h / 2) open_circle3d() stroke(arc_path3d, width = thickness);

  // Bottom
  down(h / 2) stroke(arc_path3d, width = thickness);

  // Between
  linear_extrude(h + nothing, center = true) stroke(arc_path2d, width = thickness);
}

module wire_loop1() {
  left(anchor_mid_radius) rotate([ 90, 0, 0 ]) linear_extrude(loop_thickness, center = true)
      difference() {
    circle(d = loop_od);
    circle(d = loop_id);
    rect([ loop_od / 2, loop_od ], anchor = LEFT);
  }
}

module wire_loop() {
  left(anchor_mid_radius + loop_width / 2) rotate([ 90, 0, 0 ]) linear_extrude(loop_thickness)
      wire_loop2d();
}

module wire_loop2d() {
  difference() {
    r = thickness / 2;
    rect([ loop_width, anchor_height ], rounding = [ 0, r, r, 0 ]);

    y = anchor_height / 4;

    wr = wire_hole_rounding;
    back(y) rect(wire_hole_size, rounding = [ 0, wr, wr, 0 ]);
    fwd(y) rect(wire_hole_size, rounding = [ 0, wr, wr, 0 ]);
  }
}

module wire_loops() {
  rotate([ 0, 0, 45 ]) wire_loop();
  rotate([ 0, 0, -45 ]) wire_loop();
  // up(loop_od / 2) wire_loop();
  // down(loop_od / 2) wire_loop();
}

module holes() {
  angle = anchor_angle / 2 + 15;
  rotate([ 0, 0, angle ]) up(anchor_height / 4) hole();
  rotate([ 0, 0, -angle ]) up(anchor_height / 4) hole();
  rotate([ 0, 0, angle ]) down(anchor_height / 4) hole();
  rotate([ 0, 0, -angle ]) down(anchor_height / 4) hole();
}

module hole() { rotate([ 0, 90, 0 ]) cylinder(d = 5, h = anchor_outer_radius * 2.4); }

tree_anchor();
wire_loops();
