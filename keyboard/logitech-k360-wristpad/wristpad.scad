include <BOSL2/std.scad>
$fn = 64;

height = 6;
width = 275;
depth = 85;
side_rounding = 5;
top_rounding = 3;

puzzle_depth = depth / 4;
puzzle_width = puzzle_depth * 0.8;
puzzle_tolerance = 0.05;
puzzle_tolerance_h = 0.6;
puzzle_dist = 5;

sticker_d = 14;
sticker_h = 1;
sticker_margin = 4;

feet_d = sticker_d + 2;
feet_h = 4;
feet_margin = 2;

module left_half() {
  difference() {
    cuboid([ width / 2, depth, height ], rounding = top_rounding,
           except = [ BOTTOM, RIGHT ], anchor = RIGHT + BOTTOM);
    back(depth / 4) puzzle_piece(mask = true);
    fwd(depth / 4) puzzle_piece(mask = true);
    // stickers_mask();
  }
  feet();
}

module right_half() {
  // difference() {
  cuboid([ width / 2, depth, height ], rounding = top_rounding,
         except = [ BOTTOM, LEFT ], anchor = LEFT + BOTTOM);
  // mirror([ 1, 0, 0 ]) stickers_mask();
  // }
  mirror([ 1, 0, 0 ]) feet();
  back(depth / 4) puzzle_piece(mask = false);
  fwd(depth / 4) puzzle_piece(mask = false);
}

module puzzle_piece(mask = false) {
  h = mask ? height / 2 : height / 2 - puzzle_tolerance_h;
  up(height - h) linear_extrude(h + 0.01) puzzle_piece_2d(mask);
}

module puzzle_piece_2d(mask = false) {
  w = mask ? puzzle_width + puzzle_tolerance : puzzle_width;
  d = mask ? puzzle_depth + puzzle_tolerance : puzzle_depth;
  ir = mask ? 5 + puzzle_tolerance : 5;

  difference() {
    right(0.01) round2d(ir = ir) {
      left(puzzle_dist) rect([ w, d ], rounding = w / 2, anchor = RIGHT);
      rect([ puzzle_dist * 2, d / 2 ], anchor = RIGHT);
    }
    left(puzzle_dist + w / 2) circle(d = w / 3);
  }
}

module stickers_mask() {
  y = depth / 2 - sticker_d / 2 - sticker_margin;

  left(width / 4) cyl(d = sticker_d, h = sticker_h);

  left(sticker_d / 2 + sticker_margin) {
    back(y) cyl(d = sticker_d, h = sticker_h);
    fwd(y) cyl(d = sticker_d, h = sticker_h);
  }
  left(width / 2 - sticker_d / 2 - sticker_margin) {
    back(y) cyl(d = sticker_d, h = sticker_h);
    fwd(y) cyl(d = sticker_d, h = sticker_h);
  }
}

module feet() {
  left(width / 4) foot();

  left(feet_d / 2 + feet_margin) {
    y = depth / 2 - feet_d / 2;
    back(y) foot();
    fwd(y) foot();
  }

  left(width / 2 - feet_d / 2 - feet_margin) {
    y = depth / 2 - feet_d / 2;
    back(y) foot();
    fwd(y) foot();
  }
}

module foot() {
  difference() {
    cyl(d = feet_d, h = feet_h, anchor = TOP);
    down(feet_h - sticker_h + 0.01)
        cyl(d = sticker_d, h = sticker_h, anchor = TOP);
  }
}

// puzzle_piece_2d();

module demo(space = 10) {
  left_half();
  up(space) color("green") right_half();
}

module test_tolerance() {
  intersection() {
    left_half();
    // right_half();
    cuboid([ puzzle_width * 1.5, depth / 2, height ],
           anchor = FWD + RIGHT + BOTTOM);
  }
}

// test_tolerance();
// demo();
left_half();
// right_half();
