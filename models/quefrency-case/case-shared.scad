
module case_bottom_2d() {
  diff() {
    rect([ case_size_x, case_size_y ], rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      case_screw_holes();
    }
  }
}

module case_screw_holes() {
  for (i = [0:len(kb_back_screws) - 1]) {
    screw_offset = kb_back_screws[i];
    case_back_screw_mask(screw_offset);
  }
  for (i = [0:len(kb_fwd_screws) - 1]) {
    screw_offset = kb_fwd_screws[i];
    case_fwd_screw_mask(screw_offset);
  }
}

module case_mask(is_socket, connector_z_pos) {
  size_x_offset = -connector_width / 2 - connector_tolerance + nothing;

  size_back = [
    case_back_connector + size_x_offset,
    case_size_y / 2 + nothing,
    case_height + nothing,
  ];

  offset_back = [
    case_size_x - size_back.x + nothing / 2,
    case_size_y / 2,  //- nothing / 2,
    -case_bottom_height - case_top_border_height - nothing / 2,
  ];

  size_fwd = [
    case_fwd_connector + size_x_offset,
    case_size_y / 2 + nothing,
    case_height + nothing,
  ];

  offset_fwd = [
    case_size_x - size_fwd.x + nothing / 2,
    -nothing / 2,
    -case_bottom_height - case_top_border_height - nothing / 2,
  ];

  translate(offset_back) cube(size_back, anchor = BOTTOM + FWD + LEFT) {
    connector(is_socket, BACK, connector_z_pos);
  };

  translate(offset_fwd) cube(size_fwd, anchor = BOTTOM + FWD + LEFT) {
    connector(is_socket, FRONT, connector_z_pos);
  };
}

module case_border() {
  shell2d(-case_border_thickness)
      rect([ case_size_x, case_size_y ], rounding = case_border_radius, anchor = BOTTOM + LEFT) {}
}

module case_usb_holes() {
  y = case_size_y - case_border_thickness - nothing / 2;
  z = -kb_height;
  size = [ case_usb_hole_width, case_border_thickness + nothing, case_usb_hole_height ];
  for (i = [0:len(case_usb_hole_start_from_left) - 1]) {
    x = case_usb_hole_start_from_left[i];
    tag("remove3d") translate([ x, y, z ]) cube(size);
  }
}
