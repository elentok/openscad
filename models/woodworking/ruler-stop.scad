include <BOSL2/std.scad>
$fn = 64;

nothing = 0.01;

ruler_width = 19.6;
ruler_height = 0.37;

ruler_width_tolerance = 0.85;
ruler_height_tolerance = 0.1;

stop_size = [ 50, 20, 20 ];
stop_rounding = 4;

// m4 nut (values include tolerance)
nut_diameter = 7.8;
nut_width = 7.1;
nut_thickness = 3.3;
screw_diameter = 4.3;

module ruler_stop() {
  difference() {
    linear_extrude(stop_size.z, center = true) ruler_stop2d();

    nut_mask();
    screw_mask();
  }
}

module ruler_stop2d() {
  difference() {
    rect(stop_size, rounding = stop_rounding);
    rect([
      ruler_width + ruler_width_tolerance, ruler_height + ruler_height_tolerance
    ]);
  }
}

module nut_mask() {
  x = ruler_width / 2 + (stop_size.x - ruler_width) / 4;
  right(x) rotate([ 0, -90, 0 ])
      linear_extrude(nut_thickness, center = true) union() {
    hexagon(od = nut_diameter);
    rect([ stop_size.z / 2 + nothing, nut_width ], anchor = LEFT);
  }
}

module screw_mask() {
  rotate([ 0, 90, 0 ])
      cylinder(d = screw_diameter, h = stop_size.x / 2 + nothing);
}

module test_ruler_size() {
  linear_extrude(4) difference() {
    rect([ ruler_width + 5, ruler_height + 5 ], rounding = 2);
    rect([
      ruler_width + ruler_width_tolerance, ruler_height + ruler_height_tolerance
    ]);
  }
}

ruler_stop();
// nut_mask();
// screw_mask();
// test_ruler_size();
