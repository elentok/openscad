include <BOSL2/std.scad>
$fn = 64;

module feet() {
  linear_extrude(10) {
    rect([ 6.2, 8.6 ], anchor = LEFT + FWD, rounding = [ 1, 1, 0, 0 ]);
    rect([ 11, 25 ], anchor = LEFT + BACK, rounding = [ 1, 0, 1, 1 ]);
  }
}

feet();
