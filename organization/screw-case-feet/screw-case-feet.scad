include <BOSL2/std.scad>
$fn = 64;

module feet() {
  linear_extrude(10) {
    difference() {
      union() {
        rect([ 6.7, 9.5 ], anchor = LEFT + FWD, rounding = [ 1, 1, 0, 0 ]);
        rect([ 13, 25 ], anchor = LEFT + BACK, rounding = [ 1, 0, 1, 1 ]);
      }

      back(9.5 - 5) rect([ 1, 5 ], anchor = LEFT + FWD);
    }
  }
}

feet();
