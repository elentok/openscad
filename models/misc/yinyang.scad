include <BOSL2/std.scad>
$fn = 64;

height = 3;
outer_diameter = 50;
dot_hole_diameter = outer_diameter / 4;
tolerance = 0.04;
dot_diameter = dot_hole_diameter - tolerance;
wrapper_border_width = 2;
wrapper_bottom_thickness = 2.4;
magnet_d = 15.1;
magnet_h = 1.8;

assert(magnet_h <= wrapper_bottom_thickness,
       "Wrapper bottom must be at least as thick as the magnet");

module wrapper() {
  wrapper_id = outer_diameter + tolerance;
  wrapper_od = wrapper_id + wrapper_border_width;

  difference() {
    cyl(d = wrapper_od, h = wrapper_bottom_thickness, anchor = TOP);
    // magnet
    down(wrapper_bottom_thickness - magnet_h + 0.01)
        cyl(d = magnet_d, h = magnet_h, anchor = TOP);
  }
  tube(od = wrapper_od, id = wrapper_id, h = height, anchor = BOTTOM);
}

module half_yinyang() { linear_extrude(height) half_yinyang_2d(); }

module half_yinyang_2d() {
  d = outer_diameter;
  r = d / 2;

  round2d(0.2) difference() {
    union() {
      difference() {
        circle(d = d);
        rect([ d, r ], anchor = FWD);
      }

      circle(d = r, anchor = LEFT);
    }

    circle(d = r, anchor = RIGHT);

    // dot
    right(r / 4) circle(d = r / 2, anchor = LEFT);
  }
}

module dot() { cyl(d = dot_diameter, h = height, anchor = BOTTOM); }

module demo(space = 0) {
  color("green") wrapper();

  color("white") half_yinyang();
  color("black") right(dot_hole_diameter) dot();

  rotate(180) color("black") half_yinyang();
  color("white") left(dot_hole_diameter) dot();
}

wrapper();
// half_yinyang();
// dot();

// demo();
