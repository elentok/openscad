include <BOSL2/std.scad>
$fn = 64;

width = 120;
depth = 39.3;
base_thickness = 1.8;
border_width = 1.6;
border_thickness = 2.4;
border_radius = 2;

owidth = width + border_width * 2;
odepth = depth + border_width * 2;

sticker_d = 12;
sticker_h = 1;
sticker_margin = border_width;

module palm_rest() {
  difference() {
    cuboid([ owidth, odepth, base_thickness + border_thickness ],
           rounding = border_radius, except = [ TOP, BOTTOM ], anchor = BOTTOM);

    up(base_thickness + 0.01)
        cuboid([ width, depth, border_thickness ], anchor = BOTTOM);

    x = owidth / 2 - sticker_d / 2 - sticker_margin;
    y = odepth / 2 - sticker_d / 2 - sticker_margin;
    down(0.01) {
      back(y) {
        left(x) sticker_mask();
        right(x) sticker_mask();
      }
      fwd(y) {
        left(x) sticker_mask();
        right(x) sticker_mask();
      }
    }
  }
}

module sticker_mask() { cyl(d = sticker_d, h = sticker_h, anchor = BOTTOM); }

palm_rest();
