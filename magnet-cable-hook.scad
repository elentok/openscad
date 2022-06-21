$fn = 50;

use <cable-hook.scad>
use <lib/magnet-holder.scad>

module magnet_hook(width, depth, inner_height, opening_height, thickness) {
  holder_width = width / 2;
  holder_depth = 2.7;

  union() {
    linear_extrude(depth, center = true) {
      2d_hook(width, inner_height, opening_height, thickness);
    }

    translate([ -holder_width / 2, -holder_depth / 2, 0 ]) {
      rotate([ 90, 0, 0 ]) {
        magnet_holder(width = holder_width, height = depth,
                      depth = holder_depth);
      }
    }

    translate([ holder_width / 2, -holder_depth / 2, 0 ]) {
      rotate([ 90, 0, 0 ]) {
        magnet_holder(width = holder_width, height = depth,
                      depth = holder_depth);
      }
    }
  }
}

magnet_hook(width = 47, depth = 20, inner_height = 15, opening_height = 5,
            thickness = 2.5);
