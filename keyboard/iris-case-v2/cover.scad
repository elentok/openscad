include <BOSL2/std.scad>
$fn = 64;

bottom_thickness = 2;
keycaps_height = 5.5;

magnet_d = 5.1;
magnet_h = 2.5;

magnet_positions = [
  [ 3.9, 40 ],
  [ 3.9, 120 ],
  [ 71, 21 ],
  [ 126.5, 120 ],
  [ 129, 62 ],
  [ 140.7, 25 ],
];

module original_top_shell() {
  import("original/Iris PE Top Shell for 1.5mm plate.stl");
}

module case_2d() { projection(cut = false) original_top_shell(); }

module case_2d_filled() {
  case_2d();
  right(6) back(40) rect([ 120, 87 ], anchor = LEFT + FWD, rounding = 5);
  right(70) back(40) rotate([ 0, 0, -30 ])
      rect([ 70, 50 ], anchor = LEFT + FWD, rounding = 5);
  right(70) back(20) rect([ 40, 20 ], anchor = LEFT + FWD, rounding = 5);
}

module cover() {
  difference() {
    union() {
      linear_extrude(bottom_thickness) case_2d_filled();
      linear_extrude(bottom_thickness + keycaps_height) case_2d();
    }

#magnets_mask();
  }
}

module magnets_mask() {
  up(bottom_thickness + keycaps_height -
     magnet_h) for (i = [0:len(magnet_positions) - 1]) {
    position = magnet_positions[i];
    translate(position) cyl(d = magnet_d, h = magnet_h + 0.01, anchor = BOTTOM);
  }
}

cover();
