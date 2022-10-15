include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;
nodemcu_size = [ 48.2, 25.8, 4.7 ];
nodemcu_pins_size = [37.6, 2.5, 8.8];
// nodemcu_radius^2 = (x/2)^2 + (y/2)^2
nodemcu_radius = sqrt((nodemcu_size.x / 2) ^ 2 + (nodemcu_size.y / 2) ^ 2);
echo("Node MCU Radius:", nodemcu_radius);
nodemcu_hole_diameter = 3.5;
// The distance of the hole center from the edge.
nodemcu_hole_center_offset = 2.3;

usb_opening_height = 9;
usb_opening_width = 14;

function get_screw_diameter_by_type(type) =
  type == "m2" ? 1.9 :
  type == "m3" ? 2.9
               : assert(false, "Only supporting m2 so far");

module nodemcu(anchor) {
  diff() {
    cube(nodemcu_size, anchor=anchor) {
      // Pins back side
      position(BACK + BOTTOM) cube(nodemcu_pins_size, anchor=BACK + TOP);

      // Pins front side
      position(FRONT + BOTTOM) cube(nodemcu_pins_size, anchor=FRONT + TOP);

      // Holes
      o = nodemcu_hole_center_offset;
      tag("remove") up(nothing/2) {
        translate([o, -o, 0]) position(TOP + BACK + LEFT)
          cylinder(d=nodemcu_hole_diameter, h=nodemcu_size.z + nothing,
              anchor=TOP);

        translate([o, o, 0]) position(TOP + FRONT + LEFT)
          cylinder(d=nodemcu_hole_diameter, h=nodemcu_size.z + nothing,
              anchor=TOP);

        translate([-o, -o, 0]) position(TOP + BACK + RIGHT)
          cylinder(d=nodemcu_hole_diameter, h=nodemcu_size.z + nothing,
              anchor=TOP);

        translate([-o, o, 0]) position(TOP + FRONT + RIGHT)
          cylinder(d=nodemcu_hole_diameter, h=nodemcu_size.z + nothing,
              anchor=TOP);
      }
    }
  }
}

module nodemcu_feet(h, thickness = 1.5, screw_type = "m3") {
  x = nodemcu_size.x/2 - nodemcu_hole_center_offset;
  y = nodemcu_size.y/2 - nodemcu_hole_center_offset;

  id = get_screw_diameter_by_type(screw_type);
  od = id + thickness*2;

  back(y) {
    left(x) tube(od = od, id = id, h, anchor=BOTTOM);
    right(x) tube(od = od, id = id, h, anchor=BOTTOM);
  }

  fwd(y) {
    left(x) tube(od = od, id = id, h, anchor=BOTTOM);
    right(x) tube(od = od, id = id, h, anchor=BOTTOM);
  }
}

module nodemcu_usb_opening_mask(y) {
   left(nodemcu_size.x/2) usb_opening_mask(y);
}

module usb_opening_mask(thickness) {
  up(1.5) cube([thickness, usb_opening_width, usb_opening_height], center=true);
}
