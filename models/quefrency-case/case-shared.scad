
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

module case_bottom() {
  z = case_bottom_height + case_top_border_height;
  difference() {
    down(z) union() {
      // Bottom plate
      linear_extrude(case_bottom_thickness) case_bottom_2d();
      // Border
      up(case_bottom_thickness) linear_extrude(case_bottom_border_height) case_border();
    }

    case_usb_holes();
    case_bottom_tent_screw_holes();
  }
}

module case_bottom_2d() {
  diff() {
    rect([ case_size_x, case_size_y ], rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      case_screw_holes();
    }
  }
}

module case_top_2d() {
  diff() {
    rect([ case_size_x, case_size_y ], rounding = case_border_radius, anchor = BOTTOM + LEFT) {
      case_keys_mask();
      case_keys_padding_mask();
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

module case_bottom_tent_screw_holes() {
  x = case_size_x / 2;
  y = case_size_y / 2;
  z = -(case_height - case_top_thickness);
  translate([ x, y, z ])
      leg_screw_holes([ case_size_x, case_size_y ], case_bottom_thickness,
                      x_offset_from_edge = case_tent_hole_center_x_offset_from_edge,
                      y_offset_from_edge = case_tent_hole_center_y_offset_from_edge);
}

module case_keys_mask() {
  keys_size = [ kb_size_x - kb_padding, kb_size_y - kb_padding * 2 ];
  keys_offset = [ -kb_padding - case_border_thickness, (case_size_y - keys_size.y) / 2 ];
  tag("remove") translate(keys_offset) position(BOTTOM + RIGHT)
      rect(keys_size, rounding = 1, anchor = BOTTOM + RIGHT);
}

module case_keys_padding_mask() {
  row_count = len(kb_padding_by_row);

  for (i = [0:row_count - 1]) {
    padding = kb_padding_by_row[i];
    if (padding > 0) {
      padding_size = [ padding, kb_row_height ];
      padding_offset = [
        case_border_thickness,
        -case_border_thickness - kb_padding - kb_row_height * i,
      ];

      round_top = i > 0 && kb_padding_by_row[i - 1] < padding;
      round_bottom = i < row_count - 1 && kb_padding_by_row[i + 1] < padding;
      rounding = [
        round_top ? 1 : 0,
        0,
        0,
        round_bottom ? 1 : 0,
      ];

      tag("keep") translate(padding_offset) position(TOP + LEFT)
          rect(padding_size, anchor = TOP + LEFT, rounding = rounding);
    }
  }
}
