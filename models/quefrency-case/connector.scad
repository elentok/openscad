include <./variables.scad>
include <BOSL2/std.scad>

module connector(is_socket, y_pos, z_pos) {
  if (is_socket) {
    connector_socket(y_pos, z_pos);
  } else {
    connector_notch(y_pos, z_pos);
  }
}

module connector_notch(y_pos, z_pos) {
  size = get_connector_notch_size(z_pos);
  y_offset = -y_pos.y * (nothing + (case_to_keys - size.y));
  z_offset = z_pos == TOP ? -nothing / 2 - (case_top_thickness - size.z)
                          : (case_bottom_thickness - size.z) + nothing / 2;
  notch_offset = [
    nothing,
    y_offset,
    z_offset,
  ];
  translate(notch_offset) position(z_pos + LEFT + y_pos) cube(size, anchor = z_pos + RIGHT + y_pos);
}

module connector_socket(y_pos, z_pos) {
  socket_size = get_connector_socket_size(z_pos);
  y_offset = y_pos == FWD ? nothing / 2 + case_border_thickness : -nothing - case_border_thickness;
  z_offset = z_pos == TOP ? -nothing / 2 - case_top_thickness / 2 : case_bottom_thickness / 2;
  socket_offset = [
    nothing,
    y_offset,
    z_offset,
  ];
  size = add_scalar(socket_size, nothing);
  translate(socket_offset) position(z_pos + LEFT + y_pos)
      cube(size, anchor = z_pos + RIGHT + y_pos);
}
