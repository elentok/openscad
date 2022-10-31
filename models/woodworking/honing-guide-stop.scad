include <BOSL2/std.scad>
$fn = 64;

chisel_protrusion = 30; // 30mm => 30deg
width = 40;
lip_thickness = 3;
lip_height = 10;
bottom_thickness = 7;

module stop() {
  bottom_size = [ width, chisel_protrusion + lip_thickness, bottom_thickness ];
  lip_size = [ width, lip_thickness, lip_height ];

  diff() cube(bottom_size, anchor = BACK) {
    position(BACK + TOP) cube(lip_size, anchor = BACK + BOTTOM);

    tag("remove")
        cylinder(d = width / 2, h = bottom_thickness + 0.01, center = true);
  }
}

stop();
