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
  y_offset = y_pos == FWD ? nothing + (case_to_keys - connector_notch_size.y)
                          : -nothing - (case_to_keys - connector_notch_size.y);

  z_offset = z_pos == TOP ? -nothing / 2 - (case_top_thickness - connector_notch_size.z) : 0;
  notch_offset = [
    nothing,
    y_offset,
    z_offset,
  ];
  translate(notch_offset) position(z_pos + LEFT + y_pos)
      cube(connector_notch_size, anchor = z_pos + RIGHT + y_pos);
}

module connector_socket(y_pos, z_pos) {
  y_offset = y_pos == FWD ? nothing + case_border_thickness : -nothing - case_border_thickness;
  socket_offset = [
    nothing,
    y_offset,
    -nothing / 2 - case_top_thickness / 2,
  ];
  size = add_scalar(connector_socket_size, nothing);
  translate(socket_offset) position(z_pos + LEFT + y_pos)
      cube(size, anchor = z_pos + RIGHT + y_pos);
}
