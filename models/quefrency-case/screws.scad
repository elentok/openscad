
include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module leg_screw_hole() {
  // In the wrist rest I don't need the screw head to go all the way in.
  screw_head_height = 0.5;
  screw_body_height = wrist_rest_bottom_thickness - screw_head_height;

  down(nothing / 2) union() {
    // screw body
    cylinder(d = leg_screw_hole_diameter, h = screw_body_height + nothing);
    // screw head
    up(screw_body_height) cylinder(d = leg_screw_head_diameter, h = screw_head_height + nothing);
  }
}

module case_back_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) fwd(case_kb_padding + screw_offset.y)
      position(BACK + RIGHT) circle(d = kb_screw_diameter);
}

module case_fwd_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) back(case_kb_padding + screw_offset.y)
      position(FWD + RIGHT) circle(d = kb_screw_diameter);
}
