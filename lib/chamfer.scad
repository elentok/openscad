module chamfered_hole(height, hole_diameter, chamfer_diameter) {
  chamfer_height = (chamfer_diameter - hole_diameter) / 2;
  cylinder_height = height - chamfer_height;

  translate([ 0, 0, -height / 2 ]) union() {
    // Add 0.1 to make sure the union with the chamfer is perfect
    cylinder(h = cylinder_height + 0.1, d = hole_diameter);

    translate([ 0, 0, cylinder_height ])
        cylinder(h = chamfer_height, d1 = hole_diameter, d2 = chamfer_diameter);
  }
}
