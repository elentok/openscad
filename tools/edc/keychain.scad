include <BOSL2/std.scad>
$fn = 64;

// size = [ 60, 28, 3 ];
size = [ 50, 20, 2.5 ];

rounding = size.y / 2;
hole_diameter = 6;
hole_margin = 5;

lines = [ "line1", "line2" ];
line_spacing = 1;
font = "Arial:style=Bold";
text_size = size.y * 0.35;
text_offset = 4;

echo("TEXT SIZE", text_size);

module keychain() {
  difference() {
    linear_extrude(size.z, convexity = 4, center = true) {
      diff() {
        rect([ size.x, size.y ], rounding = rounding) {
          tag("remove") right(hole_margin) position(LEFT)
              circle(d = hole_diameter, anchor = LEFT);
        };
      }
    }

    if (len(lines) == 1) {
      right(text_offset) up(0.01) linear_extrude(size.z / 2) round2d(r = 0.2)
          text(lines[0], font = font, size = text_size, anchor = CENTER,
               spacing = 0.95);
    } else {
      back(text_size / 2 + line_spacing / 2) text_mask(lines[0]);
      fwd(text_size / 2 + line_spacing / 2) text_mask(lines[1]);
    }
  }
}

module text_mask(text) {
  right(text_offset) up(0.01) linear_extrude(size.z / 2) round2d(r = 0.3) text(
      text, font = font, size = text_size, anchor = CENTER, spacing = 0.95);
}

keychain();
