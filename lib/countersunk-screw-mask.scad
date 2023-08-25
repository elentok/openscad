include <BOSL2/std.scad>
include <BOSL2/structs.scad>
$fn = 64;

// screw type, [ screw body diameter, head diameter, head height ]
screws = [
  [ "M4", [ 4, 7.8, 3 ] ],
];

module countersunk_screw_mask(h, h_above = 0, screw = "M4", anchor = BOTTOM) {
  data = struct_val(screws, screw);
  assert(is_def(data), str("Screw type ", screw, " not supported"));
  d_body = data[0];
  d_head = data[1];
  h_head = data[2];
  h_body = h - h_head - h_above;

  attachable(d = d_head, h = h, anchor) {
    down(h / 2) union() {
      cyl(d = d_body, h = h_body + 0.01, anchor = BOTTOM);
      up(h_body)
          cyl(d1 = d_body, d2 = d_head, h = h_head + 0.01, anchor = BOTTOM);
      if (h_above > 0) {
        up(h_body + h_head) cyl(d = d_head, h = h_above, anchor = BOTTOM);
      }
    }

    children();
  }
}
