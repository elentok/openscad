$fn = 50;

// ------------------------------------------------------------
// Rounded Square (minkowski)
// ------------------------------------------------------------

module rsquare(size, radius) {
  assert(radius < size.x / 2, "Radius must be less than half the width");
  assert(radius < size.y / 2, "Radius must be less than half the height");

  minkowski() {
    square([ size.x - radius * 2, size.y - radius * 2 ], center = true);
    circle(radius);
  }
}

module rsquare_shell(size, radius, thickness) {
  difference() {
    rsquare(size, radius);

    x = size.x - thickness * 2;
    y = size.y - thickness * 2;
    rsquare([ x, y ], radius);
  }
}

// ------------------------------------------------------------
// Rounded Square (offset)
// ------------------------------------------------------------

module rsquare2(size, radius) {
  x = size.x - radius * 2;
  y = size.y - radius * 2;

  assert(radius < size.x / 2, "Radius must be less than half the height");
  assert(radius < size.y / 2, "Radius must be less than half the width");

  offset(r = radius) square([ x, y ], center = true);
}

module rsquare2_shell(size, radius, thickness) {
  difference() {
    rsquare2(size, radius);

    x = size.x - thickness * 2;
    y = size.y - thickness * 2;
    rsquare2([ x, y ], radius);
  }
}

// ------------------------------------------------------------
// Rounded Square (hull)
// ------------------------------------------------------------

module rsquare3(size, radius) {
  x = size.x - radius * 2;
  y = size.y - radius * 2;

  assert(radius < size.x / 2, "Radius must be less than half the height");
  assert(radius < size.y / 2, "Radius must be less than half the width");

  hull() {
    translate([ -x / 2, -y / 2 ]) circle(r = radius);
    translate([ x / 2, -y / 2 ]) circle(r = radius);
    translate([ -x / 2, y / 2 ]) circle(r = radius);
    translate([ x / 2, y / 2 ]) circle(r = radius);
  }
}

module rsquare3_shell(size, radius, thickness) {
  difference() {
    rsquare3(size, radius);

    x = size.x - thickness * 2;
    y = size.y - thickness * 2;
    rsquare3([ x, y ], radius);
  }
}

color("green") linear_extrude(2) rsquare_shell([ 20, 40 ], 3, 2);
color("red") translate([ 0, 0, 2 ]) linear_extrude(2)
    rsquare2_shell([ 20, 40 ], 3, 2);
color("blue") translate([ 0, 0, 4 ]) linear_extrude(2)
    rsquare3_shell([ 20, 40 ], 3, 2);
