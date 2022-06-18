$fn = 50;

use <chamfer.scad>

module 2d_hook(width, inner_height, opening_height, thickness) {
  $outer_height = inner_height + 2 * thickness;
  $large_ext_diameter = $outer_height;
  $small_ext_diameter = $outer_height - thickness - opening_height;
  $bottom_square_width = width - $outer_height / 2;
  $top_square_width = $bottom_square_width - $small_ext_diameter / 2;
  $middle_square_width = $top_square_width / 4;

  translate([ -($top_square_width - $middle_square_width) / 2, 0, 0 ]) {
    union() {
      // Base
      union() {
        square([ $bottom_square_width, thickness ]);
        // fillet
        translate([ $bottom_square_width, thickness / 2, 0 ]) {
          circle(d = thickness);
        }
      }

      // Large half-circle
      translate([ 0, $outer_height / 2, 0 ]) {
        half_circle($outer_height, thickness);
      }

      // Top square
      translate([ 0, inner_height + thickness, 0 ]) {
        square([ $top_square_width, thickness ]);
      }

      // Small half circle
      translate([
        $top_square_width, $small_ext_diameter / 2 + opening_height + thickness,
        0
      ]) {
        rotate([ 0, 0, 180 ]) { half_circle($small_ext_diameter, thickness); }
      }

      // Small knob to prevent cables from sliding out
      translate([
        $top_square_width - $middle_square_width, thickness + opening_height, 0
      ]) {
        union() {
          square([ $middle_square_width, thickness ]);
          // fillet
          translate([ 0, thickness / 2, 0 ]) { circle(d = thickness); }
        }
      }

      // Thicken the corner closer to the desk to make it stronger
      //     intersection() {
      // #square($large_ext_diameter);
      //   }
    }
  }
}

module half_circle(outer_diameter, thickness) {
  $inner_diameter = outer_diameter - 2 * thickness;

  difference() {
    circle(d = outer_diameter);
    circle(d = $inner_diameter);

    translate([ 0, -outer_diameter / 2, 0 ]) {
      square([ outer_diameter / 2, outer_diameter ]);
    }
  }
}

module hook(width, depth, inner_height, opening_height, thickness) {
  difference() {
    linear_extrude(depth, center = true) {
      2d_hook(width, inner_height, opening_height, thickness);
    }

    // Screw hole
    translate([ 0, thickness / 2, 0 ]) {
      rotate([ -90, 0, 0 ]) { chamfered_hole(thickness + 0.1, 4, 9); }
    }

    // Top hole (for screwdriver)
    translate([ 0, inner_height + thickness - 0.1, 0 ]) {
      rotate([ -90, 0, 0 ]) { cylinder(d = 8, h = thickness + 0.2); }
    }
  }
}

hook(width = 55, depth = 20, inner_height = 15, opening_height = 5,
     thickness = 3);
