include <BOSL2/std.scad>
use <../../lib/countersunk-screw-mask.scad>
$fn = 64;

// Grips a cube object to a surface (to attach the Raspberry Pi, power splitters
// and PSUs to a drawer).

// object_width = 76.5;
// object_height = 32.1;
object_width = 63;
object_height = 31.1;

wall_thickness = 2;
grip_teeth_width = 3;
grip_depth = 20;
triangular_supports_width = 2;

// Add space between the grip and the surface to allow for better airflow
// Set to 0 to remove feet
feet_height = 10;
feet_width = 10;
feet_margin = 4;  // distance of the feet from the edge

grip_width_top = object_width + wall_thickness * 2;
grip_width_bottom = grip_width_top + triangular_supports_width * 2;
grip_height = object_height + wall_thickness * 2;
rounding = wall_thickness / 4;

module grip() {
  if (feet_height <= 0) {
    grip_base();
  } else {
    grip_with_feet();
  }
}

module grip_with_feet() {
  feet_x = grip_width_bottom / 2 - feet_width / 2 - feet_margin;

  difference() {
    up(feet_height) grip_base();

    // countersunk screw mask
    h_mask = feet_height + wall_thickness + 0.01;
    down(0.01 / 2) {
      right(feet_x) countersunk_screw_mask(h = h_mask, h_above = 2);
      left(feet_x) countersunk_screw_mask(h = h_mask, h_above = 2);
    }

    // bottom air holes
    air_hole_d = grip_depth / 2;
    air_hole_x = feet_x / 2;
    up(feet_height - 0.01 / 2) {
      cyl(d = air_hole_d, h = wall_thickness + 0.01, anchor = BOTTOM);
      right(air_hole_x)
          cyl(d = air_hole_d, h = wall_thickness + 0.01, anchor = BOTTOM);
      left(air_hole_x)
          cyl(d = air_hole_d, h = wall_thickness + 0.01, anchor = BOTTOM);
    }
  }
}

module grip_base() {
  rotate([ 90, 0, 0 ]) linear_extrude(grip_depth, center = true, convexity = 4)
      grip_base2d();
}

module grip_base2d() {
  back(grip_height / 2) round2d(or = rounding) union() {
    difference() {
      trapezoid(h = grip_height, w2 = grip_width_top, w1 = grip_width_bottom);
      rect([ object_width, object_height ]);
      rect([ object_width - grip_teeth_width * 2, object_height ],
           anchor = FWD);
    }

    if (feet_height > 0) {
      feet_x = grip_width_bottom / 2 - feet_width / 2 - feet_margin;
      fwd(grip_height / 2) {
        left(feet_x) foot2d();
        right(feet_x) mirror([ 1, 0 ]) foot2d();
      }
    }
  }
}

module foot2d() {
  left(feet_width / 2) mirror([ 0, 1 ])
      right_triangle([ feet_height, feet_margin ], spin = 90);
  rect([ feet_width, feet_height ], anchor = TOP);

  right(feet_width / 2) right_triangle([ feet_height, 2 ], spin = -90);
}

// foot2d();
// foot();
// grip_base2d();
grip();
