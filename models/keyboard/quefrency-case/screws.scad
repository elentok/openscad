
include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

module case_back_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) fwd(case_kb_padding + screw_offset.y)
      position(BACK + RIGHT) case_top_screw();
}

module case_fwd_screw_mask(screw_offset) {
  tag("remove") left(case_kb_padding + screw_offset.x) back(case_kb_padding + screw_offset.y)
      position(FWD + RIGHT) case_top_screw();
}

module case_top_screw() {
  d = kb_screw_diameter;
  size = [ d + 2 * kb_screw_flexibility, d ];
  rect(size, rounding = d / 2);
}

module leg_screw_holes(panel_size, panel_thickness, x_offset_from_edge, y_offset_from_edge,
                       screw_head_height = leg_screw_head_height) {
  x_offset = panel_size.x / 2 - x_offset_from_edge;
  y_offset = panel_size.y / 2 - y_offset_from_edge;
  back(y_offset) {
    left(x_offset) flexible_leg_screw_hole(panel_thickness, screw_head_height);
    right(x_offset) flexible_leg_screw_hole(panel_thickness, screw_head_height);
  }
  fwd(y_offset) {
    left(x_offset) flexible_leg_screw_hole(panel_thickness, screw_head_height);
    right(x_offset) flexible_leg_screw_hole(panel_thickness, screw_head_height);
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

// A larger screw hole so it's flexible to inaccuracies in screw positions.
module flexible_leg_screw_hole(panel_thickness, screw_head_height) {
  // hull() {
  //   fwd(leg_screw_head_flexibility) leg_screw_hole(panel_thickness, screw_head_height);
  //   back(leg_screw_head_flexibility) leg_screw_hole(panel_thickness, screw_head_height);
  // }

  // In the wrist rest I don't need the screw head to go all the way in.
  screw_body_height = panel_thickness - screw_head_height;

  y = leg_screw_head_flexibility;

  down(nothing / 2) union() {
    // screw body
    hull() {
      back(y) cylinder(d = leg_screw_hole_diameter, h = screw_body_height + nothing);
      fwd(y) cylinder(d = leg_screw_hole_diameter, h = screw_body_height + nothing);
    }
    // screw head
    up(screw_body_height) hull() {
      back(y) cylinder(d = leg_screw_head_diameter, h = screw_head_height + nothing);
      fwd(y) cylinder(d = leg_screw_head_diameter, h = screw_head_height + nothing);
    }
  }
}
