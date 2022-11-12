include <BOSL2/std.scad>
$fn = 64;

number_size = [ 17, 25 ];
spacing = 8;
padding = 7;
numbers = 10;
rounding = 5;
thickness = 2;
font = "Google Sans:style=Bold";
rows = 2;
numbers_per_row = numbers / rows;

// number_xoffsets = [ 0, -1.2, 0, 0, 0, 0, 0, 0, 0, 0 ];

stencil_size = [
  numbers_per_row * number_size.x + spacing * (numbers_per_row - 1) +
      padding * 2,
  rows *number_size.y + spacing *(rows - 1) + padding * 2,
];

echo("Stencil Size:", stencil_size);

module stencil() { linear_extrude(thickness) stencil2d(); }

module stencil2d() {
  union() {

    difference() {
      rect(stencil_size, rounding = rounding, anchor = LEFT);
      numbers_mask();
    }

    number_supports();
  }
}

module numbers_mask() {
  yoffset = number_size.y / 2 + spacing / 2;

  for (i = [0:4]) {
    xoffset = padding + number_size.x / 2 + i * (number_size.x + spacing);
    back(yoffset) right(xoffset) number_mask(str(i));

    // debugging
    // right(xoffset) #rect(number_size);
  }

  for (i = [5:9]) {
    xoffset = padding + number_size.x / 2 + (i - 5) * (number_size.x + spacing);
    fwd(yoffset) right(xoffset) number_mask(str(i));

    // debugging
    // right(xoffset) #rect(number_size);
  }
}

module number_mask(text, xoffset = 0) {
  right(xoffset) text(text, halign = "center", valign = "center",
                      size = number_size.y, font = font);
}

module number_supports() {
  right(padding + number_size.x / 2)
      rect([ 2, number_size.y + spacing ], anchor = FWD);

  fwd(number_size.y / 2)
      right(padding + number_size.x / 2 + number_size.x + spacing)
          rect([ 2, number_size.y / 2 ], anchor = BACK);
}

stencil();
