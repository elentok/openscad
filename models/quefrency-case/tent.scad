use <./screws.scad>
include <./variables.scad>
include <BOSL2/std.scad>

tent_side = RIGHT;

// Calculate tent kb y length (Pythagorean theorem)
a1 = tent_height_kb_front - tent_height_kb_back;
c1 = case_size_y;
b1 = sqrt(c1 * c1 - a1 * a1);
tent_kb_y = b1;
tent_kb_z_diff = tent_height_kb_front - tent_height_kb_back;
tent_kb_angle = asin(tent_kb_z_diff / case_size_y);

// Calculate wrist rest y length (Pythagorean theorem)
a2 = tent_height_wrist_rest_back - tent_height_wrist_rest_front;
c2 = wrist_rest_size.y;
b2 = sqrt(c2 * c2 - a2 * a2);
tent_wrist_rest_y = b2;
tent_wrist_rest_z_diff = tent_height_wrist_rest_back - tent_height_wrist_rest_front;
tent_wrist_rest_angle = asin(tent_wrist_rest_z_diff / wrist_rest_size.y);

echo("Tent KB Angle:", tent_kb_angle);
echo("Tent Wrist Rest Angle:", tent_wrist_rest_angle);

tent_size_y = tent_kb_y + tent_wrist_rest_y;
tent_max_height = tent_height_wrist_rest_back;

tent_rounding = tent_thickness / 2;

module tent() {
  difference() {
    rotate([ 90, 0, 0 ]) linear_extrude(tent_size_y) tent2d();

    tent_positioned_kb_mask();
    tent_positioned_wrist_rest_mask();
  }
}

module tent2d() {
  t = tent_thickness;
  r = 2;

  rounding = [ r, r, r, t / 2 ];

  rect([ t, tent_max_height ], anchor = FWD, rounding = rounding);
}

module tent_positioned_kb_mask() {
  rotate([ -tent_kb_angle, 0, 0 ]) up(tent_height_kb_back) tent_kb_mask();
}

module tent_positioned_wrist_rest_mask() {
  rotate([ tent_wrist_rest_angle, 0, 0 ]) up(tent_height_wrist_rest_back) fwd(case_size_y)
      tent_wrist_rest_mask();
}

module tent_kb_mask() {
  cube([ tent_thickness + nothing, case_size_y, case_height * 2 ], anchor = BACK + BOTTOM) {
    // cut a small part to make space for the front screw
    up(nothing) back(5.3) left(tent_thickness / 2) position(FWD + BOTTOM)
        cylinder(d = 7, h = tent_max_height, anchor = TOP);

    // cut the end to make place for the back screws
    up(nothing) position(BACK + BOTTOM)
        cube([ tent_thickness + nothing, 12, tent_max_height ], anchor = BACK + TOP);
  };
  y_offset = case_tent_hole_center_y_offset_from_edge;
  up(nothing) union() {
    fwd(y_offset) tent_screw_hole();
    fwd(case_size_y - y_offset) tent_screw_hole();
  }
}

module tent_wrist_rest_mask() {
  cube([ tent_thickness + nothing, wrist_rest_size.y, case_height * 2 ], anchor = BACK + BOTTOM);
  y_offset = case_tent_hole_center_y_offset_from_edge;
  up(nothing) union() {
    fwd(y_offset) tent_screw_hole();
    fwd(wrist_rest_size.y - y_offset) tent_screw_hole();
  }
}

module tent_screw_hole() {
  // screw hole
  cylinder(d = leg_screw_hole_diameter, h = tent_screw_hole_thickness, anchor = TOP);

  // nut
  z1 = tent_screw_nut_thickness + tent_screw_hole_thickness;
  down(z1) linear_extrude(tent_screw_nut_thickness + nothing / 2)
      hexagon(d = tent_screw_nut_diameter);

  // larger hole
  down(z1 - nothing / 2)
      cylinder(d = tent_screw_nut_hole_diameter, h = tent_max_height + nothing, anchor = TOP);
}

module tent_screw_hole_test() {
  size = tent_screw_nut_hole_diameter + 3;
  h = 7;

  difference() {
    down(h + nothing) linear_extrude(h)
        rect([ size, size ], rounding = [ size / 2, size / 2, 0, 0 ]);
    tent_screw_hole();
  }
}

// For the right keyboard half
// tent();

// For the left keyboard half
mirror([ 1, 0, 0 ]) tent();

// tent2d();
// tent_kb_mask();
// tent_screw_hole();
// tent_screw_hole_test();

// #cube([ 5, case_tent_hole_center_y_offset_from_edge, 5 ], anchor = BACK);
// #fwd(case_size_y) cube([ 5, case_tent_hole_center_y_offset_from_edge, 5 ], anchor = FWD);
