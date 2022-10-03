
include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_back_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) fwd(case_kb_padding + screw_offset.y)
      position(BACK + RIGHT) circle(d = kb_screw_diameter);
}

module case_fwd_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) back(case_kb_padding + screw_offset.y)
      position(FWD + RIGHT) circle(d = kb_screw_diameter);
}

module leg_screw_holes(panel_size, panel_thickness, margins,
                       screw_head_height = leg_screw_head_height) {
  x_diff = panel_size.x / 2 - margins.x;  //- leg_screw_hole_diameter / 2 - margins.x;
  y_diff = panel_size.y / 2 - margins.y;  //- leg_screw_hole_diameter / 2 - margins.y;
  back(y_diff) {
    left(x_diff) leg_screw_hole(panel_thickness, screw_head_height);
    right(x_diff) leg_screw_hole(panel_thickness, screw_head_height);
  }
  fwd(y_diff) {
    left(x_diff) leg_screw_hole(panel_thickness, screw_head_height);
    right(x_diff) leg_screw_hole(panel_thickness, screw_head_height);
  }
}

module leg_screw_hole(panel_thickness, screw_head_height) {
  // In the wrist rest I don't need the screw head to go all the way in.
  screw_body_height = panel_thickness - screw_head_height;

  down(nothing / 2) union() {
    // screw body
    cylinder(d = leg_screw_hole_diameter, h = screw_body_height + nothing);
    // screw head
    up(screw_body_height) cylinder(d = leg_screw_head_diameter, h = screw_head_height + nothing);
  }
}
