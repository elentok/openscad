include <BOSL2/std.scad>
use <../../lib/honeycomb.scad>
$fn = 64;

width_top = 159;
width_bottom = 142;
height = 40;
pattern_padding = 5;
pattern_size =
    [ width_bottom - pattern_padding * 2, height - pattern_padding * 2 ];
thickness = 2;

linear_extrude(thickness, convexity = 4) {
  difference() {
    trapezoid(height, w1 = width_bottom, w2 = width_top, rounding = 6);
    rect(pattern_size);
  }
  honeycomb_rectangle(pattern_size, hexagons = 8);
}
