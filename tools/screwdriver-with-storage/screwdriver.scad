include <BOSL2/rounding.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
$fn = 64;

// ========================================
// Variables
// ========================================

// bit_size = "normal";
bit_size = "mini";

epsilon = 0.1;

// For the magnet (I want only one layer above it)
layer_height = 0.2;

bit_diameter = bit_size == "normal" ? 7.3 : 4.3;
bit_width = bit_size == "normal" ? 6.36 : 3.8;
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
bit_holder_hexagon_height = bit_size == "normal" ? 28 : 10;
bit_holder_round_height = 32.5;
// bit_holder_round_inset_height = 10;
bit_holder_tolerance = 0.2;

bits = bit_size == "normal" ? 7 : 3;

top_rounding = 10;
bottom_rounding = bit_size == "normal" ? 3 : 1;
bottom_height_without_threads = bit_size == "normal" ? 7 : 3;
bottom_thickness = 6;
middle_thickness = 2;
side_thickness = 2;
thread_height = 5;  // was 7
thread_thickness = 2.5;
thread_pitch = 2;
thread_tolerance = 0.6;

magnet_d = 20;
magnet_h = 3.72;

bottom_height_with_threads = bottom_height_without_threads + thread_height;
bit_height_inside_bottom = bottom_height_with_threads - bottom_thickness;
bit_height_inside_top = bit_height + bit_height_padding -
                        (bottom_height_without_threads - bottom_thickness);
// top_height = bit_height_inside_top + middle_thickness +
//              bit_holder_hexagon_height + bit_holder_round_inset_height;

echo("Bottom height (with threads):", bottom_height_with_threads);
echo("Bit height inside top:", bit_height_inside_top);
echo("Bit height inside bottom:", bit_height_inside_bottom);

id = bits == 3 ? bit_diameter * 2 + honeycomb_spacing_y + side_thickness * 2
               : bit_width * 3 + honeycomb_spacing_y * 3 + side_thickness * 2;
od = id + thread_thickness;

echo("Outer diameter: ", od);
// echo("Top height:", top_height);

// ========================================
// Helpers
// ========================================

module round_3d_hexagon(d, h, bottom_r = 0, top_r = 0) {
  offset_sweep(hexagon(d = d, rounding = 3), height = h,
               bottom = os_circle(r = bottom_r), top = os_circle(r = top_r),
               steps = 20);
}

function split_path(path, i) = is_undef(i) ? split_path(path, 1)
                               : i >= len(path)
                                   ? []
                                   : concat([[path [i - 1], path [i]]],
                                            split_path(path, i + 1));

// ========================================
// Bottom
// ========================================

module bottom_with_magnet() {
  difference() {
    bottom();

    // magnet
    up(bottom_thickness - layer_height)
        cyl(d = magnet_d, h = magnet_h, anchor = TOP);
  }
}

module bottom() {
  difference() {
    bottom_base();

    // bits
    up(bottom_thickness) move_bits()
        bit_mask(bit_height_inside_bottom + epsilon);
  }
}

module move_bits() {
  x = bit_diameter - bit_width / (2 * sqrt(3)) + honeycomb_spacing_x;
  y = bit_width / 2 + honeycomb_spacing_y / 2;

  if (bits == 3) {
    left(bit_diameter / 2 + honeycomb_spacing_x / 2) {
      back(y) right(x) children();
      children();
      fwd(y) right(x) children();
    }
  } else if (bits == 7) {
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

  else {
    assert(false, "Only supporting 3 or 7 bits");
  }
}

module bit_mask(h) {
  linear_extrude(h, convexity = 4) hexagon(d = bit_diameter + bit_tolerance);
}

module bottom_base() {
  cyl(d = od, h = bottom_height_without_threads, rounding1 = bottom_rounding,
      anchor = BOTTOM);

  up(bottom_height_without_threads - epsilon)
      threaded_rod(d = id, pitch = thread_pitch, h = thread_height + epsilon,
                   end_len = 0.5, anchor = BOTTOM);
}

// ========================================
// Top
// ========================================

w_center = bit_size == "normal" ? 5 : 3;
w1 = od / 2;
w2 = bit_size == "normal" ? 16 / 2 : 16 / 3.5;
w3 = bit_size == "normal" ? 20 / 2 : 20 / 3.5;
w4 = w2;

h0 = 10;
h1 = bit_size == "normal" ? bit_height_inside_top : bit_height_inside_top - 8;
h1to2 = bit_size == "normal" ? 10 : 5;
h2 = 5;
h2to3 = 5;
h3 = bit_size == "normal" ? 10 : 5;
h3to4 = 5;

handle_curve_path = [
  [ 0, 0 ],
  [ w1, 0 ],
  [ w1, h1 / 2 ],
  [ w2, h1 / 2 + h1to2 ],
  [ w2, h1 / 2 + h1to2 + h2 ],
  [ w3, h1 / 2 + h1to2 + h2 + h2to3 ],
  [ w3, h1 / 2 + h1to2 + h2 + h2to3 + h3 ],
  [ w4, h1 / 2 + h1to2 + h2 + h2to3 + h3 + h3to4 ],
  [ 0, h1 / 2 + h1to2 + h2 + h2to3 + h3 + h3to4 ],
];

h_all = h1 + h1to2 + h2 + h2to3 + h3 + h3to4;

module demo_heights() {
  cyl(d = 10, h = h0, anchor = BOTTOM);
  up(h0) cyl(d = 12, h = h1 / 2, anchor = BOTTOM);
}

// demo_heights();

echo("h_all:", h_all);

top_bit_holder_offset = bit_size == "normal"
                            ? bit_height_inside_top + middle_thickness
                            : h_all - bit_holder_hexagon_height;

module top() {
  difference() {
    union() {
      top_bottom();
      top_top();
    }

    // up(thread_height)
    //     cyl(d = id + 0.7, h = bit_height_inside_top - thread_height,
    //         anchor = BOTTOM);
    // down(epsilon / 2) threaded_rod(
    //     d = id + thread_tolerance, pitch = thread_pitch,
    //     h = thread_height + epsilon, anchor = BOTTOM, internal = true);

    up(top_bit_holder_offset + epsilon) bit_holder(mask = true);
  }
}

module top_bottom() {
  hull() {
    up(h0) union() {
      left(w_center / 2) top_bottom_helper();
      right(w_center / 2) mirror([ 1, 0, 0 ]) top_bottom_helper();

      // center
      rotate([ 90, 0, 90 ])
          linear_extrude(w_center, center = true, convexity = 4) {
        top_bottom_polygon();
        mirror([ 1, 0, 0 ]) top_bottom_polygon();
      }
    }

    cyl(r = w1, h = 1, anchor = BOTTOM);
  }
}

module top_bottom_helper() {
  rotate([ 0, 0, 90 ]) rotate_extrude(angle = 180) top_bottom_polygon();
}

module top_bottom_polygon() {
  polygon(path_join(
      split_path([ [ 0, 0 ], [ w1, 0 ], [ w1, h1 / 2 ], [ 0, h1 / 2 ] ]),
      joint = 3));
}

module top_top() {
  up(h1 / 2) {
    left(w_center / 2) half_top_top();
    right(w_center / 2) mirror([ 1, 0, 0 ]) half_top_top();

    top_top_center();
  }
}

module half_top_top() {
  rotate([ 0, 0, 90 ]) rotate_extrude(angle = 180)
      polygon(path_join(split_path(handle_curve_path), joint = 3));
}

module half_top_top_center2d() {
  polygon(path_join(split_path(handle_curve_path), joint = 3));
}

module top_top_center() {
  rotate([ 90, 0, 90 ]) linear_extrude(w_center, center = true, convexity = 4) {
    half_top_top_center2d();
    mirror([ 1, 0, 0 ]) half_top_top_center2d();
  }
}

// ========================================
// Demo
// ========================================

module demo(space = 4) {
  up(bottom_height_without_threads + space) {
    top();
    up(bit_height_inside_top + middle_thickness + space * 1.5) bit_holder();
  }
  bottom();
  move_bits() bit();
}

module bit(color = "green") {
  color(color) hull() {
    up(bit_height - 0.25) rotate([ 0, 90, 0 ])
        cyl(d = 0.5, h = bit_diameter * 0.8);
    linear_extrude(bit_height - bit_head_height) hexagon(d = bit_diameter);
  }
}

module bit_holder(color = "cyan", mask = false) {
  if (bit_size == "normal") {
    normal_bit_holder(color, mask);
  } else {
    mini_bit_holder(color, mask);
  }
}

module mini_bit_holder(color = "cyan", mask = false) {
  bit_d = bit_diameter + (mask ? bit_holder_tolerance : 0);
  linear_extrude(bit_holder_hexagon_height, convexity = 4) hexagon(d = bit_d);
}

module normal_bit_holder(color = "cyan", mask = false) {
  bit_d = bit_diameter + (mask ? bit_holder_tolerance : 0);
  round_d = bit_holder_diameter + (mask ? bit_holder_tolerance : 0);

  color(color) {
    linear_extrude(bit_holder_hexagon_height, convexity = 4) hexagon(d = bit_d);

    up(bit_holder_hexagon_height - epsilon) difference() {
      cyl(d = bit_holder_diameter, h = bit_holder_round_height,
          anchor = BOTTOM);

      if (!mask) {
        up(1) linear_extrude(bit_holder_round_height, convexity = 4)
            hexagon(d = bit_diameter);
      }
    }
  }
}

// bottom_with_magnet();
bottom();
// top();
// demo();
