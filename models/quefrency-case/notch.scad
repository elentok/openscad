include <./variables.scad>
include <BOSL2/std.scad>
$fn = 64;

// pos = BACK or FWD
module notch(pos) {
  y_offset = pos == FWD ? nothing + (case_to_keys - notch_size.y)
                        : -nothing - (case_to_keys - notch_size.y);
  notch_offset = [
    nothing,
    y_offset,
    -nothing / 2 - (case_top_thickness - notch_size.z),
  ];
  translate(notch_offset) position(TOP + LEFT + pos) cube(notch_size, anchor = TOP + RIGHT + pos);
}

module notch_socket(pos) {
  y_offset = pos == FWD ? nothing + case_border_thickness : -nothing - case_border_thickness;
  notch_socket_offset = [
    nothing,
    y_offset,
    -nothing / 2 - case_top_thickness / 2,
  ];
  size = add_scalar(notch_socket_size, nothing);
  translate(notch_socket_offset) position(TOP + LEFT + pos) cube(size, anchor = TOP + RIGHT + pos);
}
