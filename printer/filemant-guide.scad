include <BOSL2/screws.scad>
include <BOSL2/std.scad>
// use <../../lib/screw-hole-mask.scad>
use <../lib/screw-masks.scad>
$fn = 64;

thickness = 20;
base_height = 5;
base_width = 140;
arms_height = 100;
arms_width = 100;
arms_thickness = 8;
nut_height = 8.5;
nut_diameter = 18.2;
nut_inner_diameter = 10.2;
nut_offset = 0.2;
ptfe_hole_diameter = 5;
ptfe_hole_inner_radius = 10;
ptfe_hole_position = 0.35;

// the thickness that prevents the nut from falling through
nut_space = 1;

// simple guide
// sg_type = "m10";
sg_type = "ptfe";
sg_size = [ 80, 20, 80 ];
sg_bottom_width = 20;
sg_hole_offset = 20;
sg_screw_hole_offset = 13;
sg_support_width = 20;
sg_support_height = 15;
sg_support_tolerance = 0.1;

module guide() {
  difference() {
    rotate([ 90, 0, 0 ]) linear_extrude(thickness, center = true, convexity = 4)
        slice();

    left(nut_offset * arms_width) {
      // nut
      up(arms_height - nut_height - nut_space)
          linear_extrude(nut_height, convexity = 4) rotate([ 0, 0, 90 ])
              hexagon(d = nut_diameter);

      // space for the ptfe
      up(arms_height + 0.01 / 2)
          cyl(d = nut_inner_diameter, h = nut_space + 0.01, anchor = TOP);
    }

    // side hole for the PTFE tube

    ptfe_hole_mask();
    mirror([ 1, 0, 0 ]) ptfe_hole_mask();

    x = arms_width / 2 + (base_width - arms_width) / 4;
    left(x) bottom_screw_hole_mask();
    right(x) bottom_screw_hole_mask();
  }
}

module bottom_screw_hole_mask() {
  down(0.01 / 2)
      screw_hole_maskx(screw_type = "m4", l_wall = base_height + 0.01,
                       countersink = true, axis = UP, anchor = BOTTOM);
}

module ptfe_hole_mask() {
  up(arms_height * ptfe_hole_position + ptfe_hole_inner_radius +
     ptfe_hole_diameter / 2) left(arms_width / 2 + 0.01) scale([ 1.5, 1, 1 ])
      rotate([ 0, -90, 0 ]) rotate([ 90, 0, 0 ]) rotate_extrude(angle = 90)
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

module simple_guide() {
  difference() {
    // linear_extrude(sg_size.y, center = true, convexity = 4) hexagon(d = 20);
    linear_extrude(sg_size.y, convexity = 4, center = true)
        trapezoid(h = sg_size.z, w1 = sg_size.x, w2 = sg_bottom_width,
                  rounding = [ 4, 4, 0, 0 ], anchor = FWD);
    back(sg_size.z - sg_hole_offset) {
      if (sg_type == "m10") {
        screw_hole("M10x1.25", l = sg_size.y + 0.01, thread = true,
                   $slop = 0.1);
      } else if (sg_type == "ptfe") {
        scale([ 1, 1, 2 ]) right(sg_size.x / 3) rotate([ 90, 90, 0 ])
            rotate_extrude()
                right(sg_size.x / 3) #circle(d = ptfe_hole_diameter);
        // cyl(d = ptfe_hole_diameter, h = sg_size.y + 0.01);
      }
    }

    left(sg_size.x / 2 - sg_screw_hole_offset) sg_screw_mask();
    right(sg_size.x / 2 - sg_screw_hole_offset) sg_screw_mask();

    // support connector
    fwd(0.01) cuboid(
        [
          sg_support_width + sg_support_tolerance,
          sg_support_height + sg_support_tolerance, sg_size.y + 0.01
        ],
        anchor = FWD);
  }
}

module simple_guide_support() {
  difference() {
    // linear_extrude(sg_size.y, center = true, convexity = 4) hexagon(d = 20);
    linear_extrude(sg_support_width, convexity = 4, center = true)
        trapezoid(h = sg_size.z / 2, w1 = sg_size.x, w2 = sg_bottom_width,
                  rounding = [ 4, 4, 0, 0 ], anchor = FWD);

    back(sg_support_height) cuboid(
        [
          sg_size.y + sg_support_tolerance, sg_size.z / 2,
          sg_support_width + 0.01
        ],
        anchor = FWD);
  }
}

module sg_screw_mask() {
  fwd(0.01) screw_hole_maskx("m4", l_wall = 5, l_screwdriver = sg_size.z - 5,
                             countersink = true, axis = FWD, anchor = FWD);
}

// simple_guide_support();
simple_guide();
// guide();
// slice();

// nut("M10", bevel = false, thread = "fine", $slop = 0.1, blunt_start = false,
//     ibevel = false);
