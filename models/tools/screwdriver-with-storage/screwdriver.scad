include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.1;

bit_diameter = 7.2;
bit_width = 6.36;
bit_height = 25;
bit_height_padding = 5;
bit_head_height = 8;
bit_tolerance = 0.1;
bit_spacing_x = 4;
bit_spacing_y = 4;

bit_holder_diameter = 9.9;
bit_holder_hexagon_height = 28;
bit_holder_round_height = 32.5;
bit_holder_round_inset_height = 10;

bits = 4;

top_rounding = 5;
bottom_rounding = 5;
bottom_height_without_threads = 7;
bottom_thickness = 2;
middle_thickness = 2;
side_thickness = 2;
thread_height = 4;
thread_thickness = 2;
thread_pitch = 1.5;
thread_tolerance = 0.2;

bottom_height_with_threads = bottom_height_without_threads + thread_height;
bit_height_inside_bottom = bottom_height_with_threads - bottom_thickness;
bit_height_inside_top = bit_height + bit_height_padding - bit_height_inside_bottom;
top_height = bit_height_inside_top + middle_thickness + bit_holder_hexagon_height + bit_holder_round_inset_height;

// TODO: more bits
id = bit_diameter * 2 + bit_spacing_x + side_thickness * 2;
od = id + thread_thickness;

echo("Outer diameter: ", od);
echo("Top height:", top_height);

module top() {
  difference() {
    cyl(d = od, h = top_height, anchor = BOTTOM, rounding2 = top_rounding);
    down(epsilon / 2)
        threaded_rod(d = id + thread_tolerance, pitch = thread_pitch, h = thread_height + epsilon,
                     anchor = BOTTOM);
    // cyl(d = id, h = bit_height);
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
  // h = bottom_height_with_threads - bottom_thickness + epsilon;

  move_bits() bit_mask(bit_height_inside_bottom + epsilon);

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
  cyl(d = od, h = bottom_height_without_threads, rounding1 = bottom_rounding, anchor = BOTTOM);

  up(bottom_height_without_threads - epsilon) threaded_rod(d = id, pitch = thread_pitch,
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

module bit_holder(color = "blue") {
  linear_extrude(bit_holder_hexagon_height) hexagon(d = bit_diameter);

  up(bit_holder_hexagon_height) difference() {
    cyl(d = bit_holder_diameter, h = bit_holder_round_height, anchor=BOTTOM);
  }
}

module bits() { move_bits() bit(); }

module demo(space = 10) {
  up(bottom_height_with_threads + space) %top();
  %bottom();
  bits();
}

bit_holder();
// top();
// demo();
// bottom();
// bit();
