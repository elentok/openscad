nothing = 0.01;
tolerance = 0.4; // diameter-wise

function get_screw_diameter(type) =
    type == "m2"   ? 1.9
    : type == "m3" ? 2.8
                   : assert(false, "Only supporting m2+m3 so far");

function get_screw_diameter_with_tolerance(type) =
    get_screw_diameter(type) + tolerance;

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
                  support_height = undef, support_rounding = 0,
                  distance_from_center = 0, angle = 0,
                  container_circle_diameter = 0) {
  narrow_id = get_screw_diameter("m3");
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

    support_height_value = is_num(support_height) ? support_height : h;

    if (support_size > 0) {
      rotate([ 90, 0, 0 ]) back(h - support_height_value)
          right(od / 2 - nothing)
              rect([ support_size, support_height_value ],
                   rounding = support_rounding, anchor = LEFT + FWD);
    }
  }
}

module screw_head_tube(h = 5, type = "m3", thickness = 1.5,
                       distance_from_center = 0, angle = 0) {
  screw_hole_diameter = get_screw_diameter_with_tolerance(type);
  screw_head_height = get_screw_head_height(type);
  screw_head_diameter = get_screw_head_diameter(type);
  od = screw_head_diameter + thickness * 2;

  rotate([ 0, 0, angle ]) right(distance_from_center) union() {

    // head tube
    tube(id = screw_head_diameter, od = od, h = screw_head_height,
         anchor = BOTTOM);

    // screw body tube
    up(screw_head_height - nothing)
        tube(id = screw_hole_diameter, od = od, h = h - screw_head_height,
             anchor = BOTTOM);
  }
}

module screw_head_mask(type = "m3", distance_from_center = 0, angle = 0) {
  screw_head_diameter = get_screw_head_diameter(type);
  screw_head_height = get_screw_head_height(type);

  rotate([ 0, 0, angle ]) right(distance_from_center)
      cylinder(d = screw_head_diameter, h = screw_head_height);
}
