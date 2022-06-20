module disc(diameter, depth, center = false) {
  translate([ 0, 0, center ? -depth / 2 : 0 ]) {
    linear_extrude(depth) { circle(d = diameter); }
  }
}
