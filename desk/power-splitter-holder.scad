include <BOSL2/std.scad>
use <../../lib/countersunk-screw-mask.scad>
$fn = 64;

thickness = 4;
splitter_depth = 27;
splitter_height = 52.5;
tooth_depth = 2;
tooth_height = 3;
triangle_depth = 10;
holder_width = 22;

module holder() {
  difference() {
    linear_extrude(holder_width, convexity = 4) slice();

    // screw hole
    back(0.01) up(holder_width / 2) right(splitter_depth / 2)
        rotate([ 90, 0, 0 ]) {
      // screw hole
      countersunk_screw_mask(thickness + 0.01);

      // screwdriver hole
      up(splitter_height + thickness + 0.01 / 2)
          cylinder(d = 8, h = thickness + 0.01);
    }
  }
}

module slice() {
  rect([ splitter_depth + thickness, thickness ],
       rounding = [ 0, 0, 0, thickness / 2 ], anchor = BACK + LEFT);

  fwd(thickness) rect([ thickness, splitter_height ], anchor = BACK + LEFT);

  fwd(splitter_height + thickness) rect(
      [ splitter_depth + thickness + tooth_depth, thickness ],
      rounding = [ 0, 0, thickness / 2, thickness / 2 ], anchor = BACK + LEFT);

  // tooth
  right(splitter_depth + thickness) fwd(splitter_height + thickness)
      rect([ tooth_depth, tooth_height ],
           rounding = [ tooth_depth / 2, tooth_depth / 2, 0, 0 ],
           anchor = FWD + LEFT);

  // triangle (strength)
  right_triangle([ triangle_depth, splitter_height + thickness ], spin = 180);
}

holder();
