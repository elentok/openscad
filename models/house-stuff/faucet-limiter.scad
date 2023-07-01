include <BOSL2/std.scad>
$fn = 64;

padding = 2;
thickness = 3;
connector_hole_d = 4;

module faucet_limiter(faucet_d) {
  od1 = faucet_d + padding * 2;
  od2 = connector_hole_d + padding * 2;

  linear_extrude(thickness, convexity = 4) difference() {
    hull() {
      circle(d = od1);
      right(od1 / 2 + od2 / 2) circle(d = od2);
    }

    circle(d = faucet_d);
    right(od1 / 2 + od2 / 2) circle(d = connector_hole_d);
  }
}

// faucet_limiter(faucet_d = 18.6);
faucet_limiter(faucet_d = 6.6);
