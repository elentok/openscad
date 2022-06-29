$fn = 50;

// ------------------------------------------------------------
// Helper functions
// ------------------------------------------------------------

function normalize_radius(radius) = is_list(radius)
                                        ? radius
                                        : [ radius, radius, radius, radius ];

// ------------------------------------------------------------
// Rounded Square
// ------------------------------------------------------------
//
// Uses 4 corners and a hull() to connect them to a rectangle.
// Rounded corners are circles while straight corners are squares.
//
// Arguments:
//
// - size: [x, y]
// - radius: r or [r_top_left, r_top_right, r_bottom_right, r_bottom_left]
//
module rounded_square(size, radius) {
  radius = normalize_radius(radius);
  assert(len(radius) == 4,
         "Invalid radius value, must be either single value or array of 4");

  max_radius = min(size.x / 2, size.y / 2);

  r_top_left = min(radius[0], max_radius);
  r_top_right = min(radius[1], max_radius);
  r_bottom_right = min(radius[2], max_radius);
  r_bottom_left = min(radius[3], max_radius);

  hull() {
    if (r_top_left == 0) {
      translate([ -size.x / 2, size.y / 2 - 1 ]) square([ 1, 1 ]);
    } else {
      x = -size.x / 2 + r_top_left;
      y = size.y / 2 - r_top_left;
      translate([ x, y ]) circle(r = r_top_left);
    }

    if (r_top_right == 0) {
      translate([ size.x / 2 - 1, size.y / 2 - 1 ]) square([ 1, 1 ]);
    } else {
      x = size.x / 2 - r_top_right;
      y = size.y / 2 - r_top_right;
      translate([ x, y ]) circle(r = r_top_right);
    }

    if (r_bottom_right == 0) {
      translate([ size.x / 2 - 1, -size.y / 2 ]) square([ 1, 1 ]);
    } else {
      x = size.x / 2 - r_bottom_right;
      y = -size.y / 2 + r_bottom_right;
      translate([ x, y ]) circle(r = r_bottom_right);
    }

    if (r_bottom_left == 0) {
      translate([ -size.x / 2, -size.y / 2 ]) square([ 1, 1 ]);
    } else {
      x = -size.x / 2 + r_bottom_left;
      y = -size.y / 2 + r_bottom_left;
      translate([ x, y ]) circle(r = r_bottom_left);
    }
  }
}

// ------------------------------------------------------------
// Rounded Shell
// ------------------------------------------------------------
//
// Arguments:
//
// - size: [x, y]
// - thickness
// - outer_radius: r or [r_top_left, r_top_right, r_bottom_right, r_bottom_left]
// - inner_radius: optional, if missing will revert to inner_radius
//
module rounded_shell(size, thickness, outer_radius, inner_radius) {
  inner_radius = is_undef(inner_radius) ? outer_radius : inner_radius;
  inner_size = [ size.x - thickness * 2, size.y - thickness * 2 ];

  difference() {
    rounded_square(size, outer_radius);
    rounded_square(inner_size, inner_radius);
  }
}

// ------------------------------------------------------------
// Test
// ------------------------------------------------------------

// rounded_square([ 40, 20 ], radius = 3);
// rounded_square([ 40, 20 ], radius = [ 10, 3, 3, 10 ]);
// rounded_square([ 40, 20 ], radius = [ 10, 3, 10, 0 ]);
rounded_shell([ 40, 20 ], thickness = 2, outer_radius = [ 3, 3, 0, 3 ],
              inner_radius = [ 5, 5, 0, 5 ]);
