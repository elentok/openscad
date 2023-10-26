include <BOSL2/screws.scad>
include <BOSL2/std.scad>
use <../../lib/screw-hole-mask.scad>
$fn = 64;

thickness = 20;
base_height = 3;
base_width = 80;
arms_height = 40;
arms_width = 50;
arms_thickness = 8;
nut_height = 8.5;
nut_diameter = 18;
nut_inner_diameter = 10.2;
ptfe_hole_diameter = 5;
ptfe_hole_inner_radius = 10;

// the thickness that prevents the nut from falling through
nut_space = 2;

module guide() {
  difference() {
    rotate([ 90, 0, 0 ]) linear_extrude(thickness, center = true, convexity = 4)
        slice();

    // nut
    up(arms_height - nut_height - nut_space)
        linear_extrude(nut_height, convexity = 4) hexagon(d = nut_diameter);

    // space for the ptfe
    up(arms_height + 0.01 / 2)
        cyl(d = nut_inner_diameter, h = nut_space + 0.01, anchor = TOP);

    // side hole for the PTFE tube

    ptfe_hole_mask();
    mirror([ 1, 0, 0 ]) ptfe_hole_mask();

    x = arms_width / 2 + (base_width - arms_width) / 4;
    left(x) bottom_screw_hole_mask();
    right(x) bottom_screw_hole_mask();
  }
}

module bottom_screw_hole_mask() {
  down(0.01 / 2) screw_hole_mask(d_screw = 4, d_screw_head = 7,
                                 l_wall = base_height + 0.01, l_countersink = 1,
                                 axis = UP, anchor = BOTTOM);
}

module ptfe_hole_mask() {
  up(arms_height / 3 + ptfe_hole_inner_radius + ptfe_hole_diameter / 2)
      left(arms_width / 2 + 0.01) scale([ 1.5, 1, 1 ]) rotate([ 0, -90, 0 ])
          rotate([ 90, 0, 0 ]) rotate_extrude(angle = 90)
              left(ptfe_hole_diameter / 2 + ptfe_hole_inner_radius)
                  circle(d = ptfe_hole_diameter);
}

module slice() {
  // base
  rb = base_height / 2;
  rect([ base_width, base_height ], rounding = [ rb, rb, 0, 0 ], anchor = FWD);

  // arms
  ra = arms_thickness / 2;
  difference() {
    rect([ arms_width, arms_height ], rounding = [ ra, ra, 0, 0 ],
         anchor = FWD);
    back(base_height) rect(
        [
          arms_width - arms_thickness * 2, arms_height - arms_thickness -
          base_height
        ],
        rounding = ra, anchor = FWD);
  }
}

// guide();
// slice();

// nut("M10", bevel = false, thread = "fine", $slop = 0.1, blunt_start = false,
//     ibevel = false);
