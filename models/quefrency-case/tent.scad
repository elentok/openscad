include <./variables.scad>
include <BOSL2/std.scad>

// Calculate tent kb y length (Pythagorean theorem)
a1 = tent_height_kb_front - tent_height_kb_back;
c1 = case_right_size.y;
b1 = sqrt(c1 * c1 - a1 * a1);
tent_kb_y = b1;

// Calculate wrist rest y length (Pythagorean theorem)
a2 = tent_height_wrist_rest_back - tent_height_wrist_rest_front;
c2 = wrist_rest_size.y;
b2 = sqrt(c2 * c2 - a2 * a2);
tent_wrist_rest_y = b2;

tent_size_y = tent_kb_y + tent_wrist_rest_y;

tent_rounding = tent_thickness / 2;

module tent() {
  difference() {
    linear_extrude(tent_thickness) tent2d();
    tent_rounding_mask();
  }
}

module tent_rounding_mask() {
  h = tent_size_y + 20;
  fwd(nothing / 2) up(tent_rounding) rotate([ 0, 90, 0 ]) difference() {
    down(nothing / 2)
        cube([ tent_rounding * 2 + nothing, tent_rounding + nothing, h ], anchor = FRONT + BOTTOM);
    cylinder(h = h, d = tent_rounding * 2, anchor = FRONT + BOTTOM);
  }
}

module tent2d() {
  points = [
    [ 0, 0 ],
    [ 0, tent_height_kb_back ],
    [ tent_kb_y, tent_height_kb_front ],
    [ tent_kb_y, tent_height_wrist_rest_back ],
    [ tent_kb_y + tent_wrist_rest_y, tent_height_wrist_rest_front ],
    [ tent_kb_y + tent_wrist_rest_y, 0 ],
  ];
  offset(r = 3) offset(r = -3) polygon(points);
}

tent();
