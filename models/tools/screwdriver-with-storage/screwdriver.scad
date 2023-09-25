include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.1;

bit_diameter = 7.2;
bit_width = 6.36;
bit_height = 25;
bit_head_height = 8;
bit_tolerance = 0.1;
bit_spacing_x = 4;
bit_spacing_y = 4;

bit_holder_diameter = 9.9;

bits = 4;

top_height = 50;
bottom_height = 10;
bottom_thickness = 2;
side_thickness = 2;
thread_height = 4;
thread_thickness = 2;
thread_pitch = 1.5;

// TODO: more bits
id = bit_diameter * 2 + bit_spacing_x + side_thickness * 2;
od = id + thread_thickness;

echo("Outer diameter: ", od);

module top() {
  difference() {
    cyl(d = od, h = top_height, anchor = BOTTOM, rounding2 = bottom_height / 2);
    down(epsilon / 2)
        threaded_rod(d = id, pitch = thread_pitch, h = thread_height + epsilon,
                     anchor = BOTTOM);
  }
}

module bottom() {
  difference() {
    bottom_base();
    // rotate([ 0, 0, 45 ]) up(bottom_height / 2) right(od / 2) sphere(d = 5);
    bits_mask();
  }
}

module bits_mask() {
  h = bottom_height - bottom_thickness + epsilon;

  move_bits() bit_mask(h);

  // up(bottom_thickness) {
  //   left(bit_diameter / 2 + bit_spacing_x / 2) bit_mask(h);
  //   right(bit_diameter / 2 + bit_spacing_x / 2) bit_mask(h);
  //
  //   back(bit_width / 2 + bit_spacing_y / 2) bit_mask(h);
  //   fwd(bit_width / 2 + bit_spacing_y / 2) bit_mask(h);
  // }
}

module move_bits() {
  up(bottom_thickness) {
    left(bit_diameter / 2 + bit_spacing_x / 2) children();
    right(bit_diameter / 2 + bit_spacing_x / 2) children();

    back(bit_width / 2 + bit_spacing_y / 2) children();
    fwd(bit_width / 2 + bit_spacing_y / 2) children();
  }
}

module bit_mask(h) {
  linear_extrude(h) hexagon(d = bit_diameter + bit_tolerance);
}

module bottom_base() {
  h = bottom_height - thread_height;

  cyl(d = od, h = h, rounding1 = bottom_height / 2, anchor = BOTTOM);

  up(h - epsilon) threaded_rod(d = id, pitch = thread_pitch,
                               h = thread_height + epsilon, anchor = BOTTOM);

  // cyl(d = id, h = thread_height, rounding1 = bottom_height / 2,
  //     anchor = BOTTOM);
}

module bit(color = "green") {
  color(color) hull() {
    up(bit_height - 0.25) rotate([ 0, 90, 0 ])
        cyl(d = 0.5, h = bit_diameter * 0.8);
    // up(bit_height - 0.5) sphere(d = 1);
    linear_extrude(bit_height - bit_head_height) hexagon(d = bit_diameter);
  }
}

module bits() { move_bits() bit(); }

module demo(space = 10) {
  up(bottom_height + space) top();
  bottom();
  bits();
}

demo();
// bottom();
// bit();
