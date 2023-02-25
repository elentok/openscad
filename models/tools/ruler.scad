include <BOSL2/std.scad>
$fn = 64;

centimeters = 15;
ruler_size = [ centimeters * 10, 30, 2 ];
step_size = [ 1, 5, 1 ];
step_text_margin = 3;
step_text_size = 5;
// step_font = "Arial:style=Bold";
step_font = "Google Sans:style=Bold";
nothing = 0.1;
name = "Enter name here";
name_size = 7;
name_margin = 3;

module ruler() {
  linear_extrude(ruler_size.z)
      rect([ ruler_size.x, ruler_size.y ], rounding = 2, anchor = LEFT + FWD);

  for (i = [1:centimeters - 1]) {
    right(i * 10) step(i);
  }

  for (i = [0:centimeters - 1]) {
    right(5 + i * 10) half_step();
  }

  back(ruler_size.y - name_margin) right(ruler_size.x / 2)
      up(ruler_size.z - nothing) linear_extrude(step_size.z)
          text(name, size = name_size, font = step_font, anchor = BACK);
}

module step(i) {
  r = 0.2;
  up(ruler_size.z - nothing) {
    back(step_size.y + step_text_margin) linear_extrude(step_size.z)
        offset(r = -r) offset(r = r) text(str(i), size = step_text_size,
                                          font = step_font, anchor = BOTTOM);
    linear_extrude(step_size.z)
        rect([ step_size.x, step_size.y ], anchor = BOTTOM,
             rounding = step_size.x / 2);
  }
}

module half_step() {
  up(ruler_size.z - nothing) {
    linear_extrude(step_size.z)
        rect([ step_size.x, step_size.y / 2 ], anchor = BOTTOM,
             rounding = step_size.x / 2);
  }
}

ruler();
// step();
