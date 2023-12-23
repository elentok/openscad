include <./shared.scad>

middle_layer_h = 12.8;

module original() {
  left(0.2) up(1.8)
      import("original/Iris PE Middle Layer - Normal for 1.5mm Plate.stl");
}

module mid_layer_left() {
  original();

  // bottom bolts
  up(bolt_head_h) fwd(case_left_depth) {
    translate(bolt_mid1) rotate([ 0, 0, 180 ]) bolt_holder(corner = "x");
    translate(bolt_mid2) rotate([ 0, 0, 180 ]) bolt_holder();
    translate(bolt_mid3) rotate([ 0, 0, 180 + bolt_mid3_angle ]) bolt_holder();
  }

  //
  translate(bolt_top) rotate([ 0, 0, -90 ])
      bolt_holder(nut = true, full_height = true);
}

// bolt_holder_side();
// bolt_holder(corner = "side2");
// bolt_holder_2d(corner = "x");
mid_layer_left();
