$fn = 50;

// ------------------------------------------------------------
// Helper functions
// ------------------------------------------------------------

function normalize_radius(radius) = is_list(radius)
                                        ? radius
                                        : [ radius, radius, radius, radius ];

// ------------------------------------------------------------
// Rounded Square (hull)
// ------------------------------------------------------------

module rounded_square(size, radius) {
  radius = normalize_radius(radius);
  assert(len(radius) == 4,
         "Invalid radius value, must be either single value or array of 4");

  for (i = [0:3]) {
    assert(radius[i] <= size.x / 2,
           "Radius must be less or equal to half the height");
    assert(radius[i] <= size.y / 2,
           "Radius must be less or equal to half the width");
  }

  r_top_left = radius[0];
  r_top_right = radius[1];
  r_bottom_right = radius[2];
  r_bottom_left = radius[3];

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
// Test
// ------------------------------------------------------------

// rounded_square([ 40, 20 ], radius = 3);
rounded_square([ 40, 20 ], radius = [ 10, 3, 3, 10 ]);
