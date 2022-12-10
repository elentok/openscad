include <BOSL2/std.scad>
use <../../lib/bottom_screw_head_mask.scad>
$fn = 64;

nothing = 0.01;
magnet_od = 15;
magnet_h = 3.2;
screw_hole_od = 3.5;
screw_hole_h = 8.5;
thickness = 20;
// The space between the lip and the edge
lip_spacing = 25;
lip_size = [ 20, 15, 60 ];

assert(thickness > magnet_h + screw_hole_h + 2);

// The space between each magnet
spacing = 15;

// The padding between the magnets and the edges of the guide
padding = 10;

// The amount of magnets
magnets = 3;

rounding = 3;

finger_protector_height = 5;

// [padding][magnet_od][spacing][magnet_od][spacing][magnet_od][padding]

guide_size = [
  padding * 2 + magnet_od * magnets + spacing * (magnets - 1),
  padding * 2 + magnet_od,
  thickness,
];

triangle_support_thickness = 30;
triangle_support_width = guide_size.x - lip_spacing * 2;

echo("Size:", guide_size);

module saw_guide() {
  diff() {
    saw_guide_body();
    positioned_lip();
    triangle_support();
    // tag("remove") finger_protector();
    tag("remove") down(nothing) magnet_mask();
    tag("remove") down(nothing) left(magnet_od + spacing) magnet_mask();
    tag("remove") down(nothing) right(magnet_od + spacing) magnet_mask();
  }
}

module triangle_support() {
  fwd(guide_size.y / 2) up(guide_size.z - nothing) rotate([ 0, -90, 0 ])
      linear_extrude(triangle_support_width, center = true)
          right_triangle([ triangle_support_thickness, guide_size.y / 2 ]);
}

module saw_guide_body() {
  r = rounding;
  linear_extrude(guide_size.z) rect(guide_size, rounding = r);
}

module positioned_lip() {
  fwd(guide_size.y / 2) left(guide_size.x / 2 - lip_spacing) lip();
}

module lip() {
  r = rounding;
  difference() {
    linear_extrude(lip_size.z)
        rect(lip_size, rounding = [ 0, 0, r, r ], anchor = BACK + LEFT);
  }
}

module finger_protector() {
  size = [
    guide_size.x * 0.4,
    finger_protector_height * 2,
    guide_size.z,
  ];
  back(guide_size.y / 2) up(finger_protector_height)
      cuboid(size, rounding = rounding, anchor = BOTTOM);
}

module magnet_mask() {
  bottom_screw_head_mask(head_diameter = magnet_od, head_height = magnet_h,
                         screw_diameter = screw_hole_od, support_height = 0.25);
  up(magnet_h - nothing) cylinder(d = screw_hole_od, h = screw_hole_h);
}

// for test prints
module single_magnet_holder() {
  od = magnet_od + 4;
  h = magnet_h + screw_hole_h + 2;
  difference() {
    cylinder(d = od, h = h);
    down(nothing) magnet_mask();
  }
}

// triangle_support();

saw_guide();
// single_magnet_holder();
// magnet_mask();
