include <BOSL2/std.scad>
$fn = 64;

thickness = 3;
font_size = 20;
font = "Google Sans:style=Bold";

module digit(number) {
  linear_extrude(thickness, convexity = 4) round2d(0.5)
      text(str(number), halign = "center", valign = "center", size = font_size,
           font = font);
}

digit(3);
right(30) digit(6);
right(60) digit(9);
