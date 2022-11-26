// The bottom_screw_head_mask() module includes pseudo-supports so it can
// printed without actual supports.

include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;

module bottom_screw_head_mask(head_diameter, head_height, screw_diameter,
                              support_height) {

  // Screw head
  down(nothing) cylinder(d = head_diameter, h = head_height + nothing);

  // Support layer 1
  up(head_height) linear_extrude(support_height) intersection() {
    circle(d = head_diameter);
    rect([ head_diameter, screw_diameter ]);
  }

  // Support layer 2
  up(head_height + support_height) linear_extrude(support_height)
      intersection() {
    circle(d = head_diameter);
    rect([ screw_diameter, screw_diameter ]);
  }
}

test_mask();

// bottom_screw_head_mask(head_diameter = 20, head_height = 4, screw_diameter =
// 4,
//                        support_height = 0.25);
