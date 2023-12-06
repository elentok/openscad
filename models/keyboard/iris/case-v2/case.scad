include <./shared.scad>

middle_layer_h = 12.8;

module original() {
  left(0.2) up(1.8)
      import("original/Iris PE Middle Layer - Normal for 1.5mm Plate.stl");
}

module mid_layer_left() {
  original();
  up(bolt_head_h) fwd(104.5) {
    translate(bolt_bl) rotate([ 0, 0, 180 ]) bolt_holder(corner = "side2");
    translate(bolt_br) rotate([ 0, 0, 180 ]) bolt_holder();
  }
}

mid_layer_left();
