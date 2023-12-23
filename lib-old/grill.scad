include <BOSL2/std.scad>
$fn = 64;
epsilon = 0.01;

module grill(d, h, border_width = 0, line_width = 2, space = 3,
             anchor = BOTTOM) {
  outer_diameter = d;
  inner_diameter = d - border_width * 2;
  inner_radius = inner_diameter / 2;

  attachable(anchor, d = d, h = h) {
    linear_extrude(h, center = true) {
      if (border_width > 0) {
        ring2d(od = outer_diameter, id = inner_diameter);
      }

      rect([ inner_diameter + epsilon, line_width ]);
      rect([ line_width, inner_diameter + epsilon ]);
      rotate(45) rect([ inner_diameter + epsilon, line_width ]);
      rotate(-45) rect([ inner_diameter + epsilon, line_width ]);
      // rect([ line_width, inner_diameter + epsilon ]);

      // n circles
      // (n+1) * space + n * line_width = inner_radius
      // n * (space + line_width) + space = inner_radius
      // n = (inner_radius - space) / (space + line_width)
      n = round((inner_radius - space) / (space + line_width));

      // after rounding we need to re-calculate the space so it's accurate
      // (n+1) * space + n * line_width = inner_radius
      // space = (inner_radius - n * line_width) / (n+1);
      space2 = (inner_radius - n * line_width) / (n + 1);

      for (i = [1:n]) {
        id = 2 * space2 * i + 2 * line_width * (i - 1);
        echo("ID", id);
        ring2d(id = id, od = id + line_width * 2);
      }

      circle(d = line_width + space * 2);
    }

    children();
  }
}

module ring2d(od, id) {
  difference() {
    circle(d = od);
    circle(d = id);
  }
}
