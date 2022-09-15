$fn = 60;
include <BOSL2/std.scad>

notepad_size = [ 62.7, 102, 4 ];
notepad_top_length = 13;
notepad_tolerance = 0.3;
thickness = 2;
rounding = 2;
keychain_hole_diameter = 5;
keychain_hole_margin = 3;
thumb_diameter = 20;
pen_diameter = 7.3;
pen_holder_thickness = 0.7;
pen_holder_length = 30;

container_size = [
  notepad_size.x + thickness,
  notepad_size.y + thickness,
  notepad_size.z + thickness,
];

module container() {
  // outer box
  linear_extrude(container_size.z) rect([ container_size.x, container_size.y ], rounding = 2);
}

module notepad_mask() {
  top_size = [
    notepad_size.x,
    notepad_top_length,
    notepad_size.z + 0.1,
  ];

  bottom_size = [
    notepad_size.x + notepad_tolerance,
    notepad_size.y + notepad_tolerance - notepad_top_length,
    notepad_size.z + 0.1,
  ];

  y = -top_size.y + (bottom_size.y + top_size.y) / 2;
  up(thickness) fwd(y) union() {
    cube(top_size, anchor = BOTTOM + BACK);
    cube(bottom_size, anchor = BOTTOM + FWD);
  }
}

module keychain_hole() {
  x = (notepad_size.x - keychain_hole_diameter) / 2 - keychain_hole_margin;
  y = (notepad_size.y - keychain_hole_diameter) / 2 - keychain_hole_margin;
  translate([ -x, -y, -0.1 ]) cylinder(d = keychain_hole_diameter, h = thickness + 0.2);
}

module notepad_top() { up(thickness) cube(notepad_size, anchor = BOTTOM); }

module thumb_mask() {
  y = (notepad_size.y) / 2;
  translate([ 0, y, -0.1 ]) linear_extrude(container_size.z + 0.2) circle(d = thumb_diameter);
}

module pen_holder() {
  outer_diameter = pen_diameter + pen_holder_thickness * 2;

  x = -container_size.x / 2 - outer_diameter / 2;
  y = -pen_holder_length / 2;
  z = outer_diameter / 2;
  translate([ x, y, z ]) rotate([ -90, 0, 0 ]) linear_extrude(pen_holder_length) union() {
    shell2d(pen_holder_thickness) circle(d = pen_diameter);
    difference() {
      square([ outer_diameter / 2, outer_diameter / 2 ]);
      circle(d = outer_diameter);
    }
  }
}

module notepad_case() {
  difference() {
    container();
    notepad_mask();
    keychain_hole();
    thumb_mask();
  }

  pen_holder();
}

notepad_case();
