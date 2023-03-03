include <../../lib/rect3d.scad>
include <BOSL2/std.scad>
$fn = 64;

rod_diameter = 17.2;
connector_thickness = 7;
rod_cup_thickness = 2;
rod_cup_height = 20;
rod_cup_diameter = rod_diameter + rod_cup_thickness * 2;

angle_top = atan(2.5 / 30);
angle_bottom = atan(3.5 / 46);

microwave_door_thickness = 50;
fingers_spacing = 30;

plate_size = [
  rod_cup_diameter,
  microwave_door_thickness + fingers_spacing + rod_cup_diameter,
  connector_thickness,
];

module plate_top() {
  difference() {
    plate_base();
    microwave_door_wedge(angle = angle_top);

    rod_y = plate_size.y - rod_diameter / 2 - rod_cup_thickness;
    fwd(rod_y) rod();
  }

  cup();
}

module rod() { down(0.1) cylinder(d = rod_diameter, h = rod_cup_height * 3); }

module plate_bottom() {
  difference() {
    plate_base();
    microwave_door_wedge(angle = angle_bottom);
  }

  cup();
}

module plate_base() {
  rounding = rod_cup_diameter / 2;
  rect3d(plate_size, rounding = [ 0, 0, rounding, rounding ],
         anchor = BACK + BOTTOM){};
}

module microwave_door_wedge(angle) {
  rotate([ -angle, 0, 0 ]) up(connector_thickness - 3.8) cube(
      [
        plate_size.x + 0.1, microwave_door_thickness, connector_thickness * 1.5
      ],
      anchor = BOTTOM + BACK);
}

module cup() {
  fwd(plate_size.y)
      tube(od = rod_cup_diameter, id = rod_diameter,
           h = rod_cup_height + plate_size.z - 0.1, anchor = BOTTOM + FRONT);
}

plate_top();
// plate_bottom();
