// From https://blog.prusa3d.com/parametric-design-in-openscad_8758/

// Round Cube
module rcube(size, radius) {
  if (len(radius) == undef) {
    // The same radius on all corners
    rcube(size, [ radius, radius, radius, radius ]);
  } else if (len(radius) == 2) {
    // Different radii on top and bottom
    rcube(size, [ radius[0], radius[0], radius[1], radius[1] ]);
  } else if (len(radius) == 4) {
    translate([ -size.x / 2, -size.y / 2, -size.z / 2 ])
        // Different radius on different corners
        hull() {
      // BL
      if (radius[0] == 0)
        cube([ 1, 1, size[2] ]);
      else
        translate([ radius[0], radius[0] ])
            cylinder(r = radius[0], h = size[2]);
      // BR
      if (radius[1] == 0)
        translate([ size[0] - 1, 0 ]) cube([ 1, 1, size[2] ]);
      else
        translate([ size[0] - radius[1], radius[1] ])
            cylinder(r = radius[1], h = size[2]);
      // TR
      if (radius[2] == 0)
        translate([ size[0] - 1, size[1] - 1 ]) cube([ 1, 1, size[2] ]);
      else
        translate([ size[0] - radius[2], size[1] - radius[2] ])
            cylinder(r = radius[2], h = size[2]);
      // TL
      if (radius[3] == 0)
        translate([ 0, size[1] - 1 ]) cube([ 1, 1, size[2] ]);
      else
        translate([ radius[3], size[1] - radius[3] ])
            cylinder(r = radius[3], h = size[2]);
    }
  } else {
    echo(
        "ERROR: Incorrect length of 'radius' parameter. Expecting integer or " +
        "vector with length 2 or 4.");
  }
}

// Rotated Round Cube
module rrcube(size, radius) {
  rotate([ 90, 0, 0 ]) { rcube([ size.x, size.z, size.y ], radius); }
}
