include <BOSL2/std.scad>
use <../../lib/countersunk-screw-mask.scad>
$fn = 64;

// Grips a cube object to a surface (to attach the Raspberry Pi, power splitters
// and PSUs to a drawer).

object_width = 76.5;
object_height = 32.1;
wall_thickness = 2;
grip_teeth_width = 3;
grip_depth = 20;

// Add space between the grip and the surface to allow for better airflow
// Set to 0 to remove feet
feet_height = 10;
feet_width = 10;
feet_margin = 5;  // distance of the feet from the edge

grip_width = object_width + wall_thickness * 2;
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
  feet_x = grip_width / 2 - feet_width / 2 - feet_margin;

  difference() {
    union() {
      up(feet_height) grip_base();

      right(feet_x) foot();
      left(feet_x) foot();
    }

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
  back(grip_height / 2) round2d(rounding) difference() {
    rect([ grip_width, grip_height ]);
    rect([ object_width, object_height ]);
    rect([ object_width - grip_teeth_width * 2, object_height ], anchor = FWD);
  }
}

module foot() {
  cuboid([ feet_width, grip_depth, feet_height ], anchor = BOTTOM);
}

grip();
