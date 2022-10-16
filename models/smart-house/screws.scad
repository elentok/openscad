function get_screw_diameter_by_type(type) =
    type == "m2"   ? 1.9
    : type == "m3" ? 2.9
                   : assert(false, "Only supporting m2 so far");

module m3_washer(h = 1.5) { tube(od = 5.5, id = 3.3, h = h); }

module m3_nut_handle(h = 5) {
  screw_diameter = 3.3;
  nut_diameter = 6.2;
  nut_thickness = 2.5;
  padding = 5;

  difference() {
    linear_extrude(h) hexagon(d = nut_diameter + padding * 2, rounding = 2);
    down(nothing / 2) linear_extrude(nut_thickness + nothing)
        hexagon(d = nut_diameter);
    cylinder(d = screw_diameter, h = h + nothing);
  }
}

module m3_screw_tube() {
  // wide part (to guide the screw)

  // narrow part (so the screw fits)
}
