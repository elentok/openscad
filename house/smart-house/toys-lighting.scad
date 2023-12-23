include <BOSL2/std.scad>
$fn = 64;

nothing = 0.001;
bottom_thickness = 3;
side_thickness = 4.5;
inner_thickness = 2;
leds_od = 50;
leds_id = 34.9;
padding = 10;
height_inner = 6;

tolerance = 0;

od = leds_od + padding;
height_outer = height_inner + bottom_thickness;
inner_tube_od = leds_id - tolerance;
inner_tube_id = inner_tube_od - inner_thickness;

notch_width = 10;
cable_hole_width = 15;

center_rod_diameter = 15;
center_rod_glue_space = 1.5;

module cover() {
  cylinder(h = bottom_thickness, d = od, anchor = BOTTOM);
  up(bottom_thickness) {
    // outer tube
    difference() {
      tube(h = height_inner, od = od, id = od - side_thickness,
           anchor = BOTTOM);
      cable_hole_mask();
    }

    // inner tube
    difference() {
      tube(h = height_inner, od = inner_tube_od, id = inner_tube_id,
           anchor = BOTTOM);

      notch_mask();
      rotate([ 0, 0, 120 ]) notch_mask();
      rotate([ 0, 0, 240 ]) notch_mask();
    }

    // center rod
    tube(h = height_inner - center_rod_glue_space, od = center_rod_diameter,
         id = center_rod_diameter - inner_thickness, anchor = BOTTOM) {
      position(TOP)
          cylinder(d = center_rod_diameter, h = inner_thickness, anchor = TOP);
    }

    // cylinder(d = center_rod_diameter, h = height_inner -
    // center_rod_glue_space);
  }
}

module cable_hole_mask() {
  rotate([ 0, 0, 35 ]) down(nothing) {
    cube([ cable_hole_width, od, height_inner + nothing * 2 ],
         anchor = BOTTOM + FWD + CENTER);
  }
}

module notch_mask() {
  down(nothing) {
    cube([ notch_width, inner_tube_od, height_inner + nothing * 2 ],
         anchor = BOTTOM + FWD + CENTER);
  }
}

cover();
