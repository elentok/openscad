include <BOSL2/rounding.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

epsilon = 0.1;

bit_diameter = 7.3;
bit_width = 6.36;
bit_height = 25;
bit_height_padding = 5;
bit_head_height = 8;
bit_tolerance = 0.3;
bit_spacing_x = 2.5;
bit_spacing_y = 3;
honeycomb_spacing = 1;
honeycomb_spacing_x = honeycomb_spacing / sqrt(2);
honeycomb_spacing_y = honeycomb_spacing / sqrt(2);

bit_holder_diameter = 9.9;
bit_holder_hexagon_height = 28;
bit_holder_round_height = 32.5;
bit_holder_round_inset_height = 10;
bit_holder_tolerance = 0.2;

bits = 6;

top_rounding = 10;
bottom_rounding = 5;
bottom_height_without_threads = 7;
bottom_thickness = 5;
middle_thickness = 2;
side_thickness = 2;
thread_height = 7;
thread_thickness = 2.5;
thread_pitch = 2;
thread_tolerance = 0.6;

bottom_height_with_threads = bottom_height_without_threads + thread_height;
bit_height_inside_bottom = bottom_height_with_threads - bottom_thickness;
bit_height_inside_top =
    bit_height + bit_height_padding - bit_height_inside_bottom;
top_height = bit_height_inside_top + middle_thickness +
             bit_holder_hexagon_height + bit_holder_round_inset_height;

echo("Bottom height (with threads):", bottom_height_with_threads);
echo("Bit height inside top:", bit_height_inside_top);
echo("Bit height inside bottom:", bit_height_inside_bottom);

id = bits == 3 ? bit_diameter * 2 + side_thickness * 2
               : bit_width * 3 + honeycomb_spacing_y * 3 + side_thickness * 2;
od = id + thread_thickness;

echo("Outer diameter: ", od);
echo("Top height:", top_height);

module round_3d_hexagon(d, h, bottom_r = 0, top_r = 0) {
  offset_sweep(hexagon(d = d, rounding = 3), height = h,
               bottom = os_circle(r = bottom_r), top = os_circle(r = top_r),
               steps = 20);
}

module top() {
  difference() {
    hull() {
      cyl(d = od, h = bit_height_inside_top, anchor = BOTTOM, rounding2 = 1);
      // up(top_height * 0.75) linear_extrude(4) hexagon(d = od, rounding = 3);
      // up(top_height) linear_extrude(1) hexagon(d = od / 2, rounding = 3);
      up(top_height * 0.75)
          round_3d_hexagon(od, h = 6, bottom_r = 3, top_r = 3);
      up(top_height) round_3d_hexagon(od / 2, h = 2, bottom_r = 2);
    }
    // cyl(d = od, h = top_height, anchor = BOTTOM, rounding2 = top_rounding);
    up(thread_height)
        cyl(d = id, h = bit_height_inside_top - thread_height, anchor = BOTTOM);
    down(epsilon / 2) threaded_rod(
        d = id + thread_tolerance, pitch = thread_pitch,
        h = thread_height + epsilon, anchor = BOTTOM, internal = true);

    up(bit_height_inside_top + middle_thickness + epsilon)
        bit_holder(mask = true);

    // top_fingers_mask();
  }
}

module top_fingers_mask() {
  n = 7;
  angle = 360 / n;

  for (i = [1:n]) {
    rotate([ 0, 0, angle * (i - 1) ]) right(od / 2 + 7) scale([ -0.3, -0.3, 1 ])
        sphere(d = top_height, anchor = BOTTOM);
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
  x = bit_diameter - bit_width / (2 * sqrt(3)) + honeycomb_spacing_x;
  y = bit_width / 2 + honeycomb_spacing_y / 2;

  if (bits == 3) {
    up(bottom_thickness) left(bit_diameter / 2 + honeycomb_spacing_x / 2) {
      back(y) right(x) children();
      children();
      fwd(y) right(x) children();
      // left(bit_diameter / 2 + bit_spacing_x / 2) children();
      // right(bit_diameter / 2 + bit_spacing_x / 2) children();
      //
      // back(bit_width / 2 + bit_spacing_y / 2) children();
      // fwd(bit_width / 2 + bit_spacing_y / 2) children();
    }
  }

  else if (bits == 6) {
    // x = bit_diameter / 2 + honeycomb_spacing_x / 2;
    // y = bit_width / 2 + honeycomb_spacing_y / 2;
    up(bottom_thickness) {
      children();
      back(y * 2) children();
      fwd(y * 2) children();

      right(x) {
        back(y) children();
        fwd(y) children();
      }

      left(x) {
        back(y) children();
        fwd(y) children();
      }
    }
  }

  else {
    assert(false, "Only supporting 4 or 6 bits");
  }
}

module bit_mask(h) {
  linear_extrude(h) hexagon(d = bit_diameter + bit_tolerance);
}

module bottom_base() {
  cyl(d = od, h = bottom_height_without_threads, rounding1 = bottom_rounding,
      anchor = BOTTOM);

  up(bottom_height_without_threads - epsilon)
      threaded_rod(d = id, pitch = thread_pitch, h = thread_height + epsilon,
                   end_len = 0.5, anchor = BOTTOM);

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

module bit_holder(color = "cyan", mask = false) {
  bit_d = bit_diameter + (mask ? bit_holder_tolerance : 0);
  round_d = bit_holder_diameter + (mask ? bit_holder_tolerance : 0);

  color(color) {
    linear_extrude(bit_holder_hexagon_height) hexagon(d = bit_d);

    up(bit_holder_hexagon_height - epsilon) difference() {
      cyl(d = bit_holder_diameter, h = bit_holder_round_height,
          anchor = BOTTOM);

      if (!mask) {
        up(1) linear_extrude(bit_holder_round_height) hexagon(d = bit_diameter);
      }
    }
  }
}

module bits() { move_bits() bit(); }

module demo(space = 4) {
  up(bottom_height_without_threads + space) {
    % top();
    up(bit_height_inside_top + middle_thickness + space * 1.5) bit_holder();
  }
  bottom();
  bits();
}

// bit_holder();
// top();
// demo();
// bottom();
// bit();

// pth = [
//   [ 0, 0 ],
//   [ 0, 27 ],
//   [ 30, 27 ],
//   [ 40, 16 ],
//   [ 50, 16 ],
//   [ 70, 20 ],
//   [ 80, 20 ],
//   [ 80, 0 ],
// ];
// // polygon(smooth_path(pth));
// stroke(pth, width = 1, color = "green");
// stroke(smooth_path(pth, size = 3), width = 1);

w1 = 27 / 2;
w2 = 16 / 2;
w3 = 20 / 2;
w4 = 16 / 2;

h1 = 30;
h1to2 = 15;
h2 = 5;
h2to3 = 5;
h3 = 10;
h3to4 = 5;

path = [
  [ 0, 0 ],
  [ w1, 0 ],
  [ w1, h1 ],
  [ w2, h1 + h1to2 ],
  [ w2, h1 + h1to2 + h2 ],
  [ w3, h1 + h1to2 + h2 + h2to3 ],
  [ w3, h1 + h1to2 + h2 + h2to3 + h3 ],
  [ w4, h1 + h1to2 + h2 + h2to3 + h3 + h3to4 ],
  [ 0, h1 + h1to2 + h2 + h2to3 + h3 + h3to4 ],
];

function split_path(path, i) = is_undef(i) ? split_path(path, 1)
                               : i >= len(path)
                                   ? []
                                   : concat([[path [i - 1], path [i]]],
                                            split_path(path, i + 1));

// pth1 = [ [ 0, 0 ], [ 0, 27 ] ];
paths = [
  [ [ 0, 0 ], [ w1, 0 ] ],
  [[w1, 0], [w1, h1]],
  [[w1, h1], [w2, h1 + h1to2]],
  [[w2, h1 + h1to2], [w2, h1 + h1to2 + h2]],
  [[w2, h1 + h1to2 + h2], [w3, h1 + h1to2 + h2 + h2to3]],
  [[w3, h1 + h1to2 + h2 + h2to3], [w3, h1 + h1to2 + h2 + h2to3 + h3]],
  [[w3, h1 + h1to2 + h2 + h2to3 + h3], [0, h1 + h1to2 + h2 + h2to3 + h3]],
];

module half_body() {
  rotate_extrude(angle = 180) polygon(path_join(split_path(path), joint = 3));
}

half_body();

// up(h1 + h1to2 + h2 + h2to3) linear_extrude(h3)
//     hexagon(r = w3 + 2, rounding = 2);
// star(n = 10, r = w3 + 1, ir = w3);

// stroke(path_join(paths, joint = 3), width = 1, color = "green");
// stroke(flatten([ pth1, pth2 ]), width = 1);
// rotate_extrude() right(0.5)
//     stroke(path_join(paths, joint = 3), width = 1, color = "green");
