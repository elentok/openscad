include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
magnet_od = 15;
magnet_h = 2.7;
screw_hole_od = 3.5;
screw_hole_h = 8.5;
thickness = 20;
// The space between the lip and the edge
lip_spacing = 10;
lip_size = [ 20, 30 ];

lip_connector_size = [ 8, 15, 7 ];

// These values include a lot of tolerance
lip_screw_diameter = 4.2;
lip_screw_head_diameter = 9.5;
lip_screw_head_height = 4;
lip_screw_support_size = 3;

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

echo("Size:", guide_size);

module saw_guide() {
  diff() {
    saw_guide_body();
    positioned_lip();
    // tag("remove") finger_protector();
    tag("remove") down(nothing) magnet_mask();
    tag("remove") down(nothing) left(magnet_od + spacing) magnet_mask();
    tag("remove") down(nothing) right(magnet_od + spacing) magnet_mask();
  }
}

module saw_guide_body() {
  r = rounding;
  linear_extrude(guide_size.z) rect(guide_size, rounding = r) {
    // Lip
    // right(lip_spacing) position(LEFT + FRONT)
    //     rect(lip_size, rounding = [ 0, 0, r, r ], anchor = LEFT + BACK);
  }
}

module positioned_lip() {
  fwd(guide_size.y / 2) left(guide_size.x / 2 - lip_spacing) lip();
}

module lip() {
  r = rounding;
  difference() {
    linear_extrude(guide_size.z)
        rect(lip_size, rounding = [ 0, 0, r, r ], anchor = BACK + LEFT);

    connector_offset = [
      lip_size.x / 2,
      -lip_size.y / 2,
      thickness - lip_connector_size.z + nothing,
    ];

    translate(connector_offset) linear_extrude(lip_connector_size.z)
        rect(lip_connector_size);

    right(lip_size.x / 2) fwd(lip_size.y / 2) lip_screw_mask();
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
  cylinder(d = magnet_od, h = magnet_h);
  up(magnet_h - nothing) cylinder(d = screw_hole_od, h = screw_hole_h);
}

module lip_screw_mask() {
  h = thickness - lip_connector_size.z - lip_screw_support_size;
  down(nothing) cylinder(d = lip_screw_diameter, h = h);
  down(nothing) cylinder(d = lip_screw_head_diameter,
                         h = lip_screw_head_height + nothing);
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

// lip_screw_mask();
// lip();
saw_guide();
// single_magnet_holder();
// magnet_mask();
