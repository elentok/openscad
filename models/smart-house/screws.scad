nothing = 0.01;
tolerance = 0.4; // diameter-wise

function get_screw_diameter_by_type(type) =
    type == "m2"   ? 1.9
    : type == "m3" ? 2.8
                   : assert(false, "Only supporting m2+m3 so far");

// These values include tolerance
function get_screw_head_height(type) =
    type == "m3" ? 2 : assert(false, "Only supporting m3 so far");

// These values include tolerance
function get_screw_head_diameter(type) =
    type == "m3" ? 6.5 : assert(false, "Only supporting m3 so far");

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

// distance_from_center - distance of the center of the tube from the center
//                        of the containing circle.
module screw_tube(h, type = "m3", thickness = 1.5, support = 0,
                  support_rounding = 0, distance_from_center = 0, angle = 0,
                  container_circle_diameter = 0) {
  narrow_id = get_screw_diameter_by_type("m3");
  wide_id = narrow_id + tolerance;
  od = wide_id + thickness;
  wide_height = 2;

  rotate([ 0, 0, angle ]) right(distance_from_center) union() {
    // wide part (to guide the screw)
    tube(id = wide_id, od = od, h = wide_height, anchor = BOTTOM);

    // narrow part (so the screw fits)
    up(wide_height - nothing)
        tube(id = narrow_id, od = od, h = h - wide_height, anchor = BOTTOM);

    support_size = container_circle_diameter > 0
                       ? container_circle_diameter / 2 - distance_from_center -
                             od / 2 - thickness / 2
                       : support;

    if (support_size > 0) {
      rotate([ 90, 0, 0 ]) right(od / 2 - nothing)
          rect([ support_size, h ], rounding = support_rounding,
               anchor = LEFT + FWD);
    }
  }
}
